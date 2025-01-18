inputs:
let
  inherit (inputs.unstable) lib;
in
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n && n != "_default.nix"))
  builtins.attrNames
  (map (x: {
    name = lib.pipe x [
      (lib.removeSuffix (toString ./.))
      (lib.removeSuffix ".nix")
      (x: "disko-${x}")
    ];
    value.disko.devices = import "${./.}/${x}" lib;
  }))
  builtins.listToAttrs
]
