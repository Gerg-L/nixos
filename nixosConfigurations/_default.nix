{
  self,
  unstable,
  disko,
  ...
}:
let
  myLib = self.lib;
  inherit (unstable) lib;
in
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (_: v: v == "directory"))
  (builtins.mapAttrs (
    x: _:
    lib.evalModules {
      specialArgs.modulesPath = "${unstable}/nixos/modules";
      modules = builtins.concatLists [
        (builtins.attrValues self.nixosModules)
        (map myLib.addSchizophreniaToModule (myLib.listNixFilesRecursive (./. + "/${x}")))
        (import "${unstable}/nixos/modules/module-list.nix")
        (lib.optionals (self.diskoConfigurations ? "disko-${x}") [
          self.diskoConfigurations."disko-${x}"
          disko.nixosModules.default
        ])
      ];
    }
  ))
]
