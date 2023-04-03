#!/bin/bash
VERSION="0.0.0"

if [ $# -ne 3 ]; then
  echo "transfer_glacier_deep_archive.sh Version: $VERSION"
  echo "Usage: ./transfer_glacier_deep_archive.sh <source_account_id> <source_bucket> <destination_bucket>"
  echo "Transfer objects from a Glacier Deep Archive S3 bucket in one account to a new bucket in another account."
  exit 1
fi

SOURCE_ACCOUNT_ID="$1"
SOURCE_BUCKET="$2"
DESTINATION_BUCKET="$3"


# Create the destination bucket
aws s3api create-bucket --bucket $DESTINATION_BUCKET

# Set up cross-account permissions
BUCKET_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::$SOURCE_ACCOUNT_ID:root"
      },
      "Action": [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::$DESTINATION_BUCKET",
        "arn:aws:s3:::$DESTINATION_BUCKET/*"
      ]
    }
  ]
}
EOF
)

aws s3api put-bucket-policy --bucket $DESTINATION_BUCKET --policy "$BUCKET_POLICY"

# List objects in the source account's Glacier Deep Archive bucket
OBJECT_KEYS=$(aws s3api list-objects-v2 --bucket $SOURCE_BUCKET --query 'Contents[].{Key: Key}' --output text)

# Copy objects from the source bucket to the destination bucket
for OBJECT_KEY in $OBJECT_KEYS; do
  aws s3api copy-object --copy-source "${SOURCE_BUCKET}/${OBJECT_KEY}" --bucket $DESTINATION_BUCKET --key "${OBJECT_KEY}" --metadata-directive COPY --storage-class DEEP_ARCHIVE
done

# Verify the transferred data (optional)
aws s3api list-objects-v2 --bucket $DESTINATION_BUCKET

# Remove cross-account permissions
aws s3api delete-bucket-policy --bucket $DESTINATION_BUCKET

# Verify the transferred data
DESTINATION_OBJECT_KEYS=$(aws s3api list-objects-v2 --bucket $DESTINATION_BUCKET --query 'Contents[].{Key: Key}' --output text)

TRANSFER_SUCCESS=true
for OBJECT_KEY in $OBJECT_KEYS; do
  if [[ ! $DESTINATION_OBJECT_KEYS =~ $OBJECT_KEY ]]; then
    echo "Object not found in destination bucket: ${OBJECT_KEY}"
    TRANSFER_SUCCESS=false
  fi
done

if [ "$TRANSFER_SUCCESS" = true ]; then
  echo "Transfer verification successful. All objects have been transferred."
else
  echo "Transfer verification failed. Some objects are missing in the destination bucket."
fi
