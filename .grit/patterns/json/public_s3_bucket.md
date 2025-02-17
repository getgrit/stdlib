---
title: Detected public S3 bucket and make sure they are set with intended values
tags: [aws, cloudformation]
---

# Public S3 bucket

Detected public S3 bucket. This policy allows anyone to have some kind of access to the bucket. The exact level of access and types of actions allowed will depend on the configuration of bucket policy and ACLs. Please review the bucket configuration to make sure they are set with intended values.

### references

- [AmazonS3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)

```grit
language json

`{ $json }` where {
	$json <: contains `"Type": "AWS::S3::Bucket"`,
	$json <: contains `"PublicAccessBlockConfiguration": { $config }` where {
		any {
			$config <: contains `"RestrictPublicBuckets": false` => `"RestrictPublicBuckets": true`,
			$config <: contains `"IgnorePublicAcls": false` => `"IgnorePublicAcls": true`,
			$config <: contains `"BlockPublicAcls": false` => `"BlockPublicAcls": true`,
			$config <: contains `"BlockPublicPolicy": false` => `"BlockPublicPolicy": true`
		}
	}
}
```

## Upgrades an existing dependency

```json
{
  "Resources": {
    "MyBucketF68F3FF0": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketEncryption": {
          "ServerSideEncryptionConfiguration": [
            {
              "ServerSideEncryptionByDefault": {
                "SSEAlgorithm": "aws:kms"
              }
            }
          ]
        },
        // public-s3-bucket
        "PublicAccessBlockConfiguration": {
          "BlockPublicAcls": false,
          "BlockPublicPolicy": true,
          "IgnorePublicAcls": false,
          "RestrictPublicBuckets": true
        }
      },
      "UpdateReplacePolicy": "Delete",
      "DeletionPolicy": "Delete"
    },
    "MyBucketF68F3FF1": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketEncryption": {
          "ServerSideEncryptionConfiguration": [
            {
              "ServerSideEncryptionByDefault": {
                "SSEAlgorithm": "aws:kms"
              }
            }
          ]
        },
        // public-s3-bucket
        "PublicAccessBlockConfiguration": {
          "BlockPublicAcls": true,
          "BlockPublicPolicy": true,
          "IgnorePublicAcls": true,
          "RestrictPublicBuckets": false
        }
      },
      "UpdateReplacePolicy": "Delete",
      "DeletionPolicy": "Delete"
    }
  }
}
```

```json
{
  "Resources": {
    "MyBucketF68F3FF0": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketEncryption": {
          "ServerSideEncryptionConfiguration": [
            {
              "ServerSideEncryptionByDefault": {
                "SSEAlgorithm": "aws:kms"
              }
            }
          ]
        },
        // public-s3-bucket
        "PublicAccessBlockConfiguration": {
          "BlockPublicAcls": true,
          "BlockPublicPolicy": true,
          "IgnorePublicAcls": true,
          "RestrictPublicBuckets": true
        }
      },
      "UpdateReplacePolicy": "Delete",
      "DeletionPolicy": "Delete"
    },
    "MyBucketF68F3FF1": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketEncryption": {
          "ServerSideEncryptionConfiguration": [
            {
              "ServerSideEncryptionByDefault": {
                "SSEAlgorithm": "aws:kms"
              }
            }
          ]
        },
        // public-s3-bucket
        "PublicAccessBlockConfiguration": {
          "BlockPublicAcls": true,
          "BlockPublicPolicy": true,
          "IgnorePublicAcls": true,
          "RestrictPublicBuckets": true
        }
      },
      "UpdateReplacePolicy": "Delete",
      "DeletionPolicy": "Delete"
    }
  }
}
```
