#!/bin/bash

correctBaseDir="LeafUtils"
baseDir=`basename \`pwd\``

if [ $baseDir = $correctBaseDir ]
then
  KEY_PASS_FILE_NAME=keyPass.txt
  HOSTS_FILE_NAME=hosts.txt
  CSRCONF_FILE_NAME=csrreq.cnf
  TEMP_FILE_NAME=tempcsrlist.txt
  CONCAT_FILE_NAME=tempcsrreq.cnf

  cat $HOSTS_FILE_NAME | while read line
  do
    echo "##################################################"
    ## Grab short name in case you need it for SAN
    SHORT_NAME=${line%%.*}
    CN_NAME_STRING=`echo $line | cut -s -d "~" -f1`
    DNS_NAMES_STRING=`echo $line | cut -s -d "~" -f2`
    echo "Generating CSR for "$CN_NAME_STRING

    if [ -z "$DNS_NAMES_STRING" ];
    then
      CN_NAME_STRING=`echo $line`
      DNS_NAMES_STRING=`echo DNS:$line`
    else
      DNS_NAMES_STRING=`echo DNS:$CN_NAME_STRING , $DNS_NAMES_STRING`
    fi

    #### Create config for use in CSR Request accepted format
    echo "subjectAltName = $DNS_NAMES_STRING" > $TEMP_FILE_NAME

    if [ -e $CN_NAME_STRING.key ]
    then
      echo "The Key for $CN_NAME_STRING already exists. Not Regenerating Key."
    else
      # Create the Encrypted Private Key
      openssl genrsa \
        -aes256 \
        -passout file:$KEY_PASS_FILE_NAME \
        -out $CN_NAME_STRING.key \
        4096

      # Provide Unencrypted Key
      openssl rsa \
        -in $CN_NAME_STRING.key \
        -passin file:$KEY_PASS_FILE_NAME \
        -out $CN_NAME_STRING.unencrypted.key
    fi

    # Create one single file with all the configs ( tried cat withount new file, but openssl was flaky
    cat $CSRCONF_FILE_NAME $TEMP_FILE_NAME > $CONCAT_FILE_NAME
    sed -i '' "s/__ENV_COMMON_NAME__/$CN_NAME_STRING/g" $CONCAT_FILE_NAME

    if [ -e $CN_NAME_STRING.csr ] || [ -e $CN_NAME_STRING.crt ]
    then
      echo "The CSR or Certificate for $CN_NAME_STRING already exists. Not Regenerating CSR."
    else
      # Generate CSR Request
      openssl req \
        -new \
        -sha256 \
        -out $CN_NAME_STRING.csr \
        -key $CN_NAME_STRING.key \
        -passin file:"$KEY_PASS_FILE_NAME" \
        -config $CONCAT_FILE_NAME
    fi

  done

  ## Clean Up
  rm $TEMP_FILE_NAME $CONCAT_FILE_NAME
else
  echo "please run this script from ../$correctBaseDir"
fi
