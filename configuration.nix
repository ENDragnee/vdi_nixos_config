{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ./modules/system-persistence.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/persist".neededForBoot = true;
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
    greeters.slick = {
      enable = true;

      # Set the GTK theme for the login screen
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };

      # Set the Icon theme for the login screen
      iconTheme = {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };

      # Set the Cursor theme for the login screen
      cursorTheme = {
        name = "Dracula-cursors";
        package = pkgs.dracula-theme;
        size = 24;
      };
    };
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
  virtualisation.docker.enable = true;

  users.users.vdi = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.fish;
    hashedPassword = "$6$lcHDtlSQnITA/LkO$a1uRD4DSqFiTYEoKn5xajAIIQ3t.mDSt1ILIbneXtCnunr16bx7.hRwFBZ.pUo3UVxuGIepac/vhsrJjtq4wA1";
  };
  users.mutableUsers = false;

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
  };

  services.telegraf = {
    enable = true;
    environmentFiles = ["/persist/etc/nixos/telegraf.env"];
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
        proxmox = {
          base_url = "$PROXMOX_URL";
          api_token = "$PROXMOX_API_TOKEN";
          additional_vmstats_tags = ["vmid" "status"];
          insecure_skip_verify = true;
          interval = "30s";
          response_timeout = "20s";
          tagpass = {
            vmid = ["100" "105" "110"];
          };
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
          urls = ["$INFLUX_URL"];
          token = "$INFLUX_TOKEN";
          organization = "code_tamers";
          bucket = "vdi_bucket";
        };
        kafka = {
          brokers = ["$KAFKA_URL"];
          topic = "vm-metrics";
          data_format = "json";
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
