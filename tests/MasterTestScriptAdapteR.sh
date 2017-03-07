#!/bin/bash
#MasterTestScriptAdapteR.sh "TD" "ODBC" "C:/Users/phani/Documents/Shell/connectionConfig.txt" "Q:/AdapteR/tests" "" "" "C:/Users/phani/Desktop"
#MasterTestScriptAdapteR.sh "TD" "JDBC" "C:/Users/phani/Documents/Shell/connectionConfig.txt" "Q:/AdapteR/tests" "C:/Users/phani/Downloads" "" "C:/Users/phani/Desktop"
export IFS=","
FILEPATH=$3
cd $4
INSTALL_FILE=`mktemp`
echo $'remove.packages("AdapteR")
library(devtools)
install_github("Fuzzy-Logix/AdapteR",ref="$branch")' > $INSTALL_FILE
Rscript $INSTALL_FILE
rm $INSTALL_FILE
cat $FILEPATH | while read platform ctype dsn DB host usr pwd
do
    echo "$platform,$ctype,$dsn,$DB,$usr,$pwd,$host"
    if [ "$2" = "ODBC" ] && [ "$1" = "$platform" ] && [ "$ctype" = "$2" ]
    then
        Rscript run_testsuite.R -H "$dsn" -A "require" -d ".." -P "$platform" -D "$DB" -R $6
    elif [ "$2" = "JDBC" ] && [ "$1" = "$platform" ] && [ "$ctype" = "$2" ]
    then
        Rscript run_testsuite.R -H "$host" -A "require" -d ".." -P "$platform" -u "$usr" -p "$pwd" -D "$DB" -J "$5" -j "$6" -R $6
    fi
done
