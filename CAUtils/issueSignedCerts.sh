#!/bin/bash

CA_DIR=$PWD

CONFIG_FILE_NAME=$PWD/signingCA.cnf
ROOT_CERT_PASS_FILE_NAME=$CA_DIR/CAPass.txt
LEAF_CSR_FILE_PATH=../LeafUtils
LEAF_CSR_USED_FILE_PATH=$LEAF_CSR_FILE_PATH/UsedCSRs

#Create Directory to park used CSR Requests
mkdir -p $LEAF_CSR_USED_FILE_PATH

cd $LEAF_CSR_FILE_PATH
LEAF_CSR_FILE_PATH=$PWD
LEAF_CSR_USED_FILE_PATH=$LEAF_CSR_FILE_PATH/UsedCSRs
cd -

for fileName in $LEAF_CSR_FILE_PATH/*.csr
do
  echo "#######################################################################"
  echo "Signing "$fileName
  cleanFileName=`basename $fileName`
  fileNameNoExtn="${cleanFileName%.*}"

  openssl ca \
    -batch \
    -config $CONFIG_FILE_NAME \
    -policy signing_policy  \
    -passin file:"$ROOT_CERT_PASS_FILE_NAME" \
    -extensions signing_req \
    -out "$LEAF_CSR_FILE_PATH/$fileNameNoExtn.pem" \
    -infiles "$fileName"

  echo "Signed certificate available at "$LEAF_CSR_FILE_PATH/$fileNameNoExtn.pem
  mv $fileName $LEAF_CSR_USED_FILE_PATH/$cleanFileName
  echo "#######################################################################"
done

