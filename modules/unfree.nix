{
  config,
  lib,
  ...
}: let
  allowed = config.nixpkgs.allowedUnfree;
in {
  options.nixpkgs = {
    allowedUnfree = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [];
      description = ''
        Allows for  unfree packages by their name.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (allowed != []) {nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed;})
  ];
}
