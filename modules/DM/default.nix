inputs: {
  imports = [
    (import ./autoLogin.nix inputs)
    (import ./lightDM.nix inputs)
    (import ./misc.nix inputs)
  ];
}
