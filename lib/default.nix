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
    (builtins.filter (x: !lib.hasPrefix "_" (builtins.baseNameOf x) && lib.hasSuffix ".nix" x))
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
        value = addSchizophreniaToModule name;
      }))
      builtins.listToAttrs
    ];

  addSchizophreniaToModule =
    x:
    let
      # the imported module
      imported = import x;
    in
    /*
      If the module isn't a function then
      it doesn't need arguments and error
      message locations will function correctly
    */
    if !lib.isFunction imported then
      x
    else
      let
        /*
          The names of all arguments which will be
          available to be inserted into the module arguments
        */
        argNames = builtins.attrNames inputs ++ [
          "inputs"
          "inputs'"
          "self'"
          "_dir"
        ];

        /*
          arguments to be passed minus
          per system attributes
          for example flake-parts-esque inputs'
        */
        argsPre = {
          inherit inputs self;
          /*
            _dir is the "self" derived
            path to the directory containing the module
          */
          _dir =
            let
              dir = builtins.dirOf x;
            in
            # Probably don't need this error check
            if (dir == builtins.storeDir) then null else dir;
        };

        # all arguments defined in the module
        funcArgs = lib.functionArgs imported;

        /*
          arguments which will be inserted
          set to the before per-system values
        */
        providedArgs = lib.pipe funcArgs [
          (lib.filterAttrs (n: _: builtins.elem n argNames))
          (lib.mapAttrs (n: _: argsPre.${n} or { }))
        ];

        /*
          arguments which the module system
          not provided here. either to be
          provided by the module system or invalid
        */
        neededArgs = lib.filterAttrs (n: _: !builtins.elem n argNames) funcArgs;
      in
      {
        __functionArgs = neededArgs // {
          /*
            always require pkgs to be passed
            to derive system from pkgs.stdenv.system
          */
          pkgs = false;
        };

        __functor =
          /*
            args is specialArgs + _module.args which are needed
            and always pkgs
          */
          _: args:
          imported (
            /*
              take module system provided arguments
              filter them so only the required ones are passed
            */
            (lib.filterAttrs (n: _: neededArgs ? ${n}) args)
            # add needed arguments
            // (
              providedArgs
              # add system dependent arguments
              // (
                let
                  inputs' = constructInputs' args.pkgs.stdenv.system inputs;

                  actuallyAllArgs = inputs' // {
                    inherit inputs';
                    self' = inputs'.self;
                    inherit (inputs) self;
                  };
                in
                lib.filterAttrs (n: _: providedArgs ? ${n}) actuallyAllArgs
              )
            )
          )
          # add _file to the final module attribute set
          // {
            _file = x;
          };

      };

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

        modules = builtins.concatLists [
          (builtins.attrValues self.nixosModules)
          (map addSchizophreniaToModule (listNixFilesRecursive "${self}/hosts/${hostName}"))
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
