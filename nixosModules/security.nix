{ run0-sudo-shim }:
{
  imports = [ run0-sudo-shim.nixosModules.default ];

  environment.shellAliases = {
    run0 = "run0 --background='' ";
    sudo = "sudo --run0-extra-arg=--background='' ";
    s = "run0";
  };
  services.dbus.implementation = "broker";
  security = {
    sudo.enable = false;
    polkit = {
      enable = true;
      persistentAuthentication = true;
    };
    run0-sudo-shim.enable = true;
  };
  environment.etc."polkit-1/polkitd.conf".text = ''
    [Polkitd]
    ExpirationSeconds=60
  '';
}
