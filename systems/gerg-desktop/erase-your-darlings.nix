_: {lib, ...}: {
  systemd.tmpfiles.rules = [
    "d /mnt - - - - -"
    "L+ /etc/ssh/ssh_host_ed25519_key  - - - - /persist/ssh/ssh_host_ed25519_key"
    "L+ /etc/ssh/ssh_host_ed25519_key.pub  - - - - /persist/ssh/ssh_host_ed25519_key.pub"
    "L+ /etc/nixos - - - - /persist/nixos"
  ];
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs snapshot destroy rpool/root@prev
    zfs snapshot destroy rpool/var@prev

    zfs snapshot create rpool/root@prev
    zfs snapshot create rpool/var@prev

    zfs rollback -r rpool/root@empty
    zfs rollback -r rpool/var@empty
  '';
}
