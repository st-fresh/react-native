#!/bin/bash

# Copyright (c) 2015-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.


if [ -z "$1" ]; then
  echo "Missing argument: \$INFOPLIST_FILE"
  exit 0
fi

export INFOPLIST_FILE=$1
export PROTOCOL=$(/usr/libexec/PlistBuddy -c "Print :RCTWebSocketExecutor:protocol" "${INFOPLIST_FILE}")
export HOSTNAME=$(/usr/libexec/PlistBuddy -c "Print :RCTWebSocketExecutor:hostname" "${INFOPLIST_FILE}")
export PORT=$(/usr/libexec/PlistBuddy -c "Print :RCTWebSocketExecutor:port" "${INFOPLIST_FILE}")

THIS_DIR=$(dirname "$0")

if nc -w 5 -z localhost $PORT ; then
  if ! curl -s "${PROTOCOL}//${HOSTNAME}:${PORT}/status" | grep -q "packager-status:running" ; then
    echo "Port ${PORT} already in use, packager is either not running or not running correctly"
    exit 2
  fi
else
  # open w/t --args doesn't work:
  # open $THIS_DIR/packager.sh --args --protocol=${PROTOCOL} --hostname=${HOSTNAME} --port=${PORT} || echo "Can't start packager automatically"
  osascript -e 'tell app "Terminal"
    do script "'$THIS_DIR'/packager.sh --protocol='${PROTOCOL}' --hostname='${HOSTNAME}' --port='${PORT}'"
  end tell' || echo "Can't start packager automatically"
fi