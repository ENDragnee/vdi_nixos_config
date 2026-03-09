{pkgs, ...}: {
  home.packages = with pkgs; [
    # Terminal & System Utilities
    alacritty
    htop
    neofetch
    ripgrep
    fd
    dconf-editor
    glib
    gsettings-desktop-schemas

    # Display / WM Utilities
    swaybg
    wlr-randr
    rofi
    waybar
    waypaper
    brightnessctl
    betterlockscreen
    i3lock
    xautolock

    # Clipboard managers
    wl-clipboard
    xclip
    cliphist
    clipcat

    # Apps
    nemo-with-extensions
    xarchiver
    vscode
    chromium

    # Openbox & X11 Tools
    openbox-menu
    lxmenu-data
    obconf
    lxappearance
    nitrogen
    tint2
    dunst

    # Themes
    dracula-theme
    dracula-qt5-theme
    dracula-icon-theme
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
  ];
}
