---
title: GraphQL Sever v3 csrf prevention
---

The Apollo GraphQL server lacks the 'csrfPrevention' option. This option is 'false' by the default in v3 of the Apollo GraphQL v3, which can enable CSRF attacks

tags: #fix #graphQL, #security

```grit
engine marzano(0.1)
language js

or {
    `new ApolloServer({$config})` where {
	    $config <: not contains `csrfPrevention: $boolean`,
	    $config += `csrfPrevention: true`
	},
    `new ApolloServer({$config})` where {
        $config <: contains `csrfPrevention: false` => `csrfPrevention: true`       
    },
}
```

## GraphQL Sever v3 csrf prevention

```javascript
// BAD 1: Lacks 'csrfPrevention: true'
const apollo_server_1 = new ApolloServer({
    typeDefs,
    resolvers
});

// BAD 2: Has 'csrfPrevention: false'
const apollo_server_2 = new ApolloServer({
    typeDefs,
    resolvers, 
    csrfPrevention: false,
});

// Good: Has 'csrfPrevention: true'
const apollo_server_3 = new ApolloServer({
    typeDefs,
    resolvers,
    csrfPrevention: true,
});
```

```javascript
// BAD 1: Lacks 'csrfPrevention: true'
const apollo_server_1 = new ApolloServer({
    typeDefs,
    resolvers,
    csrfPrevention: true
});

// BAD 2: Has 'csrfPrevention: false'
const apollo_server_2 = new ApolloServer({
    typeDefs,
    resolvers, 
    csrfPrevention: true,
});

// Good: Has 'csrfPrevention: true'
const apollo_server_3 = new ApolloServer({
    typeDefs,
    resolvers,
    csrfPrevention: true,
});
```
