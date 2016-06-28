#!/usr/bin/env bash

# set up virtual environments
sudo pip install virtualenv -U
for VALUE in 4 5 6 7 8 9 10 11 12
do
	virtualenv venv-$VALUE
	eval venv-$VALUE/bin/pip install -r requirements.txt
	export EXPONENT=`echo $((2**$VALUE))`
	sed -i 's|\*\ 16|\*\ '$EXPONENT'|g' venv-$VALUE/lib/python2.7/site-packages/boto3/s3/transfer.py
done

