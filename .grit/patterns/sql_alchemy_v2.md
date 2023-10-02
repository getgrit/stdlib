---
title: SQL Alchemy v1 -> v2
---

Convert SQL Alchemy v1 to v2.

tags: #python, #alpha, #hidden

```grit
engine marzano(0.1)
language python

// This pattern is a WIP WORK
// It is not ready for production use

pattern bulk_update() {
    `$x.update($details, $exec_options)` where {
        $x <: contains `$_.query($model)`,
        $new_statement = `update($model)`,
        // add where/filter clauses
        $x <: maybe contains bubble($new_statement) `$_.filter($filters)` where {
            $new_statement += `.where($filters)`
        },

        // adjust values
        $values = [],
        $details <: contains bubble($values) {
            pair($key, $value) where $values += `$key=$value`
        },
        $new_values = join(list=$values, separator=", "),
        $new_statement += `.values($new_values)`,

        // Add execution options
        $new_statement += `.execution_options($exec_options)`

    } => `with Session(engine, future=True) as sess:
    stmt = ($new_statement)

    sess.execute(stmt)`
}

pattern convert_to_subquery() {
    `$var = select($args)` where {
        $program <: contains `select($query)` where {
            $query <: contains $var
        }
    } => `$var = select($args).subquery()`
}

// this pattern can probably be more general
pattern c_to_selected_columns() {
    `$x.where($args)` where {
        $args <: contains bubble($x) `$x.c.$b` => `$x.selected_columns.$b`
    }
}

pattern select_list_to_vargs() {
    `select([$args])` => `select($args)`
}


pattern session_scalars($selection, $stmt, $expr) {
    `session.scalars(select($selection).from_statement($stmt1)).all()` =>
    `session.scalars(
    select($selection)
    .from_statement($stmt)
    .options(with_expression($expr, $stmt.selected_columns.some_literal))
).all()` where {
        // todo come up with a better way to handle this
        $stmt1 == $stmt
    }
}

pattern select_options($var, $selection, $expr) {
    `$var = select($selection).options(with_expression($expr, $literal))`
    => `$var = select($selection, $literal.label("some_literal"))`
}

pattern no_nested_with_expr() {
    `$stmt = union_all($args)` where  {
        // todo add all replace some
        $args <: some bubble($selection, $expr) $var where {
            $program <: contains select_options($var, $selection, $expr)
        },
        $program <: contains session_scalars($selection, $stmt, $expr)
    }
}

pattern get_directly_on_session() {
    `$sess.query($cls).get($id)` => `$sess.get($cls, $id)`
}

pattern cmp_statements() {
    r"^.+ (?:(?:==)|(?:>=)|(?:<=)|>|<) .+(?: (?:and)|(?:or) .+ (?:(?:==)|(?:>=)|(?:<=)|>|<) .+)*$",
}

pattern migrate_old_select_args($call_chain, $args) {
    $stmt where {
        if ($args <: contains list(elements=$items)) {
            $call_chain += `select($items)`,
        } else {
            $call_chain += `select()`,
        },
        $args <: maybe contains keyword_argument(name=`select_from`, value=$table) where {
            $call_chain += `select_from($table)`,
        },
        $args <: maybe contains keyword_argument(name=`order_by`, value=$col) where {
            $call_chain += `order_by($col)`,
        },
        $args <: maybe contains cmp_statements() as $cmp_stmt where {
            $call_chain += `where($cmp_stmt)`,
        },
        $new_stmt = join(list = $call_chain, separator = "."),
        $stmt => `$new_stmt`,
    }
}

pattern migrate_pre_1_4_select() {
    $call_chain = [],
    or {
        `select($args)`,
        `$table.select($args)` where {
            $call_chain += `$table`,
        },
    } as $stmt where {
        or {
            $args <: contains list(),
            $args <: contains keyword_argument(),
            $args <: contains cmp_statements(),
        },
        $stmt <: migrate_old_select_args($call_chain, $args),
    },
}

pattern migrate_post_1_4_create_legacy_select() {
    $call_chain = [],
    or {
        `create_legacy_select($args)`,
        `$table.create_legacy_select($args)` where {
            $call_chain += `$table`,
        },
    } as $stmt where {
        $stmt <: migrate_old_select_args($call_chain, $args),
    },
}

pattern migrate_executes() {
    `$var.execute($param)` where {
        $var <: or {
            `connection`,
            `conn`,
            `session`,
            `sess`,
            `c`,
            `s`,
        },
        $param <: not `text($_)`,
        $param => `text($param)`,
        $text = `text`,
        $text <: ensure_import_from(source=`sqlalchemy`),
    }
}

pattern change_declarative_base() {
    $body where {
        $body <: contains `from sqlalchemy.ext.declarative import declarative_base` => . where {
            $to_import = `declarative_base`,
            $to_import <: ensure_import_from(source=`sqlalchemy.orm`),
        },
        $body <: contains `$var = declarative_base($params)` => `
class Base:
    __allow_unmapped__ = True

$var = declarative_base(cls=Base,$params)
`
    }
}

file($body) where $body <: any {
    contains bulk_update(),
    contains convert_to_subquery(),
    contains c_to_selected_columns(),
    contains select_list_to_vargs(),
    contains no_nested_with_expr(),
    contains get_directly_on_session(),
    contains migrate_pre_1_4_select(),
    contains migrate_post_1_4_create_legacy_select(),
    contains migrate_executes(),
    contains change_declarative_base(),
}
```

## Upgrades to SQL Alchemy v2

Use the [query API](https://docs.sqlalchemy.org/en/20/changelog/migration_14.html#orm-query-is-internally-unified-with-select-update-delete-2-0-style-execution-available)

```python
session.query(User).filter(User.name == "sandy").update({ password: "foobar", other: "thing" }, synchronize_session="fetch")

stmt1 = select(user.c.id, user.c.name)
stmt2 = select(user.c.id, user.c.name)
stmt3 = select(addresses, stmt2).select_from(addresses.join(stmt1))

stmt = select(users)
stmt = stmt.where(stmt.c.name == "foo")

stmt = select([table.c.col1, table.c.col2, ...])

s1 = select(User).options(with_expression(User.expr, literal("u1")))
s2 = select(User).options(with_expression(User.expr, literal("u2")))

stmt = union_all(s1, s2)
session.scalars(select(User).from_statement(stmt)).all()

user_obj = session.query(User).get(5)
```

```python
with Session(engine, future=True) as sess:
    stmt = (update(User).where(User.name == "sandy").values(password="foobar", other="thing").execution_options(synchronize_session="fetch"))

    sess.execute(stmt)

stmt1 = select(user.c.id, user.c.name)
stmt2 = select(user.c.id, user.c.name).subquery()
stmt3 = select(addresses, stmt2).select_from(addresses.join(stmt1))

stmt = select(users)
stmt = stmt.where(stmt.selected_columns.name == "foo")

stmt = select(table.c.col1, table.c.col2, ...)

s1 = select(User, literal("u1").label("some_literal"))
s2 = select(User, literal("u2").label("some_literal"))

stmt = union_all(s1, s2)
session.scalars(
    select(User)
    .from_statement(stmt)
    .options(with_expression(User.expr, stmt.selected_columns.some_literal))
).all()

user_obj = session.get(User, 5)
```

# Migrate pre 1.4 select and post 1.4 legacy select statements

```python
stmt = select([1], select_from=table, order_by=table.c.id)

stmt = select([table.c.x], table.c.id == 5)

stmt = table.select(table.c.id == 5)

stmt = select([table.c.x, table.c.y])

stmt = create_legacy_select([table.c.x, table.c.y])
```

```python
stmt = select(1).select_from(table).order_by(table.c.id)

stmt = select(table.c.x).where(table.c.id == 5)

stmt = table.select().where(table.c.id == 5)

stmt = select(table.c.x, table.c.y)

stmt = select(table.c.x, table.c.y)
```

# Migrate SQL executions

```python
sess.execute("SELECT * FROM some_table")

sess.execute(text("SELECT * FROM some_table"))

conn.execute("SELECT * FROM some_table")
```

```python
from sqlalchemy import text

sess.execute(text("SELECT * FROM some_table"))

sess.execute(text("SELECT * FROM some_table"))

conn.execute(text("SELECT * FROM some_table"))
```

# Change declarative_base import

```python
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
```

```python
from sqlalchemy.orm import declarative_base




class Base:
    __allow_unmapped__ = True

Base = declarative_base(cls=Base)

```
