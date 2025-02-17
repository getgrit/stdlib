---
title: GraphQL Sever v4 csrf prevention
tags: [fix, graphQL, security]
---

The Apollo GraphQL server sets the 'csrfPrevention' option to false. This can enable CSRF attacks.

- [reference](https://www.apollographql.com/docs/apollo-server/v3/security/cors/#preventing-cross-site-request-forgery-csrf)


```grit
engine marzano(0.1)
language js

`new ApolloServer($config)` where {
	$config <: contains `csrfPrevention: false` => `csrfPrevention: true`
}
```

## GraphQL Sever v4 csrf prevention

```javascript
// OK: Lacks 'csrfPrevention: true', but on v4 this option is true by default
const apollo_server_1 = new ApolloServer({
  typeDefs,
  resolvers,
});

// Good: Has 'csrfPrevention: true'
const apollo_server_3 = new ApolloServer({
  typeDefs,
  resolvers,
  csrfPrevention: true,
});

// BAD: Has 'csrfPrevention: false'
const apollo_server_2 = new ApolloServer({
  typeDefs,
  resolvers,
  csrfPrevention: false,
});
```

```javascript
// OK: Lacks 'csrfPrevention: true', but on v4 this option is true by default
const apollo_server_1 = new ApolloServer({
  typeDefs,
  resolvers,
});

// Good: Has 'csrfPrevention: true'
const apollo_server_3 = new ApolloServer({
  typeDefs,
  resolvers,
  csrfPrevention: true,
});

// BAD: Has 'csrfPrevention: false'
const apollo_server_2 = new ApolloServer({
  typeDefs,
  resolvers,
  csrfPrevention: true,
});
```
