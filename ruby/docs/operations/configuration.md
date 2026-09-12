# Configuration

Detailed guidance referenced by `docs/operations.md`. Read this file only when this topic is relevant to the task.

## Rails credentials

Use Rails credentials for API keys, signing secrets, encryption secrets, provider tokens, and other sensitive values.

Do not create a parallel secrets system without a concrete requirement.

Never commit decrypted credentials or real secrets.
## Credentials vs environment variables

Prefer credentials for secrets.

Use environment variables for runtime/environment configuration such as hostnames, ports, process counts, log level, and non-secret deployment toggles.

Do not put every non-secret value in encrypted credentials.
