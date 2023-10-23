{
  inputs = {
    #channels
    master.url = "github:NixOS/nixpkgs";
    unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    stable.url = "github:NixOS/nixpkgs?ref=nixos-23.05";

    nix = {
      url = "github:NixOS/nix?ref=c29b8ba142a0650d1182ca838ddc1b2d273dcd2a";
      inputs.nixpkgs.follows = "stable";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "unstable";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "unstable";
    };
    nixfmt = {
      url = "github:piegamesde/nixfmt?ref=rfc101-style";
      inputs.nixpkgs.follows = "unstable";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "unstable";
    };
    #my own packages
    suckless = {
      url = "github:Gerg-L/suckless";
      inputs.nixpkgs.follows = "unstable";
    };
    nvim-flake = {
      url = "github:Gerg-L/nvim-flake";
      inputs.nixpkgs.follows = "unstable";
    };
    fetch-rs = {
      url = "github:Gerg-L/fetch-rs";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = i: import ./outputs.nix i;
}
