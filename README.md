# solution-blockchain-demo

This is a project for source codes of the sample blockchain applications which are used for testing and demonstration of Blockchain Solution of Alibaba Cloud Container Service.

This project contains sub-projects which were forked from below Hyperledger projects:

* https://github.com/hyperledger/fabric-samples

Please note that we are using a snapshot (not necessarily the latest) of the above source codes, which is then customized and tested with the Blockchain Solution of Alibaba Cloud Container Service. 

## Sub-project: balance-transfer-app

This sub-project contains source codes of a sample balance transfer application, which uses Hyperledger Fabric Node.js SDK to connect to Hyperledger Fabric blockchain network, and performs balance transfer transactions.

For details, please refer to the README of this sub-project:

* English version: [README.md](balance-transfer-app/README.md)
* Chinese version: [README.cn.md](balance-transfer-app/README.cn.md)

## Notes

* Since Hyperledger Fabric 1.1, the Blockchain Solution of Alibaba Cloud Container Service has already integrated Blockchain Explorer during deployment by default. So the previous sub-project `blockchain-explorer` is not included now.

## License

Apache 2.0 license

## Contributors

* Shan Yu (<yushan0624@gmail.com>)

