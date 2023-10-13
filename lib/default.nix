inputs@{ unstable, self, ... }:
let
  inherit (unstable) lib;

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
in
{
  inherit importAll mkModules listNixFilesRecursive;

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
        ];
      }
    );
  mkDisko =
    names:
    lib.genAttrs names (name: (import "${self}/hosts/${name}/disko.nix" inputs));

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
