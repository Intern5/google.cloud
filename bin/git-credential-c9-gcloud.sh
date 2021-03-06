#!/bin/bash --login

# Copyright (c) 2016 Cloud9 IDE, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

readonly ENOAUTH=100
readonly ENOPROJECT=101

##
# Check that `gcloud` has a credentialed account and is ready to execute other
# commands.
#
# Returns: `$ENOAUTH` if not authenticated,
#          `$ENOPROJECT` if no project configured,
#          `0` otherwise
##
_gcloud_check() {
    local CONFIG="$(gcloud config list)"

    if [[ "$(echo "$CONFIG" | grep 'account = ')" == "" ]]; then
        return $ENOAUTH
    fi

    if [[ "$(echo "$CONFIG" | grep 'project = ')" == "" ]]; then
        return $ENOPROJECT
    fi

    return 0
}

while ! _gcloud_check; do
    WAITED=1
    echo "[git-credential-c9-gcloud] waiting for credentials" >&2
    sleep 1
done

if [[ $WAITED ]]; then
    echo "[git-credential-c9-gcloud] running git..." >&2
fi

git-credential-gcloud.sh "$@"
