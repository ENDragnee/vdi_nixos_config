{
  config,
  pkgs,
  ...
}: {
  # 1. Cursor Configuration
  # This automatically sets XCURSOR_THEME, XCURSOR_SIZE, and Xresources!
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # 2. GTK 2, 3, and 4 Configuration
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

    # Force dark mode for GTK3/GTK4 apps that support it
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # 3. Qt & Kvantum Configuration
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Declaratively set the Kvantum theme to Dracula
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Dracula
  '';

  # 4. Enforce GTK_THEME Environment Variable
  # (XCURSOR_THEME is handled automatically by home.pointerCursor above)
  home.sessionVariables = {
    GTK_THEME = "Dracula";
  };
}
