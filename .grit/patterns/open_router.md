```grit
engine marzano(0.1)
language js

or {
    `new OpenAI({ $params })` where {
        $new_url = `baseURL: "https://openrouter.ai/api/v1"`,
        $new_referer = `"HTTP-Referer": YOUR_SITE_URL`,
        $new_title = `"X-Title": YOUR_SITE_NAME, // Optional. Shows on openrouter.ai`,
        $new_params = .,
        or {
            $params <: contains `baseURL: $_` => $new_url,
            $new_params += `, $new_url`
        },
        or {
            $params <: contains `defaultHeaders: { $headers }` where {
                $headers <: contains `"HTTP-Referer": $_` => $new_referer,
                $headers <: contains `"X-Title": $_` => $new_title
            },
            $new_params += `, defaultHeaders: {
                $new_referer,
                $new_title
            }`
        },
        if (!$new_params <: .) {
            $params => `$params$new_params`
        },
    },
    `openai.chat.completions.create($opts)` where {
        $opts <: contains `model: "$model"`,
        $model => `openai/$model`
    }
}
```
