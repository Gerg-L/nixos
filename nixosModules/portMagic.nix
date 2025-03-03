{ lib, ... }:
{
  options.local.links = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        {
          config,
          name,
          ...
        }:

        let
          portHash = lib.flip lib.pipe [
            (builtins.hashString "md5")
            (builtins.substring 0 7)
            (hash: (fromTOML "v=0x${hash}").v)
            (lib.flip lib.mod config.reservedPorts.amount)
            (builtins.add config.reservedPorts.start)
          ];
        in

        {
          options = {
            ipv4 = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "The IPv4 address.";
            };
            hostname = lib.mkOption {
              type = lib.types.str;
              description = "The hostname.";
            };

            port = lib.mkOption {
              type = lib.types.int;
              description = "The TCP or UDP port.";
            };
            portStr = lib.mkOption {
              type = lib.types.str;
              description = "The TCP or UDP port, as a string.";
            };
            reservedPorts = {
              amount = lib.mkOption {
                type = lib.types.int;
                default = 10000;
                description = "Amount of ports to reserve at most.";
              };
              start = lib.mkOption {
                type = lib.types.int;
                default = 30000;
                description = "Starting point for reserved ports.";
              };
            };

            protocol = lib.mkOption {
              type = lib.types.str;
              default = "http";
              description = "The protocol in URL scheme name format.";
            };
            path = lib.mkOption {
              type = lib.types.nullOr lib.types.path;
              default = null;
              description = "The resource path.";
            };
            url = lib.mkOption {
              type = lib.types.str;
              description = "The URL.";
            };
            tuple = lib.mkOption {
              type = lib.types.str;
              description = "The hostname:port tuple.";
            };
            extra = lib.mkOption {
              type = lib.types.attrs;
              description = "Arbitrary extra data.";
            };
          };
          config = lib.mkIf true {
            hostname = lib.mkDefault config.ipv4;
            port = lib.mkDefault (portHash "${config.hostname}:${name}");
            portStr = toString config.port;
            tuple = "${config.hostname}:${config.portStr}";
            url = "${config.protocol}://${config.hostname}:${config.portStr}${
              if config.path == null then "" else config.path
            }";
          };
        }
      )

    );
    description = "Port Magic links.";
    default = { };
  };
}
