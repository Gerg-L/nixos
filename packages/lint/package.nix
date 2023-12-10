{
  inputs,
  nixfmt,
  writeShellApplication,
  deadnix,
  statix,
  fd,
}:

writeShellApplication {
  name = "lint";
  runtimeInputs = [
    (nixfmt.overrideAttrs {
      version = "0.6.0-${inputs.nixfmt.shortRev}";

      src = inputs.nixfmt;
    })
    deadnix
    statix
    fd
  ];
  text = ''
    if [ -z "''${1:-""}" ]; then
      fd '.*\.nix' . -x statix fix -- {} \;
      fd '.*\.nix' . -X deadnix -e -- {} \; -X nixfmt {} \;
    else
      statix fix -- "$1"
      deadnix -e "$1"
      nixfmt "$1"
    fi
  '';
}
