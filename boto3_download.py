import boto3
import time
import sys

# Let's use Amazon S3
s3 = boto3.client('s3')

start_time = time.time()
s3.download_file(sys.argv[1], sys.argv[2], sys.argv[3])
print 'seconds downloading: %s' % (time.time() - start_time)