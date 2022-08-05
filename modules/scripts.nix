{ pkgs, ... }:

let
  update-system = pkgs.writeScriptBin "update-system" ''
    #!${pkgs.stdenv.shell}
     nix flake update /etc/nixos/#
  ''; 

  clean-store = pkgs.writeScriptBin "clean-store" ''
    #!${pkgs.stdenv.shell}
     sudo nix-collect-garbage -d
     sudo nix-store --optimise
     sudo -u gerg nix-collect-garbage -d

  ''; 

  apply-users = pkgs.writeScriptBin "apply-users" ''
    #!${pkgs.stdenv.shell}
     nix build /etc/nixos/#homeManagerConfiguration.gerg.activationPackage
     ./result/activate
     rm -rf ./result
  ''; 

  apply-system = pkgs.writeScriptBin "apply-system" ''
    #!${pkgs.stdenv.shell}
     nixos-rebuild switch --flake /etc/nixos/#
  ''; 
in {
  environment.systemPackages = [ update-system clean-store apply-users apply-system ];
}
