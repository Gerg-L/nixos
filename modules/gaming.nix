{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      heroic
      legendary-gl
      prismlauncher
    ]
    ++ builtins.attrValues (inputs.nix-gaming.lib.legendaryBuilder
      {
        inherit (pkgs) system;

        games = {
          rocket-league = {
            desktopName = "Rocket League";

            tricks = ["dxvk" "win10"];

            icon = builtins.fetchurl {
              url = "https://user-images.githubusercontent.com/36706276/203341314-eaaa0659-9b79-4f40-8b4a-9bc1f2b17e45.png";
              name = "rocket-league.png";
              sha256 = "0a9ayr3vwsmljy7dpf8wgichsbj4i4wrmd8awv2hffab82fz4ykb";
            };

            discordIntegration = false;
            gamemodeIntegration = false;

            preCommands = ''
              echo "the game will start!"
            '';

            postCommands = ''
              echo "the game has stopped!"
            '';
          };
        };

        opts = {
          wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
        };
      });
}
