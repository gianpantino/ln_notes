#!/bin/sh
#
# Check connectivity
#
#

HOME=/home/roothp/hpgoll/fsthreshold
OUT=${HOME}/01_out.txt
ERROR=${HOME}/01_error.txt
TEMP=${HOME}/temp01.txt
HOST=$1

check() {
if [ -a $OUT ]; then
        cat /dev/null > $OUT
else
        touch $OUT
fi

if [ -a $ERROR ]; then
        cat /dev/null > $ERROR
else
        touch $ERROR
fi

if [ -a $TEMP ]; then
        cat /dev/null > $TEMP
else
        touch $TEMP
fi


if [ ! -s $HOST ]; then
        echo "ERROR! File $HOST is empty."
        exit 1
else
        echo "Processing..."
fi

for i in `cat $HOST`
do
        pdsh -w $i "echo -e \"\`uname -n\`:Connected\"" 2>>$ERROR >> $TEMP
done

}
create() {
for j in `cat $HOST`
do
        grep $j $TEMP 2>>$ERROR > /dev/null

        if [ $? == "0" ]; then
                echo "$j: OK" >> $OUT
        else
                echo "$j: Please check connection" >> $OUT
        fi
done
}


if [ $# -lt 1 ]; then
    echo "Correct usage: sh 01_check.sh <host list>"
else
    check;
    create;
    rm -f $TEMP
fi
