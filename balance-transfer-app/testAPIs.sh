#!/bin/bash
#
# Copyright Alibaba Group. All Rights Reserved.
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# set -x 

function waitForAnyKey() {
  echo
	read -n 1 -s -p ">>>>>> Wait for any key to continue >>>>>>"
  echo
}

# If CHANNEL_NAME is not provided, set to default value
#
###############################################################
#
# IMPORTANT NOTE:
#   Before running this script, ensure you have replace the 
#   EXTERNAL_ADDRESS with actual external address, and also
#   check the ports used are consistent with your actual ports
#   in use.    
#
#   If you want to use a different channel, in addition to 
#   setting the CHANNEL_NAME here, you must also update the
#   channelName in config.json, then restart runApp.sh
#
###############################################################
if [ -z $1 ]; then
	CHANNEL_NAME="mychannel"
else
  CHANNEL_NAME="$1"
fi

jq --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Please Install 'jq' https://stedolan.github.io/jq/ to execute this script"
	echo
	exit 1
fi
starttime=$(date +%s)

echo "POST request Enroll on Org1  ..."
echo
ORG1_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Jim&orgName=org1')
echo $ORG1_TOKEN
ORG1_TOKEN=$(echo $ORG1_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG1 token is $ORG1_TOKEN"

waitForAnyKey

echo
echo "POST request Enroll on Org2 ..."
echo
ORG2_TOKEN=$(curl -s -X POST \
  http://localhost:4000/users \
  -H "content-type: application/x-www-form-urlencoded" \
  -d 'username=Barry&orgName=org2')
echo $ORG2_TOKEN
ORG2_TOKEN=$(echo $ORG2_TOKEN | jq ".token" | sed "s/\"//g")
echo
echo "ORG2 token is $ORG2_TOKEN"
echo

waitForAnyKey

echo
echo "POST request Create channel  ..."
echo
curl -s -X POST \
  http://localhost:4000/channels \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"channelName":"'$CHANNEL_NAME'",
	"channelConfigPath":"../artifacts/channel/'$CHANNEL_NAME'.tx"
}'
echo

echo "Wait some time for the new channel to be propogated in fabric network ..."
sleep 30

echo
waitForAnyKey

echo
echo "POST request Join channel on Org1"
echo
curl -s -X POST \
  http://localhost:4000/channels/$CHANNEL_NAME/peers \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["EXTERNAL_ADDRESS:7051","EXTERNAL_ADDRESS:7061"]
}'
echo

waitForAnyKey

echo
echo "POST request Join channel on Org2"
echo
curl -s -X POST \
  http://localhost:4000/channels/$CHANNEL_NAME/peers \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["EXTERNAL_ADDRESS:7071","EXTERNAL_ADDRESS:7081"]
}'
echo

waitForAnyKey

echo
echo "POST Install chaincode on Org1"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["EXTERNAL_ADDRESS:7051","EXTERNAL_ADDRESS:7061"],
	"chaincodeName":"mycc",
	"chaincodePath":"github.com/example_cc",
	"chaincodeVersion":"v0"
}'
echo

waitForAnyKey

echo
echo "POST Install chaincode on Org2"
echo
curl -s -X POST \
  http://localhost:4000/chaincodes \
  -H "authorization: Bearer $ORG2_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["EXTERNAL_ADDRESS:7071","EXTERNAL_ADDRESS:7081"],
	"chaincodeName":"mycc",
	"chaincodePath":"github.com/example_cc",
	"chaincodeVersion":"v0"
}'
echo

waitForAnyKey

echo
echo "POST instantiate chaincode on peer1 of Org1"
echo
curl -s -X POST \
  http://localhost:4000/channels/$CHANNEL_NAME/chaincodes \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"chaincodeName":"mycc",
	"chaincodeVersion":"v0",
	"functionName":"init",
	"args":["a","100","b","200"]
}'
echo

waitForAnyKey

echo
echo "POST invoke chaincode on peers of Org1 and Org2"
echo
TRX_ID=$(curl -s -X POST \
  http://localhost:4000/channels/$CHANNEL_NAME/chaincodes/mycc \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json" \
  -d '{
	"peers": ["EXTERNAL_ADDRESS:7051", "EXTERNAL_ADDRESS:7071"],
	"fcn":"move",
	"args":["a","b","10"]
}')
echo "Transacton ID is $TRX_ID"
echo

waitForAnyKey

echo
echo "GET query chaincode on peer1 of Org1"
echo
curl -s -X GET \
  "http://localhost:4000/channels/$CHANNEL_NAME/chaincodes/mycc?peer=peer1&fcn=query&args=%5B%22a%22%5D" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo

waitForAnyKey

echo
echo "GET query Block by blockNumber"
echo
curl -s -X GET \
  "http://localhost:4000/channels/$CHANNEL_NAME/blocks/1?peer=peer1" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo

waitForAnyKey

echo
echo "GET query Transaction by TransactionID"
echo
curl -s -X GET http://localhost:4000/channels/$CHANNEL_NAME/transactions/$TRX_ID?peer=peer1 \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo

waitForAnyKey

############################################################################
### TODO: What to pass to fetch the Block information
############################################################################
#echo "GET query Block by Hash"
#echo
#hash=????
#curl -s -X GET \
#  "http://localhost:4000/channels/$CHANNEL_NAME/blocks?hash=$hash&peer=peer1" \
#  -H "authorization: Bearer $ORG1_TOKEN" \
#  -H "cache-control: no-cache" \
#  -H "content-type: application/json" \
#  -H "x-access-token: $ORG1_TOKEN"
#echo
#echo

echo
echo "GET query ChainInfo"
echo
curl -s -X GET \
  "http://localhost:4000/channels/$CHANNEL_NAME?peer=peer1" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo

waitForAnyKey

echo
echo "GET query Installed chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=installed" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo

waitForAnyKey

echo
echo "GET query Instantiated chaincodes"
echo
curl -s -X GET \
  "http://localhost:4000/chaincodes?peer=peer1&type=instantiated" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo

waitForAnyKey

echo
echo "GET query Channels"
echo
curl -s -X GET \
  "http://localhost:4000/channels?peer=peer1" \
  -H "authorization: Bearer $ORG1_TOKEN" \
  -H "content-type: application/json"
echo
echo


echo "Total execution time : $(($(date +%s)-starttime)) secs ..."
