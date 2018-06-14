# Sample Blockchain Application: Balance Transfer

This project is based on a part (balance transfer) of the source codes of fabric-samples under Hyperledger project. You can access below URL for original source codes and official documentation:
https://github.com/hyperledger/fabric-samples/tree/release/balance-transfer

Balance Transfer is a sample application based on Hyperledger Fabric SDK for Node.js. It demonstrate a basic scenario of balance transfer on Hyperledger Fabric network.

This document introduce how to use Balance Transfer sample application to work with Hyperledger Fabric v1.1 network on Alibaba Cloud Container Service.


## Prepare the environment

1. Install Node.js v8.4.0 or higher
2. Install jq： https://stedolan.github.io/jq/
3. (For CentOS or RedHat Linux only) Install g++, for example: `sudo yum install -y gcc-c++`
4. Use Blockchain Solution of Container Service of Alibaba Cloud to create a blockchain network (No need to do CLI test). Reference: https://help.aliyun.com/document_detail/64311.html



## Run the sample application

### 1. Download artifacts from blockchain network on Alibaba Cloud

The Blockchain Solution of Container Service should have already generated artifacts for blockchain application during the deployment phase of blockchain network. The artifacts include certificates, keys, configurations to be used by blockchain application. 

To download these artifacts, use the name of blockchain network and public address for SSH download as environment variable and execute the shell script to download artifacts.

For example:

```
cd balance-transfer-app
SSH_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
```

During downloading process, you will be prompted to input password for root account of your ECS node.

(Optional) Check `artifacts/org1.yaml` and `artifacts/org2.yaml` to see if we need to update organization name

### 2. Run Node server

Launch terminal 1 and execute the following command:

```
cd balance-transfer-app
./runApp.sh
```

The runApp.sh will:

- Clean up all existing docker containers and chaincode images
- Execute `npm install` command to install node modules
- Start Node server

If you want to learn more details, you can refer to the source codes of runApp.sh.

After the server is started successfully, you will see output messages similar to the following:

```
[2017-08-10 14:15:31.036] [INFO] SampleWebApp - ****************** SERVER STARTED ************************
[2017-08-10 14:15:31.036] [INFO] SampleWebApp - **************  http://localhost:4000  ******************
```



#### 3. Run all tests

First, you need to modify balance-transfer-app/testAPIs.sh as below:

* Replace names like **network01-peer1** with actual blockchain service names, according to artifacts/network-config.yaml downloaded from blockchain network
* Replace names like **bankchannel** with actual channel name, according to artifacts/network-config.yaml downloaded from blockchain network

Then launch terminal 2 and execute the following command: 

```
cd balance-transfer-app
./testAPIs.sh
```

The testAPIs.sh will perform the follow operations:

- Enroll users
- Create a new channel 
- Join channel for peers (two organizations, four peers)
- Install chaincode on all peers
- Instantiate chaincode
- Invoke chaincode (i.e. transfer money from b to a)
- Query chaincode (i.e. check the balance of a)
- Query transaction using a TransactionID
- Query general info, like chain info, installed chaincodes, instantiated chaincodes, channel

If you want to learn more details, please refer to the source codes of `testAPIs.sh`

After all tests are done, you will see output messages similar to the following:

```
Total execution time : 25 secs ...
```




