#!/bin/bash

#######################################
# Start server for Blockchain Explorer
#######################################
rm -rf /tmp/fabric-client-kvs*

node main.js >log.log 2>&1 &
