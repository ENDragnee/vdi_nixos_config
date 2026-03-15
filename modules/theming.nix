{
  config,
  pkgs,
  lib,
  ...
}: let
  # Fetching the "Yet-another-dracula" Kvantum theme from GitHub
  dracula-kvantum-src = pkgs.fetchFromGitHub {
    owner = "trancong12102";
    repo = "Yet-another-dracula";
    rev = "master";
    hash = "sha256-/s04K9VCPetJPIey9EJr7rBxcR/dIsUBlpKPJsoxioQ=";
  };
  # Fetch the official Dracula Openbox theme
  dracula-openbox-src = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "openbox";
    rev = "master";
    hash = "sha256-oxPGcR3+lzJaDvtg/Deuvw5+DKKZo9LD2x0i6cTZu8M="; # Change to lib.fakeHash on first run if needed
  };
in {
  # We no longer need dracula-qt5-theme from Nixpkgs since we are fetching it manually
  home.packages = with pkgs; [
    # Keep other theme-related packages
    dracula-theme
    dracula-icon-theme
  ];

  # 1. Cursor Configuration
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # 2. GTK Configuration
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # 3. Kvantum Theme Config
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # --- THE FIX: Point to the 'Dracula' folder inside the GitHub repo ---
  xdg.configFile."Kvantum/Yet-another-dracula".source = "${dracula-kvantum-src}/Yet-another-dracula/Kvantum/Yet-another-dracula";

  # Tell Kvantum to actively use the Dracula theme
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Yet-another-dracula
  '';

  # 4. Explicitly Enforce Environment Variables
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "kvantum";
    GTK_THEME = "Dracula";
    XCURSOR_THEME = "Dracula-cursors";
    XCURSOR_SIZE = "24";
  };

  xdg.configFile."wallpapers/lock.jpg".source = ./assets/wallpapers/lock.jpg;
  xdg.dataFile."themes/Dracula-withoutBorder".source = dracula-openbox-src;
}
