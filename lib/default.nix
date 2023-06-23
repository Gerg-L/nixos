inputs @ {
  unstable,
  self,
  ...
}: let
  inherit (unstable) lib;

  importAll = path:
    map
    (module: (import module inputs))
    (
      builtins.filter (lib.hasSuffix ".nix")
      (lib.filesystem.listFilesRecursive path)
    );

  mkModules = path:
    lib.listToAttrs (
      map (
        name: {
          name = lib.removePrefix (toString path + "/") (lib.removeSuffix ".nix" (toString name));
          value = import name inputs;
        }
      )
      (
        builtins.filter (lib.hasSuffix ".nix")
        (lib.filesystem.listFilesRecursive path)
      )
    );
in {
  inherit importAll mkModules;

  withSystem = f:
    lib.fold lib.recursiveUpdate {}
    (map f ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);

  mkSystems = system: names:
    lib.genAttrs names (
      name:
        lib.nixosSystem {
          inherit system;
          modules =
            builtins.attrValues self.nixosModules ++ importAll (self + "/hosts/" + name);
        }
    );
  mkDisko = names:
    lib.genAttrs names (
      name: (import (self + "/hosts/" + name + "/disko.nix") inputs)
    );

  mkPkgs = pkgs: path:
    builtins.listToAttrs (
      map (module: {
        name = lib.removeSuffix ".nix" (builtins.baseNameOf module);
        value = pkgs.callPackage module {};
      })
      (
        builtins.filter (lib.hasSuffix ".nix")
        (lib.filesystem.listFilesRecursive path)
      )
    );
}
