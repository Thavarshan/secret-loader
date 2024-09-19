# 🔐 Secrets Loader

**Secrets-Loader** is a Bash script designed to securely load environment variables from secret stores like AWS SSM and CloudFormation directly into your `.env` file. This tool simplifies the management of environment variables by securely fetching secrets for local development, testing, and production environments, ensuring sensitive data stays out of version control.

---

## Features

- **Automated secret loading**: Fetch secrets from AWS SSM and CloudFormation by specifying paths in your `.env` file using simple syntax (`ssm:` for SSM parameters, `cf:` for CloudFormation outputs).
- **Security-first approach**: Keep sensitive information, such as API keys and credentials, out of your `.env` files and version control by fetching them dynamically.
- **Single-command execution**: Load your secrets into your environment with a single command, making it seamless for development and deployment environments.
- **Graceful error handling**: Warnings are displayed if secrets cannot be fetched, but the script continues processing other secrets.
- **Extensible design**: New secret management systems can easily be integrated by adding custom prefixes.

---

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Thavarshan/secrets-loader.git
   cd secrets-loader
   ```

2. **Make the script executable**:

   ```bash
   chmod +x secrets.sh
   ```

3. **Ensure AWS CLI is installed and configured**:

   If you don't have the AWS CLI installed, you can follow the [AWS CLI installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

   Then, configure your AWS credentials:

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
   - Use the `cf:` prefix for AWS CloudFormation stack outputs.

2. **Run the script** to load the secrets:

   ```bash
   ./secrets.sh
   ```

   This command will automatically fetch the actual values from the specified secret stores and update your `.env` file with the real values.

3. **View the output**:

   Upon completion, the script will notify you with a success message or warnings if certain secrets could not be fetched.

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

After running the script, your `.env` file will be updated with the actual values for the secrets.

---

## Requirements

- **AWS CLI**: Ensure the AWS CLI is installed and configured with the correct credentials.
- **Permissions**: The AWS IAM role or user associated with the AWS CLI must have sufficient permissions to access AWS SSM Parameters and CloudFormation outputs.

---

## Error Handling

The script gracefully handles errors such as:

- **SSM Parameter not found**: The script will display a warning and continue loading other secrets.
- **CloudFormation output not found**: Similar to SSM, a warning is displayed, and the script continues processing other secrets.
- **Malformed `.env` lines**: The script logs warnings if it encounters invalid syntax in the `.env` file, ensuring robust processing without breaking.

---

## Extensibility

The `Secrets-Loader` is designed with extensibility in mind. You can easily extend support to other secret stores (e.g., Azure Key Vault, HashiCorp Vault) by adding new prefixes and integrating the respective CLI or SDK.

For example, to add support for **Azure Key Vault**, you could:

- Define a new prefix, e.g., `azkv:`.
- Use the Azure CLI or SDK to fetch secrets and add corresponding functions to handle the retrieval.

---

## Troubleshooting

- **Error fetching secrets**: Ensure that the AWS CLI is properly configured and has sufficient permissions to access the necessary secrets.
- **Incorrect syntax in `.env`**: Double-check the syntax in your `.env` file to ensure it follows the correct `ssm:` or `cf:` format.
- **No output for certain keys**: If a secret can't be fetched (e.g., due to permissions), check the AWS CLI for possible errors using the `--debug` option.

---

## Contributing

We welcome contributions! Feel free to open an issue or submit a pull request if you have suggestions, improvements, or bug fixes.

When contributing:

- Follow the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
- Ensure that tests are included for any new features.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
