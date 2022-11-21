#!/usr/bin/env sh

nix-build -E "with import <nixpkgs> {}; callPackage $1 {}"
