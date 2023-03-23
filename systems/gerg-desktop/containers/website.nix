_: {...}: {
  sops.secrets = {
    "website/sql_gitea" = {
      mode = "0444";
    };
    "website/sql_nextcloud" = {
      mode = "0444";
    };
    "website/nextcloud" = {
      mode = "0444";
    };

    "website/ssl_key" = {
      mode = "0444";
    };

    "website/ssl_cert" = {
      mode = "0444";
    };
  };
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
          appName = "Powered by NixOS";
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
          database = {
            type = "postgres";
            passwordFile = "/secrets/sql_gitea";
          };
        };
        nextcloud = {
          enable = true;
          package = pkgs.nextcloud25;
          hostName = "next.gerg-l.com";
          autoUpdateApps.enable = true;
          enableBrokenCiphersForSSE = false;
          config = {
            dbtype = "pgsql";
            dbhost = "/run/postgresql";
            dbpassFile = "/secrets/sql_nextcloud";
            adminpassFile = "/secrets/nextcloud";
            adminuser = "admin-root";
            defaultPhoneRegion = "IL";
          };
        };
        postgresql = {
          enable = true;
          package = pkgs.postgresql_13;
          ensureDatabases = [config.services.nextcloud.config.dbname];
          ensureUsers = [
            {
              name = config.services.nextcloud.config.dbuser;
              ensurePermissions."DATABASE ${config.services.nextcloud.config.dbname}" = "ALL PRIVILEGES";
            }
          ];
          authentication = ''
            local gitea all ident map=gitea-users
          '';
          identMap = ''
            gitea-users gitea gitea
          '';
        };
        nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          virtualHosts = let
            template = {
              forceSSL = true;
              sslCertificate = "/secrets/ssl_cert";
              sslCertificateKey = "/secrets/ssl_key";
            };
          in {
            "git.gerg-l.com" =
              template
              // {
                locations."/" = {
                  proxyPass = "http://localhost:${toString giteaPort}";
                };
              };
            "next.gerg-l.com" = template;
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
      systemd.services."nextcloud-setup" = {
        requires = ["postgresql.service"];
        after = ["postgresql.service"];
      };
    };
  };
}