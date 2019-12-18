#!/bin/bash

correctBaseDir="LeafUtils"
baseDir=`basename \`pwd\``

if [ $baseDir = $correctBaseDir ]
then
  echo "Removing Old Root Certificate and Key"
  rm ./*.key ./*.csr ./*.pem 2>/dev/null
  rm ..pem 2>/dev/null

  echo "Clean out temp remnants ( if any )"
  rm ./tempcsrlist.txt ./tempcsrreq.cnf 2>/dev/null

  echo "Removing Old CSRs"
  cd UsedCSRs
  rm ./*.csr 2>/dev/null
else
  echo "please run this script from ../$correctBaseDir"
fi
