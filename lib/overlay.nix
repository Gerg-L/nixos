{ self, ... }@inputs:
myLib: lib:
let
  systemDependent = {
    appendSystem = system: x: "${x}-${system}";
  };
in
{

  inherit systemDependent;

  __functor =
    self: system:
    let
      systemDependent = builtins.mapAttrs (_: v: v system) self.sysDependantFuncs;
    in
    self
    // {
      inherit systemDependent;
    }
    // systemDependent;

  overlay = import ./overlay.nix inputs;

  wrench = lib.flip lib.pipe;

  needsSystem = lib.flip builtins.elem [
    "apps"
    "checks"
    "defaultPackage"
    "devShell"
    "devShells"
    "formatter"
    "legacyPackages"
    "packages"
  ];

  constructInputs' =
    system:
    myLib.wrench [
      (lib.filterAttrs (_: lib.isType "flake"))
      (lib.mapAttrs (
        _: lib.mapAttrs (name: value: if myLib.needsSystem name then value.${system} else value)
      ))
    ];

  listNixFilesRecursive = myLib.wrench [
    builtins.unsafeDiscardStringContext
    lib.filesystem.listFilesRecursive
    (builtins.filter (x: !lib.hasPrefix "_" (builtins.baseNameOf x) && lib.hasSuffix ".nix" x))
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
        # all arguments defined in the module
        funcArgs = lib.functionArgs imported;
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
          _dir = builtins.dirOf x;
        };

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
                  inputs' = myLib.constructInputs' args.pkgs.stdenv.system inputs;

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

}
// systemDependent
