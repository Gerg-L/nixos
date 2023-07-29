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
            (lib.removeSuffix ".nix")
            (lib.removePrefix "${toString path}/")
          ];
          value = import name inputs;
        }
      )
      (listNixFilesRecursive path)
    );
in {
  inherit importAll mkModules listNixFilesRecursive;

  gerg-utils = config: f:
    lib.fold lib.recursiveUpdate {}
    (map (system:
      f {
        inherit system;
        pkgs =
          if config == {}
          then unstable.legacyPackages.${system}
          else
            import unstable {
              inherit system config;
            };
      }) ["x86_64-linux"]);
  #"x86_64-darwin" "aarch64-linux" "aarch64-darwin"

  mkHosts = system: names:
    lib.genAttrs names (
      name:
        lib.nixosSystem {
          inherit system;
          modules =
            builtins.attrValues self.nixosModules
            ++ importAll "${self}/hosts/${name}"
            ++ [
              {
                networking.hostName = name;
              }
            ];
        }
    );
  mkDisko = names:
    lib.genAttrs names (
      name: (import "${self}/hosts/${name}/disko.nix" inputs)
    );

  mkPackages = path: pkgs:
    builtins.listToAttrs (
      map (module: {
        name = lib.removeSuffix ".nix" (builtins.baseNameOf module);
        value = pkgs.callPackage module {};
      })
      (listNixFilesRecursive path)
    );
  _file = ./default.nix;
}
