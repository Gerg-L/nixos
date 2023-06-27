inputs @ {
  unstable,
  self,
  ...
}: let
  inherit (unstable) lib;

  listNixFilesRecursive = path:
    builtins.filter (lib.hasSuffix "nix")
    (lib.filesystem.listFilesRecursive path);

  importAll = path:
    map
    (module: (import module inputs))
    (listNixFilesRecursive path);

  mkModules = path:
    lib.listToAttrs (
      map (
        name: {
          name = lib.pipe name [
            toString
            (lib.removePrefix "${path}/")
            (lib.removeSuffix ".nix")
          ];
          value = import name inputs;
        }
      )
      (listNixFilesRecursive path)
    );
in {
  inherit importAll mkModules listNixFilesRecursive;

  withSystem = f:
    lib.fold lib.recursiveUpdate {}
    (map f ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);

  mkSystems = system: names:
    lib.genAttrs names (
      name:
        lib.nixosSystem {
          inherit system;
          modules =
            builtins.attrValues self.nixosModules
            ++ importAll "${self}/hosts/${name}";
        }
    );
  mkDisko = names:
    lib.genAttrs names (
      name: (import "${self}/hosts/${name}/disko.nix" inputs)
    );

  mkPkgs = pkgs: path:
    builtins.listToAttrs (
      map (module: {
        name = lib.removeSuffix ".nix" (builtins.baseNameOf module);
        value = pkgs.callPackage module {};
      })
      (listNixFilesRecursive path)
    );
}
