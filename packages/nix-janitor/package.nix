{ inputs', fetchFromGitHub }:
inputs'.master.legacyPackages.nix-janitor.overrideAttrs {
  src = fetchFromGitHub {
    owner = "NobbZ";
    repo = "nix-janitor";
    rev = "d49fd7486d5597d2e854154bf643e7f86c5f1f6c";
    hash = "sha256-KRXz2qUDWmyglXk56jL0twOQ3pWdpacddyVn95W7wl0=";
  };
}
