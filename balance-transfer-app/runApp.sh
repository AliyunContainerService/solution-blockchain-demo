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
		npm install
	fi
	echo
}


cleanEnv

installNodeModules

PORT=4000 node app
