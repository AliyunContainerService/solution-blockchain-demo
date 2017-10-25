# Sample Blockhain Explorer: Hyperledger Explorer

This project is based on the source codes of Hyperledger Explorer. You can refer to the original source codes and documentation in this link: 
https://github.com/hyperledger/blockchain-explorer.

The source codes in this project have been tested with the Blockchain Solution of Alibaba Cloud Container Service. 


## Requirements

Following are the software dependencies required to install and run Hyperledger Explorer 
* Node.js 6.9.x - 6.11.x (Note that v7.x is not yet supported)
* MySQL 5.7 or greater


## Database setup

Run the database setup scripts located under `db/fabricexplorer.sql`

`mysql -u<username> -p < db/fabricexplorer.sql`

## Create blockchain network on Alibaba Cloud using Blockchain Solution of Container Service

Please refer to the documentation of Blockchain Solution of Container Service of Alibaba Cloud. 

## Download artifacts from blockchain network on Alibaba Cloud

The Blockchain Solution of Container Service should have already generated artifacts for blockchain explorer during the deployment phase of blockchain network. The artifacts include certificates, keys, configurations to be used by blockchain explorer. 

To download these artifacts, use the name and external address of blockchain network as environment variable and execute the shell script to download artifacts.

For example:

```
cd blockchain-explorer
EXTERNAL_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
```

During downloading process, you will be prompted to input password for root account of your ECS node.


## Running blockchain-explorer


In a terminal, execute the follow commands:

1. `cd blockchain-explorer`
2. `npm install`  (This needs to be executed only once)
3. `./start.sh`

Then launch a web browser to access below URL:

```
http://localhost:8080
```

To check the logs of blockchain explorer, you can execute below command:

```
tail -f log.log
```

