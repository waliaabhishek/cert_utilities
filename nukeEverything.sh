#!/bin/bash

dir1Count=`find CAUtils -type d | wc -l`
dir2Count=`find LeafUtils -type d | wc -l`

if [ $dir1Count -eq 2 ] && [ $dir2Count -eq 2 ]
then
  cd CAUtils
  ./cleanOutDir.sh

  cd issuedCerts
  ./cleanOutDir.sh

  cd ../../LeafUtils
  ./cleanOutDir.sh
else
  echo "please run this script from the base directory of the GIT repo."
fi
