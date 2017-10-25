# Sample Blockhain Explorer: Hyperledger Explorer

本项目提供了一个可用于访问阿里云容器服务区块链网络的示例区块链浏览器。该项目是基于Hyperledger Explorer的源代码进行修改的。你可以访问以下链接以获得Hyperledger Explorer的原始代码和官方文档说明:
https://github.com/hyperledger/

本项目的源代码与阿里云容器服务的区块链解决方案共同进行了测试验证。

## 软件需求

以下是安装Hyperledger Explorer所需要的软件列表：

* Node.js 6.9.x - 6.11.x (注：目前尚不支持 Node.js v7.x)
* MySQL 5.7 或更高版本


## 配置数据库

运行以下位置的数据库配置脚本 `db/fabricexplorer.sql`，命令示例如下：

```
mysql -u<username> -p < db/fabricexplorer.sql
```

## 在阿里云上使用容器服务区块链解决方案创建区块链网络

请参考阿里云容器服务区块链解决方案的文档说明。 

## 从阿里云上的区块链网络下载配置文件（artifacts）

在区块链网络的部署过程中，容器服务区块链解决方案已经自动生成了供区块链浏览器使用的配置文件。这些配置文件包括证书、密钥、区块链网络配置等区块链浏览器运行所需的要素。

用户需要提供区块链网络的名称和外部访问地址，将其作为环境变量，以运行配置文件自动下载的脚本。运行命令示例如下：

```
cd blockchain-explorer
EXTERNAL_ADDRESS=1.2.3.4 FABRIC_NETWORK=network01 ./download-from-fabric-network.sh
```
在下载过程中，用户需要提供对应ECS节点root账户的登录密码以进行文件的远程拷贝。


## 运行区块链浏览器

打开命令终端，顺序执行以下命令：

1. `cd blockchain-explorer`
2. `npm install`  (该命令仅需执行一次)
3. `./start.sh`

然后启动网络浏览器访问以下地址：

```
http://localhost:8080
```

如需查看区块链浏览器的日志输出，可执行以下命令：

```
tail -f log.log
```

