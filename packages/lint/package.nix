{
  writeShellApplication,
  nixfmt-rfc-style,
  deadnix,
  statix,
  fd,
}:
writeShellApplication {
  name = "lint";
  runtimeInputs = [
    nixfmt-rfc-style
    deadnix
    statix
    fd
  ];
  text = ''
    fd "$@" -t f -e nix -x statix fix -- '{}'
    fd "$@" -t f -e nix -X deadnix -e -- '{}' \; -X nixfmt '{}'
  '';
}
