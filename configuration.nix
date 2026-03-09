{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vdi";
  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Addis_Ababa";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system & Openbox
  services.xserver.enable = true;
  services.xserver.windowManager.openbox.enable = true;

  # Display manager
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.slick.enable = true;
  };

  # Wayland compositor
  programs.labwc.enable = true;

  fonts.packages = with pkgs; [
    roboto
    roboto-mono
    roboto-slab
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.roboto-mono
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;
  services.openssh.enable = true;

  users.users.vdi = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # Core system packages (User apps moved to home.nix)
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    git
    curl
    tree
    gcc
    libgcc
    python313
    python313Packages.pip
    pipx
    sops
    age
  ];

  environment.variables = {
    INFLUX_TOKEN = "1U3fzAh3aTgrZwACibfv4sjHfNdVKu-VR80x4QXXoH_pGySUGSduzXmk2zUTZV50ZnTXzZHTQl6zLBXb9XmokA==";
    POSTGRES_PASSWORD = "qazwsxedc";
  };

  services.telegraf = {
    enable = true;
    environmentFiles = ["/etc/nixos/telegraf.env"];
    extraConfig = {
      global_tags = {dc = "us-east-1";};
      agent = {
        interval = "10s";
        round_interval = true;
      };
      inputs = {
        cpu = {
          percpu = true;
          totalcpu = true;
          report_active = true;
        };
        disk = {mount_points = ["/"];};
        diskio = {};
        kernel = {};
        mem = {};
        net = {};
        processes = {};
        swap = {};
        system = {};
      };
      outputs = {
        influxdb_v2 = {
          urls = ["http://192.168.53.107:8086"];
          token = "$INFLUX_TOKEN";
          organization = "code_tamers";
          bucket = "vdi_bucket";
        };
        kafka = {
          brokers = ["192.168.53.107:9092"];
          topic = "vm-metrics";
          data_format = "json";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
