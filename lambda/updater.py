# Process input from S3
import boto3
import json
import os
from botocore.exceptions import ClientError

# Pull configuration out of the environment
BUCKET_NAME = os.environ['s3_bucket']
DYNAMODB_TABLE = os.environ['dynamodb_table']
SOURCE_KEYS = os.environ['keys'].split(",")
TMP_FILE = '/tmp/source.json'


def handler(event, context):
    """
    Handle incoming S3 notification events
    """
    print("Incoming event: ", event)

    key = event['Records'][0]['s3']['object']['key']

    print("Object key: ", key)

    # Download file
    s3 = boto3.client('s3')
    try:
        s3.download_file(BUCKET_NAME, key, TMP_FILE)
    except ClientError as e:
        if e.response['Error']['Code'] == '404':
            print('The object does not exist.')
        else:
            raise

    # Parse file
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(DYNAMODB_TABLE)

    print("Processing:", TMP_FILE)

    with open(TMP_FILE, 'r') as json_file:
        data = json.load(json_file)

        for entry in data:
            # Dict comprehension to pull specific items out of the data based
            # on their source key.
            item = {
                key: value
                for (key, value)
                in entry.items()
                if key in SOURCE_KEYS
            }

            print("Inserting item into DynamoDB: ", item)

            # put_item returns a response here, but we ignore it.
            table.put_item(
                Item=item,
            )
