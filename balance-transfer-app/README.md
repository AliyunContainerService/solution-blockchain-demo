# Sample Blockchain Application: Balance Transfer

This project is based on a part (balance transfer) of the source codes of fabric-samples under Hyperledger project. You can access below URL for original source codes and official documentation:
https://github.com/hyperledger/fabric-samples/tree/release/balance-transfer

Balance Transfer is a sample application based on Hyperledger Fabric SDK for Node.js. It demonstrate a basic scenario of balance transfer on Hyperledger Fabric network.

This document introduce how to use Balance Transfer sample application to work with Hyperledger Fabric network on Alibaba Cloud Container Service.


## Prepare the environment

1. Install Node.js v6.9.x - 6.11.x (Note: Node.js v7 is not supported yet)
2. Install jq： https://stedolan.github.io/jq/
3. Use Blockchain Solution of Container Service of Alibaba Cloud to create a blockchain network



## Run the sample application

### 1. Download artifacts from blockchain network on Alibaba Cloud

The Blockchain Solution of Container Service should have already generated artifacts for blockchain application during the deployment phase of blockchain network. The artifacts include certificates, keys, configurations to be used by blockchain application. 

To download these artifacts, use the name and external address of blockchain network as environment variable and execute the shell script to download artifacts.

For example:

```
cd balance-transfer-app
EXTERNAL_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
```

During downloading process, you will be prompted to input password for root account of your ECS node.

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

* Replace all **EXTERNAL_ADDRESS** keywords with the external address of blockchain network.
* Replace the ports with the list of external ports defined in your Blockchain Solution configuration wizard


Then launch terminal 2 and execute the following command: (assuming the channel name is "bankchannel")

```
cd balance-transfer-app
./testAPIs.sh bankchannel
```

The testAPIs.sh will perform the follow operations:

• Enroll users
• Create a new channel 
• Join channel for peers (two organizations, four peers)
• Install chaincode on all peers
• Instantiate chaincode
• Invoke chaincode (i.e. transfer money from b to a)
• Query chaincode (i.e. check the balance of a)
• Query transaction using a TransactionID
• Query general info, like chain info, installed chaincodes, instantiated chaincodes, channel

If you want to learn more details, please refer to the source codes of `testAPIs.sh`

During the running of testAPIs.sh, we have added the function of pausing and waiting for any input from user, so that user can observe and verify the running behavior and result more easily. 

After all tests are done, you will see output messages similar to the following:

```
Total execution time : 41 secs ...
```




