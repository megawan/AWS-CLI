#!/bin/bash

aws ec2 describe-instances --profile root --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' --output text > /etc/hosts
aws ec2 describe-instances --profile development --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' --output text >> /etc/hosts
aws ec2 describe-instances --profile staging --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' --output text >> /etc/hosts
aws ec2 describe-instances --profile production --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' --output text >> /etc/hosts
aws ec2 describe-instances --profile monitoring --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' --output text >> /etc/hosts
aws ec2 describe-instances --profile ops --query 'Reservations[].Instances[].{IP: PrivateIpAddress, Name: Tags[?Key==`Name`] | [0].Value}' --output text >> /etc/hosts
