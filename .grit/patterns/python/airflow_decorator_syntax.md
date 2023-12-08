---
title: Use modern decorator syntax to define airflow DAGs.
---

Airflow supports decorator syntax (`@task`, `@dag`) for defining workflows.
It is recommended to use them over the legacy python classes.

```grit
engine marzano(0.1)
language python

// matches an assignment where the LHS is a variable and the RHS is a `airflow.DAG` call.
pattern dag_definition($var, $dag, $kwargs) {
  `$var = $dag` where {
      $dag <: `DAG($kwargs)`
  }
}

// collect all kwargs from a function call, and return them in a list.
// The following kwargs are ignored: `dag`, `python_callable`.
pattern collect_kwargs($kwargs) {
  call($arguments) where {
    $kwargs = [],
    $arguments <: contains bubble($kwargs) keyword_argument($name) as $kwarg where {
      if (!$name <: or { `dag`, `python_callable` }) {
        $kwargs += $kwarg
      }
    }
  }
}

// Add @task decorators on any functions that are referenced as python_callables in task definitions,
// and replace all references to the operator instantiation with the function itself.
pattern add_task_decorators() {
  `$parent_func` where {
    // find all nested function defs that are referenced in a task instantiation.
    // then: 1) add @task decorator, and 2) replace all task instances with the name of the function.
    $parent_func <: contains bubble($parent_func) function_definition($name) as $task_func where {
      $parent_func <: contains bubble($name, $task_func) call($arguments) as $call where {
        $arguments <: contains keyword_argument(name=`python_callable`, value=$name),
        $call <: collect_kwargs($kwargs),
        $decorator_args = join(list=$kwargs, separator=", "),
        $task_func => `@task($decorator_args)\n$task_func`,
      },
    }
  }
}

// matches any function that has a DAG return type.
pattern function_returning_DAG(
  $return_type,
  $body,
  $name,
  $parameters,
  $kwargs
) {
  function_definition($name, $parameters, $return_type, $body) as $function where {
    $body <: contains dag_definition(var=$dag_varname, $dag, $kwargs) as $dag_decl,
    // If there are any tasks that resolve to a python callable,
    // then add a @task decorators to those callables.
    $function <: maybe add_task_decorators(),
    $function <: contains bubble($dag_varname) keyword_argument(name=`dag`) as $kwarg where {
      $kwarg => .
    },

    // collect all references to the `dag` variable.
    $dag_var_refs = [],
    $function <: maybe contains bubble($dag_decl, $dag_varname, $dag_var_refs) identifier() as $ref where {
      $ref <: and { !within assignment(left=$dag_varname), $dag_varname, !within keyword_argument() },
      $dag_var_refs += $ref
    },
    // if there is no reference outside of a kwarg, remove the declaration 
    if ($dag_var_refs <: .) {
      $dag_decl => .
    }
  }
}

// add the @dag decorator to any function that returns a DAG
pattern add_dag_decorator() {
  function_returning_DAG($return_type, $body, $name, $parameters, $kwargs) =>
    `@dag($kwargs)
def $name($parameters):
    $body`
}


// Matches an assignment where the RHS is a call to `${_}Operator(python_callable=$task_func_name, ...)`,
// and the LHS is $old_task_name.
pattern task_decl_with_python_callable($old_task_name, $task_func_name) {
  `$old_task_name = $_($args)` where {
    $old_task_name <: identifier(),
    $args <: contains keyword_argument(name=`python_callable`, value=$task_func_name) where {
      $task_func_name <: identifier()
    }
  }
}


// Replace all python_callable tasks with their @task decorated functions.
pattern replace_task_refs() {
  function_definition() as $dag_func where {
    // 1. find task declartions
    $dag_func <: contains bubble($dag_func) task_decl_with_python_callable($old_task_name, $task_func_name) as $decl where {
      $dag_func <: contains bubble($old_task_name, $decl, $task_func_name) identifier() as $ref where {
        $ref <: $old_task_name,
        $ref => $task_func_name
      },
      $decl => .
    }
  }  
}


pattern is_task_ref() {
  identifier() as $ref where {
    $ref <: within function_definition() as $dag_func where {
      $dag_func <: or {
        contains decorated_definition($decorators, $definition) where {
          $decorators <: some { decorator(value=call(function=`task`)) },
          $definition <: function_definition(name=$task_name),
          $ref <: $task_name
        },

        contains `$taskname = $operator($_)` where {
          // ref: https://airflow.apache.org/docs/apache-airflow/stable/_api/airflow/operators/weekday/index.html
          $operator <: or {
            `BashOperator`,
            `BooleanOperator`,
            `EmptyOperator`,
            `BaseBranchOperator`,
            `EmailOperator`,
            `PythonOperator`,
            `SmoothOperator`,
            `BranchDayOfWeekOperator`
          },
          $ref <: $taskname 
        }
      }
      
    }
  }
}

pattern rewrite_chaining() {
  binary_operator(operator=$op, left=$a, right=$b) where {
    $op <: or { ">>", "<<" },
    or {
      $a <: is_task_ref(),
      $b <: is_task_ref()
    },
    $out = `chain($a, $b)`,
    if ($op <: "<<") {
      $out = `chain($b, $a)`
    }
  } => `$out`  
}


sequential {
  contains add_dag_decorator(),
  maybe contains replace_task_refs(),
  maybe contains rewrite_chaining(),
}

```

## Works as expected on functions that represent DAGs

```python
def do_my_thing() -> DAG:
    dag = DAG(description="My cool DAG")
    def do_thing(**context: T.Any) -> bool:
        return not aws_rds.db_exists(region=get_variable(EnvVarKeys.TARGET))
    def do_thing_two(**context: T.Any) -> bool:
        pass
    other_operator = ShortCircuitOperator(
        dag=dag,
        task_id='do_db_thing',
        python_callable=do_thing,
        provide_context=True,
    )
    operator_two = PythonOperator(python_callable=do_thing_two)
    other_operator >> operator_two
```

```python
@dag(description="My cool DAG")
def do_my_thing():
    
    @task(task_id='do_db_thing', provide_context=True)
    def do_thing(**context: T.Any) -> bool:
        return not aws_rds.db_exists(region=get_variable(EnvVarKeys.TARGET))
    @task()
    def do_thing_two(**context: T.Any) -> bool:
        pass
    
    
    chain(do_thing, do_thing_two)
```

## Does not affect functions that do not work with dags

```python
def not_a_dag():
  dag = notDAG()
  return dag
```

```python
def not_a_dag():
  dag = notDAG()
  return dag
```

## Removes any references to the `dag` variable.

Removing the `dag` reference from kwargs will still retain the intended behavior,
since the Operator is instantiated inside a `@dag()` decorator context.

```python
def my_dag():
  dag = DAG()
  o1 = EmptyOperator(dag=dag)
  o2 = EmptyOperator(dag=dag,foo=bar)
  return o1 >> o2
```

```python
@dag()
def my_dag():
    
    o1 = EmptyOperator()
    o2 = EmptyOperator(foo=bar)
    return chain(o1, o2)
```

## Preserves the order of operations when re-writing `>>` and `<<` to `chain` calls.

```python
def some_dag():
    dag = DAG()
    first = BashOperator(dag=dag,bash_command="echo hello")
    second = EmptyOperator(dag=dag)
    # second is upstream of first
    first << second
```

```python
@dag()
def some_dag():
    
    first = BashOperator(bash_command="echo hello")
    second = EmptyOperator()
    # second is upstream of first
    chain(second, first)
```

## Does not remove the `dag` variable if it used in places other than task operators

If the `dag` variable is used someplace other than the keyword arguments of a operator,
then the variable `dag = DAG()` should not be removed.

```python
def some_dag():
    dag = DAG()
    def print_dag():
        print(dag)
    t1 = PythonOperator(dag=dag,python_callable=print_dag)
    t2 = PythonOperator(dag=dag,python_callable=print_dag)
    t1 >> t2
```

```python
@dag()
def some_dag():
    dag = DAG()
    @task()
    def print_dag():
        print(dag)
    
    
    chain(print_dag, print_dag)
```

## Works when a non-python-callable task is chained with a python-callable task

```python
def some_dag():
    dag = DAG()
    def print_dag():
        print(dag)
    t1 = PythonOperator(dag=dag,python_callable=print_dag)
    t2 = BashOperator(dag=dag,bash_command="echo 1") 
    t1 >> t2
```

```python
@dag()
def some_dag():
    dag = DAG()
    @task()
    def print_dag():
        print(dag)
    
    t2 = BashOperator(bash_command="echo 1") 
    chain(print_dag, t2)
```
