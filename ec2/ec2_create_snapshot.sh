#!/bin/bash

while IFS= read -r instance_name; do
  volume_id=$(aws ec2 describe-instances \
              --filters "Name=tag:Name,Values=$instance_name" \
              --query "Reservations[*].Instances[*].BlockDeviceMappings[0].Ebs.VolumeId" \
              --profile sandbox --output text)

  if [ -n "$volume_id" ]; then
    echo "Instance Name: $instance_name, Volume ID: $volume_id"
    timestamp=$(date "+%H:%M:%S %d/%m/%Y")
    description="Created by script at $timestamp"

    aws ec2 create-snapshot \
      --profile sandbox \
      --volume-id "$volume_id" \
      --description "$description" \
      --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$instance_name}]"
  else
    echo "Failed to find volume for instance: $instance_name"
  fi
done < instance.txt
