#!/usr/bin/env bash

BUCKET=$1
FILE=$2
SCRATCH_FILE=$3

echo testing download of $FILE...
echo -----------------------------

# test aws cli
echo cli test
time eval venv-4/bin/aws s3 cp s3://$BUCKET/$FILE $SCRATCH_FILE

rm $SCRATCH_FILE

for VALUE in 4 5 6 7 8 9 10 11 12
do
    # test boto3 buffer size patch
    echo boto3 buffer size $((2**$VALUE))KiB
    time eval venv-$VALUE/bin/python boto3_download.py $BUCKET $FILE $SCRATCH_FILE
    rm $SCRATCH_FILE
done

# test boto
echo boto2 test
time eval venv-$VALUE/bin/python boto2_download.py $BUCKET $FILE $SCRATCH_FILE
rm $SCRATCH_FILE