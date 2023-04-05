---
title: ⇒ self-closing JSX tags
---

# {{ page.title }}

Components without children can be self-closed to avoid unnecessary extra closing tag.

tags: #SE, #syntax, #React

```grit
// The 'pattern' keyword is used to define custom named patterns at the top of this Grit snippet.
// We use separate patterns for matching different groups of html tags to aid readability.
pattern HTMLHeadings() = or { "h1" , "h2" , "h3" , "h4" , "h5" , "h6", "title" }
pattern HTMLContainers() = or { "div" , "section" , "article" , "nav" , "main" , "aside" , "footer" , "header" , "hgroup" }
pattern HTMLBlockText() = or { "address" , "blockquote" , "dl" , "dt" , "dd" , "ul" , "ol" , "li" , "figcaption" , "figure" , "p" , "pre" }
pattern HTMLInlineText() = or { "a" , "b" , "span" , "abbr" , "bdi" , "bdo" , "cite" , "code" , "data" , "dfn" , "em" , "i" , "kbd" , "mark" , "q" , "ruby" , "rp" , "rt" , "rtc" , "s" , "samp" , "small" , "strong" , "sub" , "sup" , "time" , "u" , "var" , "small" , "del" , "ins" }
pattern HTMLTables() = or { "table" , "tbody" , "thead" , "tfoot" , "tr" , "th" , "td" , "caption" , "optgroup" }
pattern HTMLForms() = or { "form" , "button" , "label" , "fieldset" , "legend" , "select" , "datalist" , "option" , "textarea" , "progress" , "output" , "meter" }
pattern HTMLWebComponents() = or { "content" , "element" , "shadow" , "slot" , "template" }
pattern HTMLInteractive() = or { "dialog" , "details" , "summary" , "menu" , "menuitem" }
// Finally, the pattern HTMLTagsWithPair() is defined as the disjunction of all the above defined patterns
pattern HTMLTagsWithPair() = or { HTMLHeadings() , HTMLContainers() , HTMLBlockText() , HTMLInlineText() , HTMLTables() , HTMLForms() , HTMLWebComponents() }

`<$name $props> $body </$name>` => `<$name $props />` where {
  // In order for a snippet of code to be rewritten, it must satisfy both of the where conditions below
  // $body can be either empty – as the lone '.' represents – or match the syntax-tree node JSXText with the denoted value
  // The r prefix causes the attached string to be interpreted as a regular expression, in this case matching any amount of whitespace
  $body <: or { . , JSXText(value = r"\\s*") },
  // $name must NOT match the syntax-tree node JSXIdentifier with a name attribute equivalent to one of the HTMLTagsWithPair defined at the top of the file
  $name <: ! JSXIdentifier(name = HTMLTagsWithPair())
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
