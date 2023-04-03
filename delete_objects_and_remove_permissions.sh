#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage: ./delete_objects_and_remove_permissions.sh <source_bucket> <destination_bucket>"
  echo "Delete objects from the source S3 bucket and remove cross-account permissions from the destination S3 bucket."
  exit 1
fi

SOURCE_BUCKET="$1"
DESTINATION_BUCKET="$2"

# Get object keys from the source bucket
OBJECT_KEYS=$(aws s3api list-objects-v2 --bucket $SOURCE_BUCKET --query 'Contents[].{Key: Key}' --output text)

# Delete objects from the source account
for OBJECT_KEY in $OBJECT_KEYS; do
  echo "Deleting object: ${OBJECT_KEY}"
  aws s3api delete-object --bucket $SOURCE_BUCKET --key "${OBJECT_KEY}"
done

# Remove cross-account permissions by deleting the bucket policy
echo "Removing bucket policy for: $DESTINATION_BUCKET"
aws s3api delete-bucket-policy --bucket $DESTINATION_BUCKET
