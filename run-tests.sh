#!/usr/bin/env bash


BUCKET=scale-s3-create-retrieve-test
FILES=(test-5GiB.file test-40GiB.file)
SCRATCH_FILE=/tmp/tempfile

for FILE in $FILES
do

./test-cases.sh $BUCKET $FILE $SCRATCH_FILE

# test all above in centos docker
echo running all tests in docker with bridge networking
echo ==================================================
sudo docker run -it -v /tmp:/tmp -v `pwd`:`pwd` centos:7 bash -c "cd `pwd` && bash test-cases.sh $BUCKET $FILE $SCRATCH_FILE"

done