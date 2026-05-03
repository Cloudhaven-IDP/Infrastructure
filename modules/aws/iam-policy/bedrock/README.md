# bedrock

Reusable IAM policy module for AWS Bedrock model invocation. Attach the output ARN to any role that needs to call Bedrock.

## Usage

### Any allowed model (orchestrator pattern)

```hcl
module "orchestrator_bedrock" {
  source      = "../../modules/aws/iam-policy/bedrock"
  policy_name = "orchestrator-bedrock-invoke"
}

module "orchestrator_role" {
  source      = "../../modules/aws/app-role"
  # ...
  policy_arns = [module.orchestrator_bedrock.arn]
}
```

Empty `allowed_models` resolves to `Resource: "*"`. Bedrock's account-level model access list is the underlying gate either way.

### Per-agent inference profile (agent-infra pattern)

```hcl
module "nutrition_bedrock" {
  source                 = "../../modules/aws/iam-policy/bedrock"
  policy_name            = "nutrition-bedrock-invoke"
  allowed_models         = ["anthropic.claude-sonnet-4-6-20251001-v1:0"]
  inference_profile_arns = [aws_bedrock_inference_profile.nutrition.arn]
}
```

AWS requires permissions on both the inference profile and its underlying foundation models when invoking through a cross-region profile, so pass both alongside each other.

## Inputs

| Name                     | Type           | Default                            | Description                                                                  |
| ------------------------ | -------------- | ---------------------------------- | ---------------------------------------------------------------------------- |
| `policy_name`            | `string`       | required                           | IAM policy name.                                                             |
| `description`            | `string`       | `"Bedrock InvokeModel access"`     | Policy description.                                                          |
| `allowed_models`         | `list(string)` | `[]`                               | Foundation model IDs the policy permits. Empty means any model.              |
| `regions`                | `list(string)` | `["us-east-1"]`                    | Bedrock regions where the allowed models are reachable.                      |
| `inference_profile_arns` | `list(string)` | `[]`                               | Inference profile ARNs to additionally scope to.                             |
| `tags`                   | `map(string)`  | `{}`                               | Additional tags.                                                             |

## Outputs

| Name   | Description              |
| ------ | ------------------------ |
| `arn`  | ARN of the IAM policy.   |
| `name` | Name of the IAM policy.  |

## Actions granted

- `bedrock:InvokeModel`
- `bedrock:InvokeModelWithResponseStream`
- `bedrock:Converse`
- `bedrock:ConverseStream`
