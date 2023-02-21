inputs: {
  imports = [
    (import ./lightDM.nix inputs)
    (import ./autoLogin.nix inputs)
  ];
}
