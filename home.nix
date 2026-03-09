{
  config,
  pkgs,
  ...
}: {
  home.stateVersion = "25.05";
  home.username = "vdi";
  home.homeDirectory = "/home/vdi";

  # Enable Home Manager to manage XDG base directories (~/.config, ~/.local, etc)
  xdg.enable = true;

  imports = [
    ./modules/packages.nix
    ./modules/openbox.nix
    ./modules/clipcat.nix
    ./modules/fish.nix
    ./modules/theming.nix
    ./modules/tint2.nix
  ];

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };

  programs.firefox.enable = true;

  # Allow Home Manager to manage itself
  programs.home-manager.enable = true;
}
