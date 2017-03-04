#!/bin/bash
#Args:ScriptsPath, JarsPath, gitBranchToTest, resultsPath
#runFullPlatformTests.sh  "P:/" "C:/Users/phani/Downloads" "AutoTesting"
export IFS=","
cd $1
rm -rf AdapteR
branch="master"
if [ ! -z $3 ]
then
   branch=$3
fi
git clone -b $branch https://github.com/phanisrikar93/AdapteR
cd "AdapteR/tests"
FILESPATH="$1/AdapteR/tests"
configFILE="$FILESPATH/connectionConfig.txt"
cat "$configFILE" | while read platform ctype dsn DB host usr pwd
do
    echo -e " \n \n ######### Testing AdapteR on : $platform : using : $ctype : ########### \n \n "
    ./MasterTestScriptAdapteR.sh "$platform" "$ctype" "$configFILE" "$FILESPATH" "$2"
    echo -e " \n \n ######### END Testing AdapteR on : $platform : using : $ctype : END END : ############## \n \n "
done
