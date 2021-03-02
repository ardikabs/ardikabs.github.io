#!/bin/sh

if ! type curl >/dev/null 2>&1; then
  echo "error: curl command not found" >&2
  exit 1
fi

echo "add ssh public key for me@ardikabs.com GPG"
curl -sSfL https://ardikabs.keybase.pub/ssh.pub -o- >> ~/.ssh/authorized_keys