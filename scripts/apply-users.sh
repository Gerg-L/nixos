#!/bin/sh
cd /etc/nixos/scripts
nix build /etc/nixos/#homeManagerConfiguration.gerg.activationPackage
/etc/nixos/scripts/result/activate
rm -rf /etc/nixos/scripts/result
