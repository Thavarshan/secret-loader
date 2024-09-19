#!/bin/bash

# Function to get the parameter from AWS SSM
get_ssm_parameter() {
    local param_path=$1
    param_value=$(aws ssm get-parameter --name "$param_path" --with-decryption --query "Parameter.Value" --output text 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to retrieve SSM parameter '$param_path'" >&2
        return 1
    fi
    echo "$param_value"
}

# Function to get the output from CloudFormation
get_cf_output() {
    local stack_name=$1
    local output_key=$2
    cf_value=$(aws cloudformation describe-stacks --stack-name "$stack_name" \
        --query "Stacks[0].Outputs[?OutputKey=='$output_key'].OutputValue" --output text 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to retrieve CloudFormation output for '$stack_name' and '$output_key'" >&2
        return 1
    fi
    echo "$cf_value"
}

# Path to your .env file
ENV_FILE=${ENV_FILE:-.env}

# Temporary file to hold the updated .env contents
TEMP_FILE=$(mktemp)

# Set secure permissions for the temporary file
chmod 600 "$TEMP_FILE"

# Read the .env file line by line
while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines or comments
    [[ -z "$line" || "$line" =~ ^# ]] && echo "$line" >>"$TEMP_FILE" && continue

    # Extract the key and value from the line
    if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
        key="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"

        case "$value" in
        ssm:*)
            # If value starts with "ssm:", get the SSM parameter
            param_path="${value#ssm:}"
            param_value=$(get_ssm_parameter "$param_path")

            if [ $? -eq 0 ]; then
                # Replace the line with the actual value
                echo "$key=$param_value" >>"$TEMP_FILE"
            else
                echo "Warning: Skipping key '$key' due to SSM retrieval failure." >&2
            fi
            ;;
        cf:*)
            # If value starts with "cf:", get the CloudFormation output
            cf_params="${value#cf:}"
            stack_name=$(echo "$cf_params" | cut -d ':' -f 1)
            output_key=$(echo "$cf_params" | cut -d ':' -f 2)

            cf_value=$(get_cf_output "$stack_name" "$output_key")

            if [ $? -eq 0 ]; then
                # Replace the line with the actual value
                echo "$key=$cf_value" >>"$TEMP_FILE"
            else
                echo "Warning: Skipping key '$key' due to CloudFormation retrieval failure." >&2
            fi
            ;;
        *)
            # If no custom syntax is found, copy the line as is
            echo "$line" >>"$TEMP_FILE"
            ;;
        esac
    else
        echo "Warning: Malformed line '$line' in .env file, skipping." >&2
    fi
done <"$ENV_FILE"

# Replace the original .env with the updated one (backup the old one)
cp "$ENV_FILE" "$ENV_FILE.bak"
mv "$TEMP_FILE" "$ENV_FILE"

echo "Secrets loaded successfully!"
