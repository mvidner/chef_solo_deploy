#!/bin/bash
set -eu
PROGRAM_DIR=`dirname $0`
"${PROGRAM_DIR}"/install-chef/default
"${PROGRAM_DIR}"/run-chef-solo/run "$@"
