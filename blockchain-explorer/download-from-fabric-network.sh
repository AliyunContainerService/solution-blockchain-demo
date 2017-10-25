#!/bin/bash
#####################################################################################
# How to use: 
# For example:
# EXTERNAL_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
#####################################################################################

# Debug mode
set -x

rm -rf ./artifacts/*

scp -r root@${EXTERNAL_ADDRESS}:/data/fabric/${FABRIC_NETWORK}/sdk/* ./artifacts/
scp -r root@${EXTERNAL_ADDRESS}:/data/fabric/${FABRIC_NETWORK}/config/explorer/network-config-tls.json  ./app/network-config-tls.json
scp -r root@${EXTERNAL_ADDRESS}:/data/fabric/${FABRIC_NETWORK}/config/explorer/config.json  ./config.json