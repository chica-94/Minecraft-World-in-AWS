# Variables for SSO configuration
$SSO_PROFILE_NAME = "AWS"
$SSO_START_URL = "https://cis4850.awsapps.com/start/#"
$SSO_REGION = "us-west-1"
$SSO_ROLE_NAME = "AWSAdministratorAccess"

# Option to choose between different Account IDs
Write-Host "Please select the AWS Account ID to use:"
Write-Host "1) Sandbox-CIS4850: 585768167139"t
Write-Host "2) Project: 140023386273"
Write-Host "3) CIS4850-Final: 692859919969"
# Write-Host "3) Test: #####"


$account_choice = Read-Host "Enter the number corresponding to your choice"

switch ($account_choice) {
    "1" { $SSO_ACCOUNT_ID = "585768167139" }
    "2" { $SSO_ACCOUNT_ID = "140023386273" }
    "3" { $SSO_ACCOUNT_ID = "692859919969" }
####    "3" { $SSO_ACCOUNT_ID = "#####" }

    default { 
        Write-Host "Invalid choice. Exiting."
        exit 1
    }
}

# Confirm the chosen Account ID
Write-Host "Using AWS Account ID: $SSO_ACCOUNT_ID"

# Set environment variables for AWS profile and browser
$env:AWS_PROFILE = $SSO_PROFILE_NAME
$env:BROWSER = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Clear any existing SSO cache to ensure no old profiles interfere
Remove-Item -Recurse -Force "$HOME\.aws\sso\cache\*" -ErrorAction SilentlyContinue

# Set AWS CLI configuration for the profile
aws configure set sso_start_url "$SSO_START_URL" --profile "$SSO_PROFILE_NAME"
aws configure set sso_region "$SSO_REGION" --profile "$SSO_PROFILE_NAME"
aws configure set sso_account_id "$SSO_ACCOUNT_ID" --profile "$SSO_PROFILE_NAME"
aws configure set sso_role_name "$SSO_ROLE_NAME" --profile "$SSO_PROFILE_NAME"
aws configure set region "$SSO_REGION" --profile "$SSO_PROFILE_NAME"

# Initiate SSO login
Write-Host "Logging in with SSO profile: $env:AWS_PROFILE"
aws sso login --profile "$env:AWS_PROFILE"

# Verify AWS credentials are set for the selected profile
try {
    aws sts get-caller-identity --profile "$env:AWS_PROFILE" | Out-Null
    Write-Host "AWS SSO login successful. Credentials are set for profile $env:AWS_PROFILE."
} catch {
    Write-Host "AWS SSO login failed or credentials are missing. Please verify SSO configuration and login process."
}