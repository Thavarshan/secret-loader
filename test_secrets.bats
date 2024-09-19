#!/usr/bin/env bats

setup() {
    # Create a temporary .env file
    export ENV_FILE=$(mktemp)
    export TEMP_FILE=$(mktemp)

    # Populate the .env file with various types of entries
    echo "KEY1=value1" >"$ENV_FILE"
    echo "KEY2=ssm:/path/to/ssm" >>"$ENV_FILE"
    echo "KEY3=cf:stack-name:output-key" >>"$ENV_FILE"
    echo "KEY4=regular_value" >>"$ENV_FILE"
    echo "KEY5=cf:stack-name:invalid-output" >>"$ENV_FILE"
    echo "KEY6=ssm:/invalid/ssm/path" >>"$ENV_FILE"
}

teardown() {
    # Remove temporary files
    rm -f "$ENV_FILE" "$TEMP_FILE"
}

# Mock the aws function globally for all tests
mock_aws() {
    aws() {
        case "$*" in
        *"ssm get-parameter"*)
            if [[ "$*" == *"/path/to/ssm"* ]]; then
                echo '{"Parameter": {"Value": "mocked-ssm-value"}}'
            else
                echo "An error occurred (ParameterNotFound) when calling the GetParameter operation" >&2
                return 1
            fi
            ;;
        *"cloudformation describe-stacks"*)
            if [[ "$*" == *"output-key"* ]]; then
                echo '{"Stacks": [{"Outputs": [{"OutputKey": "output-key", "OutputValue": "mocked-cf-value"}]}]}'
            else
                echo "An error occurred (OutputKeyNotFound) when calling the DescribeStacks operation" >&2
                return 1
            fi
            ;;
        *)
            echo "Unexpected AWS command: $*" >&2
            return 1
            ;;
        esac
    }
}

# Test for replacing ssm parameter with a mocked value
@test "ssm parameter is replaced with the correct value" {
    # Mock AWS calls
    mock_aws

    # Source the script and run it
    run bash -c 'source secrets.sh'

    # Check the result of the script
    [ "$status" -eq 0 ] || echo "Test failed for ssm: $output"

    # Verify that the SSM parameter has been replaced
    run grep "KEY2=mocked-ssm-value" "$ENV_FILE"
    [ "$status" -eq 0 ] || echo "Failed to find replaced SSM value in the .env file: $output"
}

# Test for replacing CloudFormation output with a mocked value
@test "cf output is replaced with the correct value" {
    # Mock AWS calls
    mock_aws

    # Source the script and run it
    run bash -c 'source secrets.sh'

    # Check the result of the script
    [ "$status" -eq 0 ] || echo "Test failed for CloudFormation: $output"

    # Verify that the CloudFormation output has been replaced
    run grep "KEY3=mocked-cf-value" "$ENV_FILE"
    [ "$status" -eq 0 ] || echo "Failed to find replaced CloudFormation value in the .env file: $output"
}

# Test for leaving regular values unchanged
@test "regular value is left unchanged" {
    # Mock AWS calls
    mock_aws

    # Source the script and run it
    run bash -c 'source secrets.sh'

    # Verify that regular values are not modified
    run grep "KEY4=regular_value" "$ENV_FILE"
    [ "$status" -eq 0 ] || echo "Failed to verify regular value: $output"
}

# Test for handling cloudformation output not found
@test "cloudformation output not found is handled correctly" {
    # Mock AWS calls
    mock_aws

    # Source the script and run it
    run bash -c 'source secrets.sh'

    # Check that the script warns about the CloudFormation error but does not fail
    [ "$status" -eq 0 ] || echo "CloudFormation output not found test failed: $output"

    # Verify that the invalid CloudFormation output was not replaced
    run grep "KEY5=cf:stack-name:invalid-output" "$ENV_FILE"
    [ "$status" -eq 0 ] || echo "Failed to handle invalid CloudFormation output: $output"
}

# Test for handling SSM parameter not found
@test "ssm parameter not found is handled correctly" {
    # Mock AWS calls
    mock_aws

    # Source the script and run it
    run bash -c 'source secrets.sh'

    # Check that the script warns about the SSM error but does not fail
    [ "$status" -eq 0 ] || echo "SSM parameter not found test failed: $output"

    # Verify that the invalid SSM value was not replaced
    run grep "KEY6=ssm:/invalid/ssm/path" "$ENV_FILE"
    [ "$status" -eq 0 ] || echo "Failed to handle invalid SSM value: $output"
}
