#!/bin/bash

# Define an array of AWS profiles
profiles=("root" "development" "staging" "production" "monitoring" "ops")

# Loop through the profiles and append the instance details to /etc/hosts
for profile in "${profiles[@]}"; do
    aws ec2 describe-instances \
        --profile "$profile" \
        --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' \
        --output text >> /etc/hosts
done
