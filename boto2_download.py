import boto
import time
import sys

# Let's use Amazon S3
s3 = boto.connect_s3()
bucket = s3.get_bucket(sys.argv[1])
key = bucket.get_key(sys.argv[2])

start_time = time.time()
key.get_contents_to_filename(sys.argv[3])
print 'seconds downloading: %s' % (start_time - time.time())