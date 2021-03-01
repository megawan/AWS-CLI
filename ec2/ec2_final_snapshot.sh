while read INSTANCE; do
  VOLUMEID=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE" --query "Reservations[*].Instances[*].[BlockDeviceMappings[*].Ebs.VolumeId]" --profile sandbox --output text`
  COUNT=`echo $VOLUMEID|wc -w`
  COUNT1=$(echo $(( $COUNT - 1 )))
  timestamp=$(date "+%H:%M:%S %d/%m/%Y")
  echo "instance name=$INSTANCE, volumeId=$VOLUMEID"
  for i in $(seq 0 $COUNT1)
  do
   NEST=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE" --query "Reservations[*].Instances[*].[BlockDeviceMappings[$i].Ebs.VolumeId]" --profile sandbox --output text`
   DEVICENAME=`aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE" --query "Reservations[*].Instances[*].[BlockDeviceMappings[$i].DeviceName]" --profile sandbox --output text`
   aws ec2 create-snapshot --profile sandbox --volume-id $NEST --description "Created by script at $timestamp" --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$INSTANCE-($DEVICENAME)-final}]"
  done
  #aws ec2 create-snapshot --profile sandbox --volume-id $VOLUMEID --description "Created by script at $timestamp" --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$INSTANCE-FINAL}]"
done < instance.txt
