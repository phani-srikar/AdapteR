#!/bin/bash
#Args:ScriptsPath, JarsPath, gitBranchToTest, resultsPath
#runFullPlatformTests.sh  "P:" "C:/Users/phani/Downloads" "knn" "C:/Users/phani/Desktop"
#To run only ODBC, edit the config file to contain only ODBC entries and use:
#runFullPlatformTests.sh  "P:" "" "" ""
export IFS=","
cd $1
rm -rf AdapteR
branch="master"
resultsPath=$1
if [ ! -z $3 ]
then
   branch=$3
fi
if [ ! -z $4 ]
then
   resultsPath=$4
fi
git clone -b $branch https://github.com/phanisrikar93/AdapteR
cd "AdapteR/tests"
FILESPATH="$1/AdapteR/tests"
configFILE="$FILESPATH/connectionConfig.txt"
cat "$configFILE" | while read platform ctype dsn DB host usr pwd
do
    echo -e " \n \n ######### Testing AdapteR on : $platform : using : $ctype : ########### \n \n "
    ./MasterTestScriptAdapteR.sh "$platform" "$ctype" "$configFILE" "$FILESPATH" "$2" "$branch" "$resultsPath"
    echo -e " \n \n ######### END Testing AdapteR on : $platform : using : $ctype : END END : ############## \n \n "
done
rm -rf AdapteR
