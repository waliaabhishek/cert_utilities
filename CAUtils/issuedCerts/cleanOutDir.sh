#!/bin/bash

echo "Removing Cached Certificates"
rm *.pem

echo "removing remnant working files"
rm *.old

rm index.txt
touch index.txt
echo '01' > serial.txt

