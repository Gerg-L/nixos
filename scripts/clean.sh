#!/bin/sh
nix-collect-garbage -d
nix-store --gc
