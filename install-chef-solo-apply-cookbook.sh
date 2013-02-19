#!/bin/bash
set -eu
install-chef/default
run-chef-solo/run "$@"
