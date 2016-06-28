#!/usr/bin/env bash


BUCKET=$1
FILE=$2
SCRATCH_FILE=$3
SCRATCH_DIR=$4


export GOPATH=$SCRATCH_DIR/GOPATH
mkdir -p $GOPATH

echo testing download of $FILE...
echo -----------------------------

# test aws cli
echo --------
echo cli test
time eval venv-4/bin/aws s3 cp s3://$BUCKET/$FILE $SCRATCH_FILE

rm $SCRATCH_FILE

for VALUE in 4 5 6 7 8 9 10 11 12
do
    # test boto3 buffer size patch
    echo -----------------------------------
    echo boto3 buffer size $((2**$VALUE))KiB
    time eval venv-$VALUE/bin/python boto3_download.py $BUCKET $FILE $SCRATCH_FILE
    rm $SCRATCH_FILE
done

# test boto
echo ----------
echo boto2 test
time eval venv-$VALUE/bin/python boto2_download.py $BUCKET $FILE $SCRATCH_FILE
rm $SCRATCH_FILE

# test goofys
echo ------
echo goofys
go get github.com/kahing/goofys
go install github.com/kahing/goofys
BUCKET_MOUNT=$SCRATCH_DIR/goofys
mkdir -p $BUCKET_MOUNT
eval $GOPATH/bin/goofys $BUCKET $BUCKET_MOUNT
GOOFYS_PID=$!
time cp $BUCKET_MOUNT/$FILE $SCRATCH_FILE
kill $GOOFYS_PID

# test goofys
echo ------
echo goofys
go get github.com/kahing/goofys
go install github.com/kahing/goofys
BUCKET_MOUNT=$SCRATCH_DIR/goofys
mkdir -p $BUCKET_MOUNT
eval $GOPATH/bin/goofys $BUCKET $BUCKET_MOUNT
time cp $BUCKET_MOUNT/$FILE $SCRATCH_FILE
umount $BUCKET_MOUNT
rm $SCRATCH_FILE


# test s3fs
echo ----
echo s3fs
cd $SCRATCH_DIR/s3fs-fuse-1.18.0
./autogen.sh
./configure
make
sudo make install
BUCKET_MOUNT=$SCRATCH_DIR/s3fs
mkdir -p $BUCKET_MOUNT
sudo /usr/local/bin/s3fs $BUCKET $BUCKET_MOUNT -o iam_role
time sudo cp $BUCKET_MOUNT/$FILE $SCRATCH_FILE
sudo umount $BUCKET_MOUNT
sudo rm -fr $SCRATCH_FILE
