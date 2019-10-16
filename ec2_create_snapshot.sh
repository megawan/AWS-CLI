#!/bin/bash

while read INSTANCE; do
  VOLUMEID=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE" --query "Reservations[*].Instances[*].[BlockDeviceMappings[0].Ebs.VolumeId]" --profile sandbox --output text`
  echo "instance name=$INSTANCE, volumeId=$VOLUMEID"
  timestamp=$(date "+%H:%M:%S %d/%m/%Y")
  aws ec2 create-snapshot --profile sandbox --volume-id $VOLUMEID --description "Created by script at $timestamp" --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$INSTANCE}]"
done < instance.txt