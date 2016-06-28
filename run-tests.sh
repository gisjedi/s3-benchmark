#!/usr/bin/env bash


BUCKET=scale-s3-create-retrieve-test
FILES=(test-5GiB.file test-40GiB.file)
SCRATCH_FILE=/tmp/tempfile

for FILE in $FILES
do

./test-cases.sh $BUCKET $FILE $SCRATCH_FILE

# test all above in centos docker
sudo docker run -it -v /tmp:/tmp -v `pwd`:/root centos:7 bash test-cases.sh $BUCKET $FILE $SCRATCH_FILE

done