{
  config,
  pkgs,
  ...
}: {
  # Add the Kvantum theme package to your user profile
  # Kvantum will automatically detect themes placed here
  home.packages = with pkgs; [
    dracula-qt5-theme
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
    # Force dark mode for GTK3/GTK4 apps
    gtk3.extraConfig = {gtk-application-prefer-dark-theme = 1;};
    gtk4.extraConfig = {gtk-application-prefer-dark-theme = 1;};
  };

  # 3. Kvantum Theme Config
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Tell Kvantum to actively use the Dracula theme
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Dracula
  '';

  # 4. Explicitly Enforce Environment Variables globally
  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "kvantum";
    GTK_THEME = "Dracula";
    XCURSOR_THEME = "Dracula-cursors";
    XCURSOR_SIZE = "24";
  };
}
