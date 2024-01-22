---
title: Convert basic types
---

Converts column types to their equivalents in postgres.
Problematic types like `rowid`, or `varchar($n byte)` are left alone.

```grit
engine marzano(0.1)
language sql

pattern convert_types() {
    or {
    	`RAW` => `BYTEA`,
        `BINARY_DOUBLE` => `NUMERIC`,
        `BINARY_FLOAT` => `REAL`,
        `BINARY_INTEGER` => `INTEGER`,
        `BLOB` => `BYTEA`,
        `CLOB` => `TEXT`,
        `DEC` => `DECIMAL`,
        `DATE` => `TIMESTAMP`,
        `FLOAT` => `DOUBLE PRECISION`,
        `LONG` => `TEXT`,
        `NUMBER($N)` => `NUMERIC($N)`,
        `NUMBER` => `NUMERIC`,
        `PLS_INTEGER` => `INTEGER`,
        `SDO_GEOMETRY` => `GEOMETRY`,
        `ST_GEOMETRY` => `GEOMETRY`,
        `STRING` => `VARCHAR`,
        `TIMESTAMP WITH LOCAL TIME ZONE` => `TIMESTAMPTZ`,
        `TIMESTAMP($P)` => `TIMESTAMP($P)`,
        `VARCHAR2($N CHAR)` => `VARCHAR($N)`,
        `VARCHAR2` => `VARCHAR`,
        `XMLTYPE` => `XML`,
    }
}

// pattern problematic_types() {
//     or {
//         `bfile`, //These are pointers to binary files, which PG doesn't have
//         `rowid`, // Postgres doesn't have the rowid() function, but the type 
//         `urowid`, // can be approximated with char(10)
//     }
// }
convert_types()
```

## Convert types

```sql
CREATE TABLE employees
(
    first_name VARCHAR2(128),
    last_name VARCHAR2(128),
    empID NUMBER,
    salary NUMBER(6),
    pkey NUMBER(12,0),
    category_name VARCHAR2(15 BYTE), 
	boid VARCHAR2(40 CHAR),
    info CLOB,
    data BLOB,
    pct_complete FLOAT,
	updated_at TIMESTAMP(9),
    config XMLTYPE
);
```

```sql
CREATE TABLE employees
(
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    empID NUMERIC,
    salary NUMERIC(6),
    pkey NUMERIC(12,0),
    category_name VARCHAR(15 BYTE), 
	boid VARCHAR(40),
    info TEXT,
    data BYTEA,
    pct_complete DOUBLE PRECISION,
	updated_at TIMESTAMP(9),
    config XML
);
```