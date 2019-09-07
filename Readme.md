# Certificate Creation & Signing Automation Utility

## Introduction

During my hunt to find a decent utility for managing the certificate workflow, I was not able to find anything decent
or highly configurable.
There was nothing available which could perform certificate workflow management i.e Create Root CA >> 
Generate CSR ( including Dynamic SAN values ) >> Sign CSR's with your Root Authority.
With help from Scott Griz and his base scripts, I started working on something fully automated.  

This project provides a few utilities to ease the pain of certificate management with few commands.
 The project will perform the following actions:
* Create Root CA
* Generate CSRs using data from a hosts file
* Sign CSRs with your Root Authority and record signed certificates. 

## Quick Start

### Generate Root Authority 

1. Clone the Repo.
2. `run nukeEverything.sh` : This command will clean any remnants (if any) from the project folder and help you start fresh.
3. `change directory to CAUtils` : This is required in the current version. 
CA scripts are dependent on $PWD being the CAUtils folder for proper functioning.
4. `edit signingCA.cnf` : Change the attribute values as desired. 
Do NOT remove any values from the configuration file unless you know what you are doing.
They play an important role in the complete end to end workflow. 
5. `edit CAPass.txt` : Change the password value, as desired. 
This is the Root Authority encryption password.
6. `edit keyPass.txt` : Change the password, as desired.
This is the Root Key encryption password.
7. ` execute issueRootCerts.sh` : This will generate the Root Authority Key and certificate.
The key is stored in `keyRootCA.key` and Root CA is stored in `cerRootCA.pem`


### Generate CSRs
1. `change directory to LeafUtils` : This is required in the current version. 
Leaf scripts are dependent on $PWD being the LeafUtils folder for proper functioning.
2. `edit keyPass.txt` : Change the password, as desired.
This is the Server certificate Key encryption password.
3. `edit csrreq.cnf` : Change values to match your Certificate need as required.
Do NOT remove any values from the configuration file unless you know what you are doing.
They play an important role in the complete end to end workflow. 
4. `edit hosts.txt` : Every line in this file is ~ separated data feed.
The first part is CN name of the certificate.
The part after ~ is the SAN name list with the format DNS:value,DNS:value,DNS:value....
If the SAN list is not provided, the first SAN entry will always contain CN name by default.
5. `execute issueCSRs.sh` : This will create a CSR request with all the SAN names in the hosts.txt included.
The dynamic SAN entry is a unique feature of this script. 
The output of this script are 2 types of files - 
Certificate KEY file and the Certificate CSR file. 
The CSR file is the one, which will be required in the next step to get Authority signed, SAN included certificates. 


### Generate Signed Certificates
1. `change directory to CAUtils` : This is required in the current version. 
CA scripts are dependent on $PWD being the CAUtils folder for proper functioning.
2. `signingCA.cnf` : Do _NOT_ change any attribute value in this file. 
Do NOT remove any values from the configuration file unless you know what you are doing.
They play an important role in the complete end to end workflow. 
3. `run issueSignedCerts.sh` :  This will read all the CSR's created in the ../LeafUtils folder and generate corresponding Signed certificates for them.
The signed certificates will be stored in the ../LeafUtils folder for further use.
The CSR's picked up from ../LeafUtils folder for creating signed certificates will moved the ../LeafUtils/UsedCSRs by default. 
This is done to prevent recreation of another certificate for existing ones during next run for signed certificates.  

An audit trail of signing activity is stored under the CAUtils/issuedCerts folder. 
The `index.txt` file maintains the audit trail for every signing request created. 
A copy of the certificates generated is also stored in this location.

DONE !!! 

### Quick Tips
1. `nukeEverything.sh` : This command is used to clean up everything. 
Run the command from its home directory, other wise, I cannot confirm what it can do. ;) 
2. `cleanOutDir.sh` : This script is available in every major folder and can be used to clean a specific folder. 

For Eg: If you want to clean just the issuedCerts folder, you can run `cleanOutDir.sh` in that folder. 
It will nuke only that folder like nothing happened and reset it to its clone condition. 
Extremely useful, if you want to create certificates over and over without remnants in the audit trail.
