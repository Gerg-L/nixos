#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash jq curl gnused
set -xeu pipefail
old_rev="$(cat flake.lock | jq -r '.nodes.root.inputs.nix as $node | .nodes.[$node].original.ref')"
new_rev="$(curl  "https://api.github.com/repos/nixos/nix/commits/HEAD" | jq -r '.sha')"
sed -i -e "s|$old_rev|$new_rev|g" flake.nix
nix flake lock
