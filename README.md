# funni ascii graph

```console
nixos on  master   exa --tree
.
├── flake.lock
├── flake.nix
├── installer
│  └── default.nix
├── misc
│  ├── 1-monitor.conf
│  ├── 2-monitor.conf
│  ├── black.theme.css
│  ├── nixos.png
│  ├── recursion.png
│  └── Windows.xml
├── modules
│  ├── boot
│  │  ├── misc.nix
│  │  ├── silent.nix
│  │  └── stage2patch.nix
│  ├── builders.nix
│  ├── DE
│  │  ├── dwm.nix
│  │  ├── gnome.nix
│  │  └── xfce.nix
│  ├── DM
│  │  ├── autoLogin.nix
│  │  ├── lightDM.nix
│  │  └── misc.nix
│  ├── git.nix
│  ├── hardware.nix
│  ├── misc.nix
│  ├── nix.nix
│  ├── packages.nix
│  ├── shell.nix
│  ├── sops.nix
│  ├── theming.nix
│  ├── unfree.nix
│  └── X11.nix
├── pkgs
│  ├── afk-cmds.nix
│  ├── parrot.nix
│  └── t-rex.nix
├── README.md
└── systems
   ├── game-laptop
   │  ├── default.nix
   │  ├── disko.nix
   │  ├── prime.nix
   │  └── secrets.yaml
   ├── gerg-desktop
   │  ├── containers
   │  │  ├── minecraft.nix
   │  │  └── website.nix_
   │  ├── default.nix
   │  ├── disko.nix
   │  ├── erase-your-darlings.nix
   │  ├── parrot.nix
   │  ├── secrets.yaml
   │  ├── spicetify.nix
   │  ├── vfio.nix
   │  └── zfs.nix
   └── moms-laptop
   ├── default.nix
   ├── disko.nix
   ├── printing.nix
   └── secrets.yaml
```


This is my personal nixos configuration
it currently has 3 hosts:

"gerg-desktop" my main computer [specs](https://pcpartpicker.com/list/DVkMk9)
which I run a windows KVM VFIO virtual machine on

"game-laptop" a HP Pavilion Laptop [15-ec2121nr](https://support.hp.com/us-en/document/c07918617#AbT0)
which I've been testing linux game compatability on

"moms-laptop" a TOSHIBA Satellite [L855-S5309](https://fo-stage-03.icecat.biz/us/p/toshiba/pskfuu-008049/satellite-notebooks-l855-s5309-18316794.html)
very old and very slow -basically a bootloader for firefox
