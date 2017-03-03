#!/bin/bash
TEMP_FILE=`mktemp`
echo $"connect $1
$2
$3" > $TEMP_FILE
cat $TEMP_FILE
#cd '/cygdrive/c/Program Files (x86)/cisco/Cisco AnyConnect Secure Mobility Client'
#./vpncli.exe -s <$TEMP_FILE
vpncli -s <$TEMP_FILE
rm $TEMP_FILE
#cd /cygdrive/q/AdapteR/tests/
#Rscript ./run_testsuite.R -d /cygdrive/c/Users/phani/Downloads -u gkappler -p fzzlpass -A .
