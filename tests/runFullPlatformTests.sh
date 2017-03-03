#!/bin/bash
#Args:ScriptsPath, JarsPath, gitBranchToTest
#runFullPlatformTests.sh  "P:/" "C:/Users/phani/Downloads" "AutoTesting"
export IFS=","
cd $1
rm -rf AdapteR
branch="master"
if [ ! -z $3 ]
   branch=$3
   git clone -b $branh https://github.com/phanisrikar93/AdapteR
cd AdapteR/tests
FILEPATH="connectionConfig.txt"
cat $FILEPATH | while read platform ctype dsn DB host usr pwd
do
    echo -e " \n \n ######### Testing AdapteR on : $platform : using : $ctype : ########### \n \n "
    ./MasterTestScriptAdapteR.sh "$platform" "$ctype" "$FILEPATH" "$1" "$2"
    echo -e " \n \n ######### END Testing AdapteR on : $platform : using : $ctype : END END : ############## \n \n "
done
