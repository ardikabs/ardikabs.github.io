#!/bin/bash

if ! type curl >/dev/null 2>&1; then
  echo "error: curl command not found" >&2
  exit 1
elif ! type gpg >/dev/null 2>&1; then
  echo "error: gpg command not found" >&2
  exit 1
fi

# shellcheck disable=SC1090,SC2039
source <(curl -sfL https://site.ardikabs.com/version.sh)

gpgver=$(gpg --version | grep gpg | awk '{ print $3}')

if [ "$(version "$gpgver")" -lt "$(version 2.1.0)" ]; then
  echo "error: gpg version is outdated, need gpg version 2.1.0+" >&2
  exit 1
fi

gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye