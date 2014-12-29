# Validate incoming CSR for Puppet autosigning.

#### Table of Contents
1. [Overview](#overview)
2. [Client Side Configuration](#clientside)
3. [Puppet Master Side](#puppetmasterside)

## Overview

Set of scripts to needed to modify and validate Puppet CSRs when using 
the policy based autosigning features of the puppet master.

Note: This has been tested on AWS using a Ubuntu 14.04 LTS server image.


## Client Side Configuration

cloud-init on AWS was used install puppet and modify the CSR before it 
is sent to the Puppet Master. 

Copy the cloud-config.txt and cloudinit-puppet.sh to a directory and run:

    write-mime-multipart --output=combined-userdata.txt \
        cloud-config.txt \
        cloudinit-puppet.sh:text/x-shellscript


Then build an AWS instance with a command similar to:

    ec2-run-instances -O awsAccessKey \
        -W awsSecretKey --region us-west-2 \
        -f combined-userdata.txt -g sg-SecurityGroupId -k sshKeyId -n 1 \
        -s subnet-ID -t t2.micro -z us-west-2b  ami-3d50120d


Note: The following packages must be installed: ec2-api-tools, 
cloud-image-utils

Note: The DHCP must set the domain search for the DNS domain the puppet master
server resides in.  For example, if the DNS domain for the puppet master is 
example.com, then the DHCP server must set the DHCP suffix search to 
example.com.   Puppet will search for puppet.example.com


When the system boots up it will build the server using the Ubuntu 14.04 LTS
image, install Puppet, connect to the puppet master, and build the server.


## Puppet Master Side

Copy the validate-puppet.py file to /etc/puppet

Add the following lines to the master section of the /etc/puppet/puppet.conf 
file:

    [master]
    autosign = /etc/puppet/validate-puppet.py


