#!/bin/bash

correctBaseDir="CAUtils"
baseDir=`basename \`pwd\``

if [ $baseDir = $correctBaseDir ]
then
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

  cp cerRootCA.crt $LEAF_CSR_FILE_PATH/cerRootCA.crt

  for fileName in $LEAF_CSR_FILE_PATH/*.csr
  do
    echo "#######################################################################"
    echo "Signing "$fileName
    cleanFileName=`basename $fileName`
    fileNameNoExtn="${cleanFileName%.*}"

    openssl ca \
      -batch \
      -md sha256 \
      -notext \
      -config $CONFIG_FILE_NAME \
      -policy signing_policy  \
      -passin file:"$ROOT_CERT_PASS_FILE_NAME" \
      -extensions signing_req \
      -out "$LEAF_CSR_FILE_PATH/$fileNameNoExtn.crt" \
      -infiles "$fileName"

    cat "$LEAF_CSR_FILE_PATH/cerRootCA.crt" "$LEAF_CSR_FILE_PATH/$fileNameNoExtn.crt" > "$LEAF_CSR_FILE_PATH/$fileNameNoExtn.chain.pem"
    echo "Signed certificate available at "$LEAF_CSR_FILE_PATH/$fileNameNoExtn.crt
    mv $fileName $LEAF_CSR_USED_FILE_PATH/$cleanFileName
    echo "#######################################################################"
  done
else
  echo "please run this script from ../$correctBaseDir"
fi
