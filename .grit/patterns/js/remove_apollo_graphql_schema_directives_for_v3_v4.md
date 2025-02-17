---
title: Remove Apollo Graphql Schema Directives while migrating from v2 to v3 or v4
tags: [fix, migration]
---

The 'schemaDirectives' option in Apollo GraphQL, which was effective in ApolloServer version v2, no longer functions in versions >=3 and above. This change can have significant implications, potentially exposing authenticated endpoints, disabling rate limiting, and more, depending on the directives used. To address this, it is recommended to consult the references on creating custom directives specifically for ApolloServer versions v3 and v4.

[references](https://www.apollographql.com/docs/apollo-server/schema/directives/#custom-directives)


```grit
engine marzano(0.1)
language js

`new ApolloServer($props)` where {
	$props <: contains `schemaDirectives: {$schema}` => .
}
```

## Apollo Graphql Schema Directives while migrating from v2 to v3 or v4

```javascript
// BAD: Has 'schemaDirectives'
const apollo_server_1 = new ApolloServer({
    typeDefs,
    resolvers,
    schemaDirectives: {
        rateLimit: rateLimitDirective
    },
});

// Good: Does not have 'schemaDirectives'
const apollo_server_3 = new ApolloServer({
    typeDefs,
    resolvers,
});
```

```javascript
// BAD: Has 'schemaDirectives'
const apollo_server_1 = new ApolloServer({
    typeDefs,
    resolvers,
    
});

// Good: Does not have 'schemaDirectives'
const apollo_server_3 = new ApolloServer({
    typeDefs,
    resolvers,
});
```
