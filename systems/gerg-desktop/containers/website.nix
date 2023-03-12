_: {...}: {
  sops.secrets."website/sql" = {};
  containers."website" = {
    ephemeral = true;
    autoStart = true;
    privateNetwork = true;
    hostBridge = "bridge0";
    localAddress = "192.168.1.11/24";
    localAddress6 = "2605:59c8:252e:500:200:ff:fe00:11/64";
    bindMounts = {
      "/var" = {
        hostPath = "/persist/website/var";
        isReadOnly = false;
      };
      "/etc/ssh" = {
        hostPath = "/persist/website/etc/ssh/";
        isReadOnly = false;
      };
      "/secrets".hostPath = "/run/secrets/website";
    };
    config = {
      pkgs,
      config,
      ...
    }: let
      giteaPort = 3000;
    in {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = [pkgs.neovim];
      networking = {
        defaultGateway = "192.168.1.1";
        nameservers = ["1.1.1.1" "1.0.0.1"];
        firewall = {
          #allowedUDPPorts = [giteaPort 80 443];
          allowedTCPPorts = [giteaPort 80 443 22];
        };
      };
      systemd.services.setmacaddr = {
        script = ''
          /run/current-system/sw/bin/ip link set dev eth0 address 00:00:00:00:00:11
        '';
        wantedBy = ["basic.target"];
        after = ["dhcpcd.service"];
      };
      system.stateVersion = "unstable";
      services = {
        gitea = {
          enable = true;
          appName = "WEEEWOOOO";
          domain = "git.gerg-l.com";
          rootUrl = "https://git.gerg-l.com/";
          httpPort = giteaPort;
          settings = {
            server = {
              LANDING_PAGE = "/explore/repos";
            };
            ui = {
              DEFAULT_THEME = "arc-green";
            };
            service = {
              DISABLE_REGISTRATION = true;
            };
          };
        };
        nginx = {
          enable = true;
          virtualHosts = {
            "git.gerg-l.com" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:${toString giteaPort}";
              };
            };
          };
        };
        openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
      };
      security.acme = {
        acceptTerms = true;
        defaults.email = "gregleyda@proton.me";
      };
    };
  };
}
