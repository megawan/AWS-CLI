aws s3 ls s3://bucket-src --recursive | awk '{print $4}' > list.txt

while read S3PATH; do
    aws s3 cp s3://bucket-src/$S3PATH s3://bucket-dest
    done < list.txt
