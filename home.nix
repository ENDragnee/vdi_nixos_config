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
  ];

  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your.email@example.com";
  };

  programs.firefox.enable = true;

  # Move user-level environment variables and Qt/GTK theming here
  home.sessionVariables = {
    XCURSOR_THEME = "Dracula-cursor";
    XCURSOR_SIZE = "24";
  };

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "qtct";
  };

  # Replaces the system xrdb setup
  xresources.properties = {
    "Xcursor.theme" = "Dracula-cursor";
    "Xcursor.size" = "24";
  };

  # Allow Home Manager to manage itself
  programs.home-manager.enable = true;
}
