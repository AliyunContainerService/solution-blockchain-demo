#!/bin/bash
#
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#


function cleanEnv() {
	echo

	#Cleanup the stores
	rm -rf ./fabric-client-kv-org*
}

function installNodeModules() {
	echo
	if [ -d node_modules ]; then
		echo "============== node modules installed already ============="
	else
		echo "============== Installing node modules ============="
		if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ]; then
			npm install --registry=https://registry.npm.taobao.org --unsafe-perm
		else
			npm install --registry=https://registry.npm.taobao.org
		fi
	fi
	echo
}


cleanEnv

installNodeModules

PORT=4000 node app
