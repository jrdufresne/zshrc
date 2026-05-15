autoload -Uz compinit
compinit

awsprofile() {
  local profile="$1"
  local region="us-east-1"
  if [[ -z "$profile" ]]; then
    echo "Usage: awsprofile <profile>"
    return 1
  fi
  export AWS_PROFILE="$profile"
  export AWS_REGION="$region"
  
  # Try to get caller identity
  if ! aws sts get-caller-identity --profile "$profile" --region "$region" > /dev/null 2>&1; then
    echo "SSO session expired or not found. Logging in..."
    aws sso login --profile "$profile"
    # Try again after login
    if ! aws sts get-caller-identity --profile "$profile" --region "$region" > /dev/null 2>&1; then
      echo "Login failed or credentials still missing."
      return 2
    fi
  else
    echo "SSO session is still valid. No login needed."
  fi

  echo "AWS_PROFILE set to $profile"
  echo "AWS_REGION set to $region"
}

_awsprofile() {
  local -a profiles regions
  profiles=("${(@f)$(aws configure list-profiles 2>/dev/null)}")
  regions=("us-east-1" "us-west-2" "eu-west-1") # Add your regions here

  if (( CURRENT == 2 )); then
    compadd -- $profiles
  elif (( CURRENT == 3 )); then
    compadd -- $regions
  fi
}
compdef _awsprofile awsprofile
