---
title: ⇒ self-closing JSX tags
---

# {{ page.title }}

Components without children can be self-closed to avoid unnecessary extra closing tag.

tags: #SE, #syntax, #React

```grit
engine marzano(0.1)
language js

// The 'pattern' keyword is used to define custom named patterns at the top of this Grit snippet.
// We use separate patterns for matching different groups of html tags to aid readability.
pattern html_headings() { or { "h1" , "h2" , "h3" , "h4" , "h5" , "h6", "title" } }
pattern html_containers() { or { "div" , "section" , "article" , "nav" , "main" , "aside" , "footer" , "header" , "hgroup" } }
pattern html_block_text() { or { "address" , "blockquote" , "dl" , "dt" , "dd" , "ul" , "ol" , "li" , "figcaption" , "figure" , "p" , "pre" } }
pattern html_inline_text() { or { "a" , "b" , "span" , "abbr" , "bdi" , "bdo" , "cite" , "code" , "data" , "dfn" , "em" , "i" , "kbd" , "mark" , "q" , "ruby" , "rp" , "rt" , "rtc" , "s" , "samp" , "small" , "strong" , "sub" , "sup" , "time" , "u" , "var" , "small" , "del" , "ins" } }
pattern html_tables() { or { "table" , "tbody" , "thead" , "tfoot" , "tr" , "th" , "td" , "caption" , "optgroup" } }
pattern html_forms() { or { "form" , "button" , "label" , "fieldset" , "legend" , "select" , "datalist" , "option" , "textarea" , "progress" , "output" , "meter" } }
pattern html_web_components() { or { "content" , "element" , "shadow" , "slot" , "template" } }
pattern html_interactive() { or { "dialog" , "details" , "summary" , "menu" , "menuitem" } }
// Finally, the pattern HTMLTagsWithPair() is defined as the disjunction of all the above defined patterns
pattern html_tags_pair() { or { html_headings() , html_containers() , html_block_text() , html_inline_text() , html_tables() , html_forms() , html_web_components(), html_interactive() } }

`<$name $props>$body</$name>` => `<$name $props />` where {
    // In order for a snippet of code to be rewritten, it must satisfy both of the where conditions below
    // The r prefix causes the attached string to be interpreted as a regular expression, in this case matching any amount of whitespace
    $body <: r"\s*",
    // $name must NOT match one of the html_tags_pair defined at the top of the file
    $name <: not html_tags_pair()
}
```

## Converts components without attributes

```javascript
<Hello></Hello>
```

```typescript
<Hello />
```

## Converts components with 1 attribute

```javascript
<Hello attr="foo"></Hello>
```

```typescript
<Hello attr="foo" />
```

## Converts components with 2 attributes

```javascript
<Hello attr="foo" prop="baz"></Hello>
```

```typescript
<Hello attr="foo" prop="baz" />
```

## Converts components with whitespace as children

```javascript
<Hello></Hello>
```

```typescript
<Hello />
```

## Doesn't convert self-closing components

```javascript
<Hello />
```

## Doesn't convert native HTML tags with closing pair: div

```javascript
<div></div>
```

## Doesn't convert native HTML tags with closing pair: span

```javascript
<span></span>
```

## Doesn't convert native HTML tags with closing pair: a

```javascript
<a></a>
```

## Doesn't convert native HTML tags with closing pair: h1

```javascript
<h1></h1>
```

## Doesn't convert native HTML tags with closing pair: td

```javascript
<td></td>
```

## Doesn't convert native HTML tags with closing pair: li

```javascript
<li></li>
```
