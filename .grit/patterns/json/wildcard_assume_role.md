---
title: Detected wildcard access granted to sts:AssumeRole and limit to a specific identity in your account
---

Detected wildcard access granted to sts:AssumeRole. This means anyone with your AWS account ID and the name of the role can assume the role. Instead, limit to a specific identity in your account, like this: `arn:aws:iam::<account_id>:root`.

tags: #aws
### references

- [aws](https://rhinosecuritylabs.com/aws/assume-worst-aws-assume-role-enumeration/)



```grit
language json

`{ 
    "Effect": $type, 
    $config, 
    "Action": "sts:AssumeRole"
}` where {
    $config <: contains `"Principal": { "AWS": $key }` where {
        $key <: contains or {
            `*` where $type <: contains `Allow` => `Deny`,
            `"arn:aws:iam::$account_id:root"` where $type <: contains `Deny` => `Allow`
        }
    },
}
```

## "AWS": "*"

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      // wildcard-assume-role
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Deny",
      // wildcard-assume-role
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      // wildcard-assume-role
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:PutObject"
    }
  ]
}
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      // wildcard-assume-role
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Deny",
      // wildcard-assume-role
      "Principal": {
        "AWS": "*"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      // wildcard-assume-role
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:PutObject"
    }
  ]
}
```

## "AWS": "arn:aws:iam::<account_id>:root"

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      // wildcard-assume-role
      "Principal": {
        "AWS": "arn:aws:iam::1234567890:root"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      // wildcard-assume-role
      "Principal": {
        "AWS": "arn:aws:iam::1234567890:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      // wildcard-assume-role
      "Principal": {
        "AWS": "arn:aws:iam::1234567890:root"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      // wildcard-assume-role
      "Principal": {
        "AWS": "arn:aws:iam::1234567890:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```
