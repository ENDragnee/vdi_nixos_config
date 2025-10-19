# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vdi"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Africa/Addis_Ababa";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  #console = {
   # font = "Lat2-Terminus16";
   # keyMap = "us";
   # useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  fonts.packages = with pkgs; [
    roboto
    roboto-mono
    roboto-slab
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.roboto-mono
  ];

  qt = {
    enable = true;
    style = lib.mkForce "gtk2";
    platformTheme = "gtk2"; #can be qt5ct;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vdi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;
  programs.i3lock.enable = true;

  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    swaybg
    alacritty
    wlr-randr
    htop
    rofi
    waybar
    waypaper
    git
    curl
    nemo
    brightnessctl
    wl-clipboard
    xclip
    cliphist
    clipcat
    vscode
    chromium
    libgcc
    dunst
    nitrogen
    polybar
    tint2
    fish
    gcc
    betterlockscreen
    i3lock
    xautolock
    obconf
    lxappearance
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugins
    openbox-menu
    lxmenu-data
    nemo-fileroller
    xarchiver
    dconf-editor
    glib
    gsettings-desktop-schemas
    dracula-theme
    dracula-qt5-theme
    dracula-icon-theme
    telegraf
    python313
    python313Packages.pip
    pipx
  ];

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
    Xcursor.theme: Dracula-cursor
    Xcursor.size: 24
    EOF
  '';

  environment.variables = {
    XCURSOR_THEME = "Dracula-cursor";
    XCURSOR_SIZE = "24";
  };

  programs.labwc.enable = true;
  services.xserver.windowManager.openbox.enable = true;

  # Display manager (Wayland-native)

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick.enable = true;
  };

  #services.greetd = {
    #enable = true;
    #settings = {
      #default_session = {
        #command = "${pkgs.labwc}/bin/labwc";
        #user = "vdi";
      #};
    #};
  #};

  # Ensure seat management works
  services.dbus.enable = true;
  security.polkit.enable = true;

  #programs.regreet.enable = true;
  #programs.regreet.settings = {
    #background = "/etc/nixos/greetd_background/login.jpg";
    #scale = 1.0;
  #};

  # Enable hardware acceleration
  hardware.graphics.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}

