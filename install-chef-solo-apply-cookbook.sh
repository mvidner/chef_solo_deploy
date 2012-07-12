#!/bin/bash
set -e
COOKBOOK=$1
install-chef/default
run-chef-solo/run "$COOKBOOK"
