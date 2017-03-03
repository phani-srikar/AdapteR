#!/bin/bash
#MasterTestScriptAdapteR.sh "TD" "ODBC" "C:/Users/phani/Documents/Shell/connectionConfig.txt" "Q:/AdapteR/tests"
#MasterTestScriptAdapteR.sh "TD" "JDBC" "C:/Users/phani/Documents/Shell/connectionConfig.txt" "Q:/AdapteR/tests" "C:/Users/phani/Downloads"
export IFS=","
FILEPATH=$3
cd $4
cat $FILEPATH | while read platform ctype dsn DB host usr pwd
do
    echo "$platform,$ctype,$dsn,$DB,$usr,$pwd,$host"
    if [ "$2" = "ODBC" ] && [ "$1" = "$platform" ] && [ "$ctype" = "$2" ]
    then
        Rscript run_testsuite.R -H "$dsn" -A "require" -d ".." -P "$platform" -D "$DB"
    elif [ "$2" = "JDBC" ] && [ "$1" = "$platform" ] && [ "$ctype" = "$2" ]
    then
        Rscript run_testsuite.R -H "$host" -A "require" -d ".." -P "$platform" -u "$usr" -p "$pwd" -D "$DB" -J "$5" -j "$6"
    fi
done
