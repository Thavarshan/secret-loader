#!/bin/bash

# Function to get the parameter from AWS SSM
get_ssm_parameter() {
    local param_path=$1
    aws ssm get-parameter --name "$param_path" --with-decryption --query "Parameter.Value" --output text
}

# Function to get the output from CloudFormation
get_cf_output() {
    local stack_name=$1
    local output_key=$2
    aws cloudformation describe-stacks --stack-name "$stack_name" \
        --query "Stacks[0].Outputs[?OutputKey=='$output_key'].OutputValue" --output text
}

# Path to your .env file
ENV_FILE=".env"

# Temporary file to hold the updated .env contents
TEMP_FILE=$(mktemp)

# Read the .env file line by line
while IFS= read -r line; do
    # Extract the key and value from the line
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2)

    case "$value" in
    ssm:*)
        # If value starts with "ssm:", get the SSM parameter
        param_path=$(echo "$value" | sed 's/ssm://')
        param_value=$(get_ssm_parameter "$param_path")

        # Replace the line with the actual value
        echo "$key=$param_value" >>"$TEMP_FILE"
        ;;
    cf:*)
        # If value starts with "cf:", get the CloudFormation output
        cf_params=$(echo "$value" | sed 's/cf://')
        stack_name=$(echo "$cf_params" | cut -d ':' -f 1)
        output_key=$(echo "$cf_params" | cut -d ':' -f 2)

        cf_value=$(get_cf_output "$stack_name" "$output_key")

        # Replace the line with the actual value
        echo "$key=$cf_value" >>"$TEMP_FILE"
        ;;
    *)
        # If no custom syntax is found, copy the line as is
        echo "$line" >>"$TEMP_FILE"
        ;;
    esac

done <"$ENV_FILE"

# Replace the original .env with the updated one
mv "$TEMP_FILE" "$ENV_FILE"

echo "Secrets loaded successfully!"
