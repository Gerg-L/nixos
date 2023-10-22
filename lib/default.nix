inputs@{
  unstable,
  self,
  disko,
  ...
}:
let
  inherit (unstable) lib;
in
# Only good use case for rec
rec {

  listNixFilesRecursive =
    path:
    builtins.filter (lib.hasSuffix "nix") (lib.filesystem.listFilesRecursive path);

  importAll =
    path: map (module: (import module inputs)) (listNixFilesRecursive path);

  mkModules =
    path:
    lib.listToAttrs (
      map
        (name: {
          name = lib.pipe name [
            toString
            (lib.removeSuffix ".nix")
            (lib.removePrefix "${toString path}/")
          ];
          value = import name inputs;
        })
        (listNixFilesRecursive path)
    );

  gerg-utils =
    config: f:
    lib.foldr lib.recursiveUpdate { } (
      map
        (
          system:
          f {
            inherit system;
            pkgs =
              if config == { } then
                unstable.legacyPackages.${system}
              else
                import unstable { inherit system config; };
          }
        )
        [ "x86_64-linux" ]
    );
  #"x86_64-darwin" "aarch64-linux" "aarch64-darwin"

  mkHosts =
    system: names:
    lib.genAttrs names (
      name:
      # Whats lib.nixosSystem? never heard of her
      lib.evalModules {
        specialArgs.modulesPath = "${unstable}/nixos/modules";

        modules = builtins.concatLists [
          (builtins.attrValues self.nixosModules)
          (importAll "${self}/hosts/${name}")
          (import "${unstable}/nixos/modules/module-list.nix")
          (lib.singleton {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          })
          (lib.optionals (self.diskoConfigurations ? "disko-${name}") [
            self.diskoConfigurations."disko-${name}"
            disko.nixosModules.default
          ])
        ];
      }
    );
  mkDisko =
    names:
    lib.listToAttrs (
      map
        (name: {
          name = "disko-${name}";
          value.disko.devices = import "${self}/disko/${name}.nix" lib;
        })
        names
    );

  mkPackages =
    path: pkgs:
    lib.pipe path [
      listNixFilesRecursive
      (map (
        x: {
          name = lib.removeSuffix ".nix" (builtins.baseNameOf x);
          value = pkgs.callPackage x { };
        }
      ))
      builtins.listToAttrs
    ];
  _file = ./default.nix;
}
