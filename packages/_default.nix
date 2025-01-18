/*
    /<name> -> packages named by directory
    /<name>/call.nix ->  callPackage override imported via import <file> pkgs
    call.nix example
      {python3Packages}: {
        inherit (python3Packages) callPackage;
        args = {};
     }

    /<name>/package.nix -> the package itself
    /<name>/wrapper.nix:
    a optional wrapper for the package
    which is callPackage'd with the original package
    as an argument named <name>-unwrapped
*/
{ inputs', ... }:
let
  inherit (inputs'.unstable) lib;
  pkgs = inputs'.unstable.legacyPackages;
in
lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (_: v: v == "directory"))
  builtins.attrNames
  (map (
    n:
    let
      p = ./. + "/${n}";

      callPackage =
        file: args:
        let
          defaultArgs =
            pkgs
            // pkgs.xorg
            // {
              inherit inputs';
              self' = inputs'.self;
              # npins sources if i ever use them
              # sources = lib.mapAttrs (_: pkgs.npins.mkSource) (lib.importJSON "${self}/packages/sources.json").pins;
            };
          _callPackage = lib.callPackageWith defaultArgs;
          fullPath = p + "/${file}.nix";
          callPath = p + /call.nix;
        in
        assert lib.assertMsg (builtins.pathExists fullPath)
          "File attempting to be callPackage'd '${fullPath}' does not exist";

        if builtins.pathExists callPath then
          let
            x = _callPackage callPath { };
          in
          x.callPackage or _callPackage fullPath (x.args or defaultArgs // args)

        else
          _callPackage fullPath args;
    in

    if builtins.pathExists (p + /wrapper.nix) then
      # My distaste for rec grows ever stronger
      let
        set."${n}-unwrapped" = callPackage "package" { };
      in
      { ${n} = callPackage "wrapper" set; } // set
    else
      { ${n} = callPackage "package" { }; }

  ))
  lib.mergeAttrsList
]
