# Sample Blockchain Application: Balance Transfer

本示例程序基于Hyperledger项目下的fabric-samples的部分源代码(balance transfer)，如需参考原始代码和官方文档，可访问：https://github.com/hyperledger/fabric-samples/tree/release/balance-transfer

Balance Transfer是一个基于Hyperledger Fabric SDK for Node.js的、演示简单的转账交易场景的示例程序。

本文档介绍了基于阿里云容器服务的Hyperledger Fabric v1.1网络的Balance Transfer示例程序的具体使用方法。


## 环境准备

1. 安装Node.js v8.4.0 或更高版本
2. 安装jq： https://stedolan.github.io/jq/
3. (仅适用CentOS或RedHat Linux)安装g++, 命令示例: `sudo yum install -y gcc-c++`
4. 使用阿里云容器服务区块链解决方案完成创建Hyperledger Fabric区块链网络（无需完成CLI测试)。参考文档：https://help.aliyun.com/document_detail/64311.html



## 运行示例程序

### 1. 从阿里云上的区块链网络下载配置文件（artifacts）

在区块链网络的部署过程中，容器服务区块链解决方案已经自动生成了供区块链应用程序使用的配置文件。这些配置文件包括证书、密钥、区块链网络配置等区块链应用程序运行所需的要素。

用户需要提供区块链网络的名称和可用于SSH连接下载的公网地址，将其作为环境变量，以运行配置文件自动下载的脚本。运行命令示例如下：

```
cd balance-transfer-app
SSH_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
```
在下载过程中，用户需要提供对应ECS节点root账户的登录密码以进行文件的远程拷贝。

(Optional) 检查`artifacts/org1.yaml`和`artifacts/org2.yaml`看是否需要更新organization名称

### 2. 启动Node服务器

打开命令窗口1，运行以下命令：

```
cd balance-transfer-app
./runApp.sh
```

此命令将清理任何已有的docker容器和chaincode镜像，执行“npm install”命令安装node模块，启动node服务器。如需了解进一步细节，可查看runApp.sh文件内容。

当server启动成功后可看到类似如下信息：

```
[2017-08-10 14:15:31.036] [INFO] SampleWebApp - ****************** SERVER STARTED ************************
[2017-08-10 14:15:31.036] [INFO] SampleWebApp - **************  http://localhost:4000  ******************
```



#### 3. 运行所有测试

首先，需要用户按如下方式修改balance-transfer-app目录下的testAPIs.sh：

* 将所有 **network01-peer1** 模式的service名称替换成实际的区块链service名称，以artifacts目录中从区块链网络下载的`network-config.yaml`文件内容为准
* 将通道名称 **bankchannel** 替换成实际的区块链channel名称，以artifacts目录中从区块链网络下载的`network-config.yaml`文件内容为准

然后，打开命令窗口2，运行以下命令：

```
cd balance-transfer-app
./testAPIs.sh 
```

该命令会自动完成以下操作：

- Enroll users
- Create a new channel 
- Join channel for peers (two organizations, four peers)
- Install chaincode on all peers
- Instantiate (实例化) chaincode
- Invoke chaincode (i.e. transfer money from b to a)
- Query chaincode (i.e. check the balance of a)
- Query transaction using a TransactionID
- Query general info, like chain info, installed chaincodes, instantiated chaincodes, channel

如需了解进一步细节，可查看```testAPIs.sh```文件内容

所有测试完成后，你将看到类似下面的信息：  

```
Total execution time : 25 secs ...
```




