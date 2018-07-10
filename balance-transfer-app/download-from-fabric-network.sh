#!/bin/bash
#####################################################################################
# How to use: 
# For example:
# SSH_ADDRESS=k8s_master_ssh_address FABRIC_NETWORK=your_fabric_network_name SHARED_STORAGE=your_nas_mounting_address ./download-from-fabric-network.sh"
#####################################################################################

# Debug mode
set -x

if [ -z $SHARED_STORAGE ] || [ -z $SSH_ADDRESS ] || [ -z $FABRIC_NETWORK ]; then
    echo "Usage: SSH_ADDRESS=k8s_master_ssh_address FABRIC_NETWORK=your_fabric_network_name SHARED_STORAGE=your_nas_mounting_address ./download-from-fabric-network.sh"
    exit 1
fi

# Automatically generate a dynamic mounting dir for NAS
DIR_NAME=`date "+%Y-%m-%d-%H-%M-%S"`
ssh -l root ${SSH_ADDRESS} "mkdir /data-${DIR_NAME}"
ssh -l root ${SSH_ADDRESS} "mount ${SHARED_STORAGE}:/ /data-${DIR_NAME}"

rm -rf ./artifacts/channel/*

scp -r root@${SSH_ADDRESS}:/data-${DIR_NAME}/fabric/${FABRIC_NETWORK}/sdk/* ./artifacts/
scp -r root@${SSH_ADDRESS}:/data-${DIR_NAME}/fabric/${FABRIC_NETWORK}/config/app/network-config.yaml  ./artifacts/network-config.yaml
scp -r root@${SSH_ADDRESS}:/data-${DIR_NAME}/fabric/${FABRIC_NETWORK}/config/app/config.json  ./config.json

# For data safety, we are just unmounting the data dir, but not deleting the dir yet. 
# You can consider manual cleanup of these unused data dirs
ssh -l root ${SSH_ADDRESS} "umount /data-${DIR_NAME}"

