#!/bin/bash

touch rds.txt
echo "" > rds.txt

for a in $(aws --profile root rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier]' --output text);
do 
    echo $a >> rds.txt
    aws rds --profile root  describe-db-log-files --db-instance-identifier $a --output table >> rds.txt
done