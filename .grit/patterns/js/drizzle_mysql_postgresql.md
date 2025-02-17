---
title: Convert Drizzle Schema from MySQL to PostgreSQL
tags: [drizzle, mysql, postgresql]
---

Migrate the Drizzle DB schema from MySQL to PostgreSQL.

```grit
`import $alias from "drizzle-orm/mysql-core"` => `import $alias from "drizzle-orm/pg-core"` where {
	$alias <: contains "mysqlTable" => `pgTable`,
	$alias <: contains or {
		or {
			`mediumint`,
			`int`
		} as $i => `integer`,
		or {
			`tinyint`,
			`smallint`
		} as $i => `smallint`,
		`mediumint` => .,
		`double` => `doublePrecision`,
		`tinyint` => .
	},
	$program <: contains bubble($alias) or {
		`mysqlTable($name, $schema)` => `pgTable($name, $schema)` where {
			$schema <: contains or {
				or {
					`int`,
					`mediumint`
				} => `integer`,
				`double` => `doublePrecision`,
				`tinyint` => `smallint`
			}
		}
	}
}
```

## Migrate MySQL schema to PostgreSQL

```javascript
import {
  bigint,
  boolean,
  double,
  int,
  mediumint,
  mysqlTable,
  serial,
  smallint,
  tinyint,
  varchar,
} from 'drizzle-orm/mysql-core';

export const tableOne = mysqlTable('table', {
  id: serial('id').primaryKey().notNull(),
  userId: int('userId'),
  partner: varchar('partner', { length: 20 }).notNull(),
  age: tinyint('age'),
  balance: mediumint('balance'),
  price: double('price'),
  isEnable: boolean('isEnable').notNull().default(true),
});

export const tableTwo = mysqlTable('table_two', {
  id: serial('id').primaryKey().notNull(),
  userId: int('userId'),
  partner: varchar('partner', { length: 20 }).notNull(),
  age: tinyint('age'),
  small: smallint('small'),
  secret: bigint('secret', { mode: 'number' }),
  balance: mediumint('balance'),
  price: double('price'),
});
```

```javascript
import {
  bigint,
  boolean,
  doublePrecision,
  integer,
  pgTable,
  serial,
  smallint,
  varchar,
} from 'drizzle-orm/pg-core';

export const tableOne = pgTable('table', {
  id: serial('id').primaryKey().notNull(),
  userId: integer('userId'),
  partner: varchar('partner', { length: 20 }).notNull(),
  age: smallint('age'),
  balance: integer('balance'),
  price: doublePrecision('price'),
  isEnable: boolean('isEnable').notNull().default(true),
});

export const tableTwo = pgTable('table_two', {
  id: serial('id').primaryKey().notNull(),
  userId: integer('userId'),
  partner: varchar('partner', { length: 20 }).notNull(),
  age: smallint('age'),
  small: smallint('small'),
  secret: bigint('secret', { mode: 'number' }),
  balance: integer('balance'),
  price: doublePrecision('price'),
});
```
