#!/bin/bash

args=("$@")

while read INSTANCEID; do
  ## get instance state
  INSTANCESTATE=`aws ec2 describe-instances --profile sandbox --instance-id $INSTANCEID --query 'Reservations[*].Instances[*].{State:State.Name}' --output text`
  INSTANCETYPE=`aws ec2 describe-instances --profile sandbox --instance-id $INSTANCEID --query 'Reservations[*].Instances[*].{Type:InstanceType}' --output text`
  NEWTYPE=${INSTANCETYPE//t2/t3}

  echo "querying data..."
  INSTANCENAME=$(aws ec2 describe-instances --profile sandbox --instance-ids $INSTANCEID --query 'Reservations[].Instances[].{Name: Tags[?Key==`Name`] | [0].Value}' --output text)
  echo "instance name: $INSTANCENAME"; echo "instance type: $INSTANCETYPE"

  if [ $INSTANCESTATE == "stopped" ]
  then
    echo "instance state is $INSTANCESTATE"
    ## modifying ena-support
    aws ec2 modify-instance-attribute --profile sandbox --instance-id $INSTANCEID --ena-support
    aws ec2 modify-instance-attribute --profile sandbox --instance-id $INSTANCEID --instance-type $NEWTYPE
    aws ec2 start-instances --profile sandbox --instance-ids $INSTANCEID
  elif [ $INSTANCESTATE == "running" ]
  then
    echo "instance state is $INSTANCESTATE"
    aws ec2 stop-instances --profile sandbox --instance-ids $INSTANCEID
    while [ $INSTANCESTATE != "stopped" ]; do 
        sleep 10; echo "stopping instance..."
            if [ $(aws ec2 describe-instances --profile sandbox --instance-id $INSTANCEID --query 'Reservations[*].Instances[*].{State:State.Name}' --output text) == "stopped" ]
            then break; fi
    done
    aws ec2 modify-instance-attribute --profile sandbox --instance-id $INSTANCEID --ena-support
    aws ec2 modify-instance-attribute --profile sandbox --instance-id $INSTANCEID --instance-type $NEWTYPE
    aws ec2 start-instances --profile sandbox --instance-ids $INSTANCEID 
  fi

done < ${args[0]}
