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

  wrench = lib.flip lib.pipe;

  needsSystem = lib.flip builtins.elem [
    "defaultPackage"
    "devShell"
    "devShells"
    "formatter"
    "legacyPackages"
    "packages"
  ];

  constructInputs' =
    system:
    wrench [
      (lib.filterAttrs (_: lib.isType "flake"))
      (lib.mapAttrs (_: lib.mapAttrs (name: value: if needsSystem name then value.${system} else value)))
    ];

  listNixFilesRecursive = wrench [
    builtins.unsafeDiscardStringContext
    lib.filesystem.listFilesRecursive
    (builtins.filter (lib.hasSuffix ".nix"))
  ];

  mkModules =
    path:
    lib.pipe path [
      listNixFilesRecursive
      (map (name: {
        name = lib.pipe name [
          (lib.removeSuffix ".nix")
          (lib.removePrefix "${path}/")
        ];
        value = name;
      }))
      builtins.listToAttrs
    ];

  gerg-utils =
    pkgsf: outputs:
    lib.pipe
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      [
        (map (
          system:
          builtins.mapAttrs (
            name: value: if needsSystem name then { ${system} = value (pkgsf system); } else value
          ) outputs
        ))
        (lib.foldAttrs lib.mergeAttrs { })
      ];

  mkHosts =
    system:
    lib.flip lib.genAttrs (
      hostName:
      # Whats lib.nixosSystem? never heard of her
      lib.evalModules {
        specialArgs.modulesPath = "${unstable}/nixos/modules";

        modules =
          let
            importWithArgs = map (
              x:
              let
                allArgs = (constructInputs' system inputs) // {
                  inherit inputs;
                  _dir =
                    let
                      dir = builtins.dirOf x;
                    in
                    if (dir != builtins.storeDir) then dir else null;
                  _file = x;
                };
                imported = import x;
              in
              lib.pipe imported [
                lib.functionArgs
                builtins.attrNames
                (map (
                  x:
                  if allArgs ? ${x} then
                    {
                      name = x;
                      value = allArgs.${x};
                    }
                  else
                    null
                ))
                (builtins.filter builtins.isAttrs)
                builtins.listToAttrs
                imported
              ]
            );
          in
          builtins.concatLists [
            (importWithArgs (builtins.attrValues self.nixosModules))
            (importWithArgs (listNixFilesRecursive "${self}/hosts/${hostName}"))
            (import "${unstable}/nixos/modules/module-list.nix")
            (lib.singleton {
              networking = {
                inherit hostName;
              };
              nixpkgs.hostPlatform = system;
            })
            (lib.optionals (self.diskoConfigurations ? "disko-${hostName}") [
              self.diskoConfigurations."disko-${hostName}"
              disko.nixosModules.default
            ])
          ];
      }
    );
  mkDisko = wrench [
    (map (name: {
      name = "disko-${name}";
      value.disko.devices = import "${self}/disko/${name}.nix" lib;
    }))
    builtins.listToAttrs
  ];

  /*
    /<name> -> packages named by directory
    /<name>/call.nix ->  callPackage override imported via import <file> pkgs
    call.nix example
      pkgs: {
        inherit (pkgs.python3Packages) callPackage;
        args = {};
     }

    /<name>/package.nix -> the package itself
  */
  mkPackages =
    path: pkgs:
    lib.pipe path [
      builtins.readDir
      (lib.filterAttrs (_: v: v == "directory"))
      (lib.mapAttrs (
        n: _:
        let
          callPackage = lib.callPackageWith (
            pkgs
            // {
              inputs = constructInputs' pkgs.stdenv.hostPlatform.system inputs;
              # maybe add self?
              # inherit self;
              # npins sources if i need them
              # sources = import ./npins;
            }
          );
        in

        if builtins.pathExists "${path}/${n}/call.nix" then
          let
            x = import "${path}/${n}/call.nix" pkgs;
          in
          x.callPackage "${path}/${n}/package.nix" x.args
        else
          callPackage "${path}/${n}/package.nix" { }

      ))
    ];
}
