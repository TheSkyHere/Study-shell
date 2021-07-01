#!/bin/bash

#export UBUNTU_MENUPROXY=0

function usage()
{
    echo "please select MDS version"
    echo "7 MDS 3.7.7"
    echo "1 MDS 4.0.1"
    echo "2 MDS 4.0.2"
    echo "3 MDS 4.0.3"
    echo "12 MDS 12.0.1"
    echo "example: sudo MDS 2"
    exit 0
}

if [ $# == 0 ]
then
    usage
fi
mdsselect=""
if [ $1 == 7 ]
then
    mdsselect="mds-3.7.7/MDS"
elif [ $1 == 1 ]
then
    mdsselect="mds-4.0.1/MDS"
elif [ $1 == 2 ]
then
    mdsselect="mds-4.0.2/MDS"
elif [ $1 == 3 ]
then
    mdsselect="mds-4.0.3"
elif [ $1 == 12 ]
then
    mdsselect="mds-12.0.1/MDS"
else
    usage
fi

echo "You select ${mdsselect}"

export PATH="/opt/mds/${mdsselect}":${PATH}
echo ${PATH}
python --version
MDS
