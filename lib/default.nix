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

  needsSystem =
    output:
    builtins.elem output [
      "defaultPackage"
      "devShell"
      "devShells"
      "formatter"
      "legacyPackages"
      "packages"
    ];

  constructInputs' =
    system: inputs:
    lib.pipe inputs [
      (lib.filterAttrs (_: lib.isType "flake"))
      (lib.mapAttrs (
        _:
        lib.mapAttrs (name: value: if needsSystem name then value.${system} else value)
      ))
    ];

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
          value = name;
        })
        (listNixFilesRecursive path)
    );

  gerg-utils =
    config: outputs:
    lib.foldAttrs lib.mergeAttrs { } (
      map
        (
          system:
          let
            pkgs =
              if config == { } then
                unstable.legacyPackages.${system}
              else
                import unstable { inherit system config; };
          in
          lib.mapAttrs
            (name: value: if needsSystem name then { ${system} = value pkgs; } else value)
            outputs
        )
        [ "x86_64-linux" ]
    );

  mkHosts =
    system: names:
    lib.genAttrs names (
      name:
      # Whats lib.nixosSystem? never heard of her
      lib.evalModules {
        specialArgs.modulesPath = "${unstable}/nixos/modules";

        modules =
          let
            importWithInputs' = map (x: import x (constructInputs' system inputs));
          in
          builtins.concatLists [
            (importWithInputs' (builtins.attrValues self.nixosModules))
            (importWithInputs' (listNixFilesRecursive "${self}/hosts/${name}"))
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
