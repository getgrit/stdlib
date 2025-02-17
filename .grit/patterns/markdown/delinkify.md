---
title: Remove links from Markdown
---

This pattern replaces Markdown links with their bare text.

```grit
language markdown

inline_link(identifier=link_text($text)) where {
	$text <: contains link_text($element)
} => $element
```

## Removes a simple link

```md
The root of a Grit query is a [pattern](/language/patterns).

It even works with [titled links](https://www.codecademy.com/resources/docs/markdown/links "Thanks Codecademy!").
```

```md
The root of a Grit query is a pattern.

It even works with titled links.
```
