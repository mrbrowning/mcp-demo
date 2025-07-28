#!/usr/bin/env bash

cd /etc/nixos

nixos-rebuild build
nvd diff /nix/var/nix/profiles/system result

rm result