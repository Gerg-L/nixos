{inputs, nixfmt}:
(nixfmt.overrideAttrs {
  version = "0.6.0-${inputs.nixfmt.shortRev}";

  src = inputs.nixfmt;
})
