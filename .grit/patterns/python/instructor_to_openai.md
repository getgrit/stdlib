# Switch from Instructor to OpenAI Structured Outputs

OpenAI recently released [structured outputs](https://openai.com/index/introducing-structured-outputs-in-the-api/), which removes some of the complexity of using [Instructor](https://github.com/jxnl/instructor) or other structured output libraries.

This pattern will transform your existing code to use the new structured outputs API.

```grit
engine marzano(0.1)
language python

`$call.$create($args)` where {
    // Change the method
    $create <: `create` => `parse`,
    // Change the arg
    $args <: contains `response_model=$model` => `response_format=$model`,
    // We need to actually extract the parsed value
    $call <: maybe within `$var = $_` as $assignment where {
        $assignment += `
if $var.choices[0].message.refusal:
    raise Exception(f"GPT refused to comply! {$var.choices[0].message.refusal}")
$var = $var.choices[0].message.parsed`
    }
}
```

## Sample Usage

Previously you would use Instructor to patch `create` and add a `response_format` arg.

```python
import instructor
from pydantic import BaseModel
from openai import OpenAI


# Define your desired output structure
class UserInfo(BaseModel):
    name: str
    age: int


# Patch the OpenAI client
client = instructor.from_openai(OpenAI())

# Extract structured data from natural language
user_info = client.chat.completions.create(
    model="gpt-3.5-turbo",
    response_model=UserInfo,
    messages=[{"role": "user", "content": "John Doe is 30 years old."}],
)

print(user_info.name)
#> John Doe
print(user_info.age)
#> 30
```

Now you just need to use the `parse` method directly on the OpenAI client.

```python
import instructor
from pydantic import BaseModel
from openai import OpenAI


# Define your desired output structure
class UserInfo(BaseModel):
    name: str
    age: int


# Patch the OpenAI client
client = instructor.from_openai(OpenAI())

# Extract structured data from natural language
user_info = client.chat.completions.parse(
    model="gpt-3.5-turbo",
    response_format=UserInfo,
    messages=[{"role": "user", "content": "John Doe is 30 years old."}],
)
if user_info.parsed:
    print(user_info.parsed.name)
    print(user_info.parsed.age)
else:
    print(user_info.refusal)

print(user_info.name)
#> John Doe
print(user_info.age)
#> 30
```
