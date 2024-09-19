# Secrets Loader 🔐

**Secrets-Loader** is a script to load environment variables from secret stores like AWS SSM and CloudFormation directly into your `.env` file. This tool simplifies the management of environment variables by securely fetching secrets for local development, testing, and production environments, ensuring sensitive data stays out of version control.

---

## Features

- **Automated secret loading**: Fetch secrets from AWS SSM and CloudFormation by specifying paths in your `.env` file using a simple syntax.
- **Security-first approach**: Keep sensitive information, like API keys and credentials, out of your `.env` files and version control.
- **Single-command execution**: Run a single shell command to update your `.env` file with secrets from your preferred secret store.
- **Extensible design**: Support for additional secret management systems can easily be added using custom prefixes.

---

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Thavarshan/envsecrets.git
   cd envsecrets
   ```

2. **Make the script executable**:

   ```bash
   chmod +x secrets.sh
   ```

3. **Ensure AWS CLI is installed and configured**:
   If you don't have the AWS CLI installed, you can install it by following the [AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

   Then configure your AWS credentials:

   ```bash
   aws configure
   ```

---

## Usage

1. **Define secrets in your `.env` file** using a custom syntax:

   ```env
   THIRD_PARTY_API_KEY="ssm:/third-party/api/key"
   THIRD_PARTY_API_SECRET="cf:my-stack:ApiSecret"
   ```

   - Use the `ssm:` prefix for AWS SSM Parameter Store secrets.
   - Use the `cf:` prefix for AWS CloudFormation outputs.

2. **Run the script** to load the secrets:

   ```bash
   ./secrets.sh
   ```

   This command will update your `.env` file by fetching the actual values from the specified secret stores.

---

## Example

### `.env.example` File

```env
# Standard environment variables
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
APP_DEBUG=true
APP_URL=http://localhost

# Third-party service credentials fetched from AWS SSM
THIRD_PARTY_API_KEY="ssm:/third-party/api/key"
THIRD_PARTY_API_SECRET="ssm:/third-party/api/secret"

# AWS credentials fetched from CloudFormation stack outputs
AWS_ACCESS_KEY_ID="cf:my-stack:AccessKeyId"
AWS_SECRET_ACCESS_KEY="cf:my-stack:SecretAccessKey"
```

After running the script, your `.env` file will be updated with the real values.

---

## Requirements

- **AWS CLI**: Ensure the AWS CLI is installed and configured with the correct credentials.
- **Permissions**: The AWS IAM role or user associated with the AWS CLI must have sufficient permissions to access AWS SSM Parameters and CloudFormation outputs.

---

## Extensibility

EnvSecrets is designed with extensibility in mind. You can easily extend support to other secret stores (e.g., Azure Key Vault, HashiCorp Vault) by adding new prefixes and integrating the respective CLI or SDK.

---

## Troubleshooting

- **Error fetching secrets**: Ensure that the AWS CLI is properly configured and has permissions to access the necessary secrets.
- **Invalid syntax**: Double-check the syntax in your `.env` file to ensure it follows the correct `ssm:` or `cf:` format.

---

## Contributing

Feel free to open an issue or submit a pull request if you have suggestions, improvements, or bug fixes.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
