#!/bin/bash

correctBaseDir="issuedCerts"
baseDir=`basename \`pwd\``

if [ $baseDir = $correctBaseDir ]
then
  echo "Removing Cached Certificates"
  rm ./*.crt 2>/dev/null

  echo "Removing Cached Certificates"
  rm ./*.pem 2>/dev/null

  echo "removing remnant working files"
  rm ./*.old 2>/dev/null

  rm ./index.txt 2>/dev/null
  touch index.txt
  echo '01' > serial.txt
else
  echo "please run this script from ../$correctBaseDir"
fi
