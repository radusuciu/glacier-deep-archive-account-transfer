This project is for an AWS Glacier Deep Archive bucket that I need to transfer from one AWS account to another. I also wanted to see if I could get ChatGPT to spin up this entire project for me, and this is the result.

**NOTE**: I have yet to actually tested this myself -- this is also why I haven't cut a release via docker yet. I kind of doubt it's correct since I was under the impression that Glacier Deep Archive buckets cannot be transferred directly without being temporarily moved to a regular S3 bucket and then re-transferred to Glacier Deep Archive with a lifecycle policy. There may also be other glaring errors since I have yet to manually review anything. Until then, please see [this blog post](https://www.micahwalter.com/transferring-amazon-glacier-deep-archives-from-one-account-to-another/) from an actual human.

# AWS Glacier Deep Archive Account Transfer

This project contains two scripts that help you transfer objects from an AWS Glacier Deep Archive S3 bucket in one AWS account to another AWS account. The transfer process is handled in two separate stages to ensure the successful transfer of objects and the clean-up of resources in the source account.

## Usage

To run the scripts locally, first, clone the GitHub repository to your local machine:

```bash
git clone https://github.com/yourusername/aws-glacier-deep-archive-transfer.git
cd aws-glacier-deep-archive-transfer
```

Make sure you have the AWS CLI installed and configured with the appropriate credentials for both the source and destination AWS accounts.

### 1. transfer_glacier_deep_archive.sh

This script transfers objects from a Glacier Deep Archive S3 bucket in the source account to a new bucket in the destination account.

#### Parameters:
- Source Account ID
- Source Bucket
- Destination Bucket

#### Usage:

```bash
chmod +x transfer_glacier_deep_archive.sh
./transfer_glacier_deep_archive.sh <source_account_id> <source_bucket> <destination_bucket>
```

Replace `<source_account_id>`, `<source_bucket>`, and `<destination_bucket>` with the appropriate values for your use case.

### 2. delete_objects_and_remove_permissions.sh

This script deletes objects from the source S3 bucket and removes cross-account permissions from the destination S3 bucket.

#### Parameters:

- Source Bucket
- Destination Bucket

#### Usage:

```bash
chmod +x delete_objects_and_remove_permissions.sh
./delete_objects_and_remove_permissions.sh <source_bucket> <destination_bucket>
```

Replace `<source_bucket>` and `<destination_bucket>` with the appropriate values for your use case.

## Docker Usage

You can use Docker to run the scripts without installing the AWS CLI or other dependencies on your local machine. First, build the Docker image:

```bash
docker build -t glacier-transfer .
```

Then, run the `transfer_glacier_deep_archive.sh` script using Docker, passing the required parameters as environment variables:

```bash
docker run --rm -it -e AWS_ACCESS_KEY_ID=<your_aws_access_key> -e AWS_SECRET_ACCESS_KEY=<your_aws_secret_key> -e AWS_DEFAULT_REGION=<your_aws_region> glacier-transfer ./transfer_glacier_deep_archive.sh <source_account_id> <source_bucket> <destination_bucket>
```

Similarly, run the `delete_objects_and_remove_permissions.sh` script using Docker:

```bash
docker run --rm -it -e AWS_ACCESS_KEY_ID=<your_aws_access_key> -e AWS_SECRET_ACCESS_KEY=<your_aws_secret_key> -e AWS_DEFAULT_REGION=<your_aws_region> glacier-transfer ./delete_objects_and_remove_permissions.sh <source_bucket> <destination_bucket>
```

Replace `<your_aws_access_key>`, `<your_aws_secret_key>`, `<your_aws_region>`, `<source_account_id>`, `<source_bucket>`, and `<destination_bucket>` with the appropriate values for your use case.

Alternatively, you can create an `.env` file with the required AWS credentials and pass it to the Docker container:

```
AWS_ACCESS_KEY_ID=<your_aws_access_key>
AWS_SECRET_ACCESS_KEY=<your_aws_secret_key>
AWS_DEFAULT_REGION=<your_aws_region>
```

Then, use the `--env-file` flag to pass the `.env` file to the Docker container:

```bash
docker run --rm -it --env-file .env glacier-transfer ./transfer_glacier_deep_archive.sh <source_account_id> <source_bucket> <destination_bucket>
docker run --rm -it --env-file .env glacier-transfer ./delete_objects_and_remove_pe
```

## Warnings

Please note that data transfer costs may apply, especially if the source and destination buckets are in different regions. Review the AWS S3 pricing details before using these scripts to understand any potential charges that may be incurred.

## Credits

These scripts were inspired by the blog post [Transferring Amazon Glacier Deep Archives from One Account to Another](https://www.micahwalter.com/transferring-amazon-glacier-deep-archives-from-one-account-to-another/) by Micah Walter.

This README and the scripts were generated with the help of ChatGPT, an AI language model developed by OpenAI.
