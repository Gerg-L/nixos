{ runCommand, fetchFromGitHub }:

runCommand "kernel-clr-combined.patch"
  {
    src = fetchFromGitHub {
      owner = "clearlinux-pkgs";
      repo = "linux";
      rev = "65f5cc7a18b6eb108e2b458c5c9d244e2aa8b587";
      hash = "sha256-X8H4j7GpMKVdrwSQxbzUVt7m5mzP/53Nx67YG914Zv0=";
    };
  }
  ''
    cd "$src"
    grep -o '^%patch[0-9]*' linux.spec \
      | grep -o '[0-9]*' \
      | xargs -I '{}' grep '^Patch{}:' linux.spec \
      | cut -d" " -f2- | xargs cat >> $out
  ''
