_: {lib, ...}: {
  systemd.tmpfiles.rules = [
    "d /mnt - - - - -"
    "L+ /etc/ssh/ssh_host_ed25519_key  - - - - /persist/ssh/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub  - - - - /persist/ssh/ssh_host_ed25519_key.pub"
    "L+ /etc/nixos - - - - /persist/nixos"
  ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/root@empty
    zfs rollback -r rpool/var@empty
  '';
  #make sure the sopskey is found
  sops.age.sshKeyPaths = lib.mkForce ["/persist/ssh/ssh_host_ed25519_key"];
  fileSystems."/persist".neededForBoot = true;
  environment.etc = {
    "machine-id".text = "b6431c2851094770b614a9cfa78fb6ea";
  };
}
