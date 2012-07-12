#!/bin/bash
set -e
# Usage: ./deploy.sh USER@HOST PROGRAM_FILE [DATA_FILES_OR_DIRS...]

USER_N_HOST="${1?}"
shift

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${USER_N_HOST#*@}" 2> /dev/null

case $SHELLOPTS in
    *xtrace*) ENABLE_XTRACE=':'
esac

tar cj "$@" | ssh -o 'StrictHostKeyChecking no' "$USER_N_HOST" '
set -x
set -e
WORKDIR=$(mktemp -d /tmp/deploy-XXXX)
pushd $WORKDIR

tar xvj
chmod +x '"$1"' # end-squote, substitute-$1-in-outer-script, resume-squote
./'"${@/#\//}"' # remove leading / like tar does

popd
rm -rf $WORKDIR'
