#!/bin/bash

CONFIG_FILE_NAME=signingCA.cnf
ROOT_CERT_PASS_FILE_NAME=CAPass.txt
LEAF_CSR_FILE_PATH=./leafUtils

for fileName in $LEAF_CSR_FILEPATH
do
  echo "#######################################################################"
  echo "Signing "$fileName
  fileNameNoExtn="${fileName%.*}"
  openssl ca \
    -config $CONFIG_FILE_NAME \
    -policy signing_policy  \
    -passin file:$ROOT_CERT_PASS_FILE_NAME \
    -extensions signing_req \
    -out $LEAF_CSR_FILE_PATH/$LEAF_CSR_FILE_PATH.pem \
    -infiles $LEAF_CSR_FILE_PATH/$fileName
  echo "Signed certificate available at "$LEAF_CSR_FILE_PATH/$LEAF_CSR_FILE_PATH.pem
  echo "#######################################################################"
done
