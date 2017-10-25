#!/bin/bash
#
# Copyright Alibaba Group. All Rights Reserved.
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#




function cleanEnv() {
	echo

	#Cleanup the material
	rm -rf /tmp/hfc-test-kvs* $HOME/.hfc-key-store/ /tmp/fabric-client-kvs*

}

function installNodeModules() {
	echo
	if [ -d node_modules ]; then
		echo "============== node modules installed already ============="
	else
		echo "============== Installing node modules ============="
		npm install
	fi
	echo
}


cleanEnv

installNodeModules

PORT=4000 node app
