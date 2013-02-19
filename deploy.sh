#!/bin/bash
# Usage: ./deploy.sh USER@HOST 'files_or dirs...' 'command to run'
set -e

USER_N_HOST="${1?}"
QUOTED_FILES="$2"
QUOTED_COMMAND="$3"

# expand the quoted var
eval set -- $QUOTED_FILES

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${USER_N_HOST#*@}" 2> /dev/null

# FIXME dead code to pass -x via ssh
case $SHELLOPTS in
    *xtrace*) ENABLE_XTRACE=':'
esac

tar cj "$@" | ssh -o 'StrictHostKeyChecking no' "$USER_N_HOST" '
set -x
set -e
WORKDIR=$(mktemp -d /tmp/deploy-XXXX)
pushd $WORKDIR

tar xvj
'$QUOTED_COMMAND' # end-squote, substitute-$-in-outer-script, resume-squote

popd
rm -rf $WORKDIR'
