{
  config,
  pkgs,
  lib,
  ...
}: let
  # Download the Kvantum theme directly from the official Dracula GitHub repo
  dracula-kvantum = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "kvantum";
    rev = "master"; # Pulls the latest version
    # Note: Because this is a Flake, Nix requires a cryptographic hash.
    # We leave it empty here so Nix will fail on the first run, calculate the hash for you,
    # and tell you exactly what to paste here!
    hash = lib.fakeHash;
  };
in {
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

  # 3. Kvantum Theme Installation & Config
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Symlink the downloaded theme into Kvantum's directory
  xdg.configFile."Kvantum/Dracula".source = "${dracula-kvantum}/Dracula";

  # Tell Kvantum to actively use the Dracula theme
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Dracula
  '';

  # 4. Explicitly Enforce Environment Variables
  # This guarantees Qt apps, GTK apps, and Openbox pick up the right settings globally.
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "kvantum";
    GTK_THEME = "Dracula";
    XCURSOR_THEME = "Dracula-cursors";
    XCURSOR_SIZE = "24";
  };
}
