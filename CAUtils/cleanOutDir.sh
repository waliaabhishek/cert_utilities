#!/bin/bash

correctBaseDir="CAUtils"
baseDir=`basename \`pwd\``

if [ $baseDir = $correctBaseDir ]
then
  echo "Removing Old Root Certificate and Key"
  rm ./*.crt ./*.pem 2>/dev/null
else
  echo "please run this script from ../$correctBaseDir"
fi

