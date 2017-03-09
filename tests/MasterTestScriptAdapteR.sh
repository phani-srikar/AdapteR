#!/bin/bash
#MasterTestScriptAdapteR.sh "TD" "ODBC" "C:/Users/phani/Documents/Shell/connectionConfig.txt" "Q:/AdapteR/tests" "" "" "P:/"
#MasterTestScriptAdapteR.sh "TD" "JDBC" "C:/Users/phani/Documents/Shell/connectionConfig.txt" "Q:/AdapteR/tests" "C:/Users/phani/Downloads" "drop5" "P:/"
export IFS=","
FILEPATH=$3
cd $4
INSTALLSCRIPT=`mktemp`
if [ ! -z $6 ]
then
    branch=$6
else
    branch="master"
fi
TEMP_FILE=`mktemp`
echo $"$branch" > $TEMP_FILE
if [ "$(grep -c "tar.gz" $TEMP_FILE)" = 1 ]
then
    echo $'remove.packages("AdapteR")
install.packages("$branch",repos=NULL,type="source")' > $INSTALLSCRIPT
else
    echo $"if(require('AdapteR'))
remove.packages('AdapteR')
library(devtools)
install_github('phanisrikar93/AdapteR',ref='$branch')" > $INSTALLSCRIPT
fi
#cat $INSTALLSCRIPT
Rscript "$INSTALLSCRIPT"
cat $FILEPATH | while read platform ctype dsn DB host usr pwd
do
   # echo "$platform,$ctype,$dsn,$DB,$usr,$pwd,$host"
    if [ "$2" = "ODBC" ] && [ "$1" = "$platform" ] && [ "$ctype" = "$2" ]
    then
        Rscript run_testsuite.R -H "$dsn" -A "require" -d ".." -P "$platform" -D "$DB" -R "$7"
    elif [ "$2" = "JDBC" ] && [ "$1" = "$platform" ] && [ "$ctype" = "$2" ]
    then
        Rscript run_testsuite.R -H "$host" -A "require" -d ".." -P "$platform" -u "$usr" -p "$pwd" -D "$DB" -J "$5" -R "$7"
    fi
done
