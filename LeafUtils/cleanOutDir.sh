#!/bin/bash

echo "Removing Old Root Certificate and Key"
rm *.key *.csr *.pem
rm ..pem

echo "Clean out temp remnants ( if any )"
rm tempcsrlist.txt tempcsrreq.cnf

echo "Removing Old CSRs"
cd UsedCSRs
rm *.csr
