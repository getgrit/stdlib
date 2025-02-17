---
title: use `flask.jsonify()`
tags: [fix, best-pactice, flask]
---

`flask.jsonify()` simplifies returning `JSON` from `Flask` routes by automatically serializing Python objects into JSON format and setting the appropriate Content-Type header, resulting in cleaner and more readable code while ensuring consistency and compatibility with web standards.

### references

- [flask.json.jsonify](https://flask.palletsprojects.com/en/2.2.x/api/#flask.json.jsonify)

```grit
engine marzano(0.1)
language python

`@app.route($routesParams)
def $func($funcParams):$funcBody` where {
	$import = "jsonify",
	$import <: ensure_import_from(source=`flask`),
	$funcBody <: contains or {
		`return json.dumps($user_dict)`,
		`return dumps($user_dict)`
	} => `return jsonify($user_dict)`
}
```

## with `json.dumps`

```python
import flask
import json
app = flask.Flask(__name__)

@app.route("/user")
def user():
    user_dict = get_user(request.args.get("id"))
    return json.dumps(user_dict)
```

```python
import flask
import json
from flask import jsonify

app = flask.Flask(__name__)

@app.route("/user")
def user():
    user_dict = get_user(request.args.get("id"))
    return jsonify(user_dict)
```

## with dumps

```python
from json import dumps

@app.route("/user")
def user():
    user_dict = get_user(request.args.get("id"))
    # ruleid:use-jsonify
    return dumps(user_dict)
```

```python
from json import dumps
from flask import jsonify

@app.route("/user")
def user():
    user_dict = get_user(request.args.get("id"))
    # ruleid:use-jsonify
    return jsonify(user_dict)
```

## normal function

```python
def dumps():
  pass
def test_empty_dumps():
    dumps()
```
