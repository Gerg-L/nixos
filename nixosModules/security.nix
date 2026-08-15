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
      settings.Polkitd.ExpirationSeconds = 60;
    };
    run0-sudo-shim.enable = true;
  };
}
