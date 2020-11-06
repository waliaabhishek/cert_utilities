#!/bin/bash

CONFIG_FILE_NAME=./signingCA.cnf
KEY_PASS_FILE_NAME=./keyPass.txt
ROOT_CERT_PASS_FILE_NAME=./CAPass.txt
ROOT_CERT_FILE_NAME=./cerRootCA.crt
ROOT_KEY_FILE_NAME=./keyRootCA.key

correctBaseDir="CAUtils"
baseDir=`basename \`pwd\``

if [ $baseDir = $correctBaseDir ]
then
  openssl req \
    -x509 \
    -config $CONFIG_FILE_NAME \
    -newkey rsa:4096 \
    -sha256 \
    -passin file:$KEY_PASS_FILE_NAME \
    -passout file:$ROOT_CERT_PASS_FILE_NAME \
    -out $ROOT_CERT_FILE_NAME \
    -outform PEM \
    -keyout $ROOT_KEY_FILE_NAME \
    -batch
else
  echo "please run this script from ../$correctBaseDir"
fi
