{
  self,
  unstable,
  ...
}:
let
  myLib = self.lib;
  inherit (unstable) lib;
in
lib.pipe ./. [
  myLib.listNixFilesRecursive
  (map (name: {
    name = lib.pipe name [
      (lib.removeSuffix ".nix")
      (lib.removePrefix "${./.}/")
    ];
    value = myLib.addSchizophreniaToModule name;
  }))
  builtins.listToAttrs
]
