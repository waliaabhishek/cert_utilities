#!/bin/bash

CONFIG_FILE_NAME=signingCA.cnf
KEY_PASS_FILE_NAME=keyPass.txt
ROOT_CERT_PASS_FILE_NAME=CAPass.txt
ROOT_CERT_FILE_NAME=cerRootCA.pem
ROOT_KEY_FILE_NAME=keyRootCA.pem

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
