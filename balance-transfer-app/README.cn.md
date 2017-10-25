# Sample Blockchain Application: Balance Transfer

本示例程序基于Hyperledger项目下的fabric-samples的部分源代码(balance transfer)，如需参考原始代码和官方文档，可访问：https://github.com/hyperledger/fabric-samples/tree/release/balance-transfer

Balance Transfer是一个基于Hyperledger Fabric SDK for Node.js的、演示简单的转账交易场景的示例程序。

本文档介绍了基于阿里云容器服务的Hyperledger Fabric网络的Balance Transfer示例程序的具体使用方法。


## 环境准备

1. 安装Node.js v6.9.x - 6.11.x (注：目前尚不支持Node.js v7)
2. 安装jq： https://stedolan.github.io/jq/
3. 使用阿里云容器服务区块链解决方案完成创建Hyperledger Fabric区块链网络



## 运行示例程序

### 1. 从阿里云上的区块链网络下载配置文件（artifacts）

在区块链网络的部署过程中，容器服务区块链解决方案已经自动生成了供区块链应用程序使用的配置文件。这些配置文件包括证书、密钥、区块链网络配置等区块链应用程序运行所需的要素。

用户需要提供区块链网络的名称和外部访问地址，将其作为环境变量，以运行配置文件自动下载的脚本。运行命令示例如下：

```
cd balance-transfer-app
EXTERNAL_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
```
在下载过程中，用户需要提供对应ECS节点root账户的登录密码以进行文件的远程拷贝。

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

* 将所有 **EXTERNAL_ADDRESS** 关键字替换为区块链网络的外部访问地址
* 将相关端口替换为在容器服务区块链解决方案配置向导中指定的外部端口

然后，打开命令窗口2，运行以下命令：(假设区块链通道名称为bankchannel)

```
cd balance-transfer-app
./testAPIs.sh bankchannel
```

该命令会自动完成以下操作：

• Enroll users
• Create a new channel 
• Join channel for peers (two organizations, four peers)
• Install chaincode on all peers
• Instantiate (实例化) chaincode
• Invoke chaincode (i.e. transfer money from b to a)
• Query chaincode (i.e. check the balance of a)
• Query transaction using a TransactionID
• Query general info, like chain info, installed chaincodes, instantiated chaincodes, channel

如需了解进一步细节，可查看```testAPIs.sh```文件内容

运行过程中，为便于观察具体步骤和输入输出信息，我们加入了等待用户按任意键继续的功能，需要用户手工输入任意键继续。

所有测试完成后，你将看到类似下面的信息：  

```
Total execution time : 41 secs ...
```




