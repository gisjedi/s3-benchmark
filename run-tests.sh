#!/usr/bin/env bash


BUCKET=scale-s3-create-retrieve-test
FILES=(test-5GiB.file test-40GiB.file)
SCRATCH_FILE=/tmp/tempfile
SCRATCH_DIR=`pwd`/.tmp

./init-env.sh $SCRATCH_DIR


for FILE in "${FILES[@]}"
do

./test-cases.sh $BUCKET $FILE $SCRATCH_FILE $SCRATCH_DIR

# test all above in centos docker
echo running all tests in docker with bridge networking using volume mount
echo ==================================================
sudo docker run -it -v /tmp:/tmp -v `pwd`:`pwd` centos:7 bash -c "cd `pwd` && bash test-cases.sh $BUCKET $FILE $SCRATCH_FILE $SCRATCH_DIR"

done