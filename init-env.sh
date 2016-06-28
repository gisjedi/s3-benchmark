#!/usr/bin/env bash

SCRATCH_DIR=$1

mkdir $SCRATCH_DIR

# set up virtual environments
sudo pip install virtualenv -U
for VALUE in 4 5 6 7 8 9 10 11 12
do
	virtualenv $SCRATCH_DIR/venv-$VALUE
	eval $SCRATCH_DIR/venv-$VALUE/bin/pip install -r requirements.txt
	export EXPONENT=`echo $((2**$VALUE))`
	sed -i 's|\*\ 16|\*\ '$EXPONENT'|g' $SCRATCH_DIR/venv-$VALUE/lib/python2.7/site-packages/boto3/s3/transfer.py
done

sudo yum install -y golang
sudo yum install -y automake fuse-devel fuse gcc-c++ git libcurl-devel libxml2-devel make openssl-devel
