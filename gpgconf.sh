#!/bin/sh

if ! type gpg >/dev/null 2>&1; then
  echo "error: gpg command not found" >&2
  exit 1
fi

gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye