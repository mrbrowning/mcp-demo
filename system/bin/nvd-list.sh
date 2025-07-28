#!/usr/bin/env bash

set -euo pipefail

UPDATE_TYPE="${1:-updated}"

case "$UPDATE_TYPE" in
    updated* )
        nvd diff /nix/var/nix/profiles/system result | rg '^\[U' | sed -E 's/ +/ /g' | awk 'NF == 8 {print $3, $4, $7} NF == 6 {print $3, $4, $6}' | tr -d ,
        ;;
    added* )
        nvd diff /nix/var/nix/profiles/system result | rg '^\[A' | sed -E 's/ +/ /g' | cut -d ' ' -f 3
        ;;
    removed* )
        nvd diff /nix/var/nix/profiles/system result | rg '^\[R' | sed -E 's/ +/ /g' | cut -d ' ' -f 3
        ;;
esac
