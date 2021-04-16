# Process input from S3
import boto3
import json
import os
import tempfile
from botocore.exceptions import ClientError

# Pull configuration out of the environment
BUCKET_NAME = os.environ['s3_bucket']
DYNAMODB_TABLE = os.environ['dynamodb_table']
SOURCE_KEYS = os.environ['keys'].split(",")


def handler(event, context):
    """
    Handle incoming S3 notification events
    """
    print("Incoming event: ", event)

    key = event['Records'][0]['s3']['object']['key']

    print("Object key: ", key)

    # Download file
    s3 = boto3.client('s3')
    tmpfile = tempfile.NamedTemporaryFile(delete=False)

    try:
        s3.download_fileobj(BUCKET_NAME, key, tmpfile)
        tmpfile.close()
    except ClientError as e:
        if e.response['Error']['Code'] == '404':
            print('The object does not exist.')
        else:
            raise

    # Parse file
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(DYNAMODB_TABLE)

    print("Processing:", tmpfile.name)

    # We have to work with a batch writer, otherwise this takes far too long
    # to insert all items.
    with open(tmpfile.name, 'r') as json_file, table.batch_writer() as batch:
        data = json.load(json_file)

        for entry in data:
            # Dict comprehension to pull specific items out of the data
            # based on their source key.
            item = {
                key: value
                for (key, value)
                in entry.items()
                if key in SOURCE_KEYS
            }

            # put_item returns a response here, but we ignore it.
            batch.put_item(
                Item=item,
            )

    print("File processed")

    # Attempt to unlink the tmpfile, but it's no disaster if it fails. The
    # Lambda container will be recycled at some point, destroying it anyway.
    try:
        print("Removing tempfile")
        os.unlink(tmpfile.name)
    except Exception:
        pass

    print("All done")
