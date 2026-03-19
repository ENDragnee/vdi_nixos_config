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
  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      preserve_hostname = false;
      manage_etc_hosts = true;
    };
  };
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-networkd-wait-online.enable = false;
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
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "prohibit-password";
    };
  };
  virtualisation.docker.enable = true;

  users.users.vdi = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$.RmkzUgf2SjGNnPWHnk1R.$6JTMBVEqgzdcg6zApEF3UP/Lua2pIe7OMPizgKnIcTA";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEf+6huo0y/HsiTOgh2UgQVP6PK7AtiCzqhKSeAKEIlpguImNOzI0n+mkoTTBqJsdbagySqAtNLagw+APh3fPNXb4UyHdbXUeo1UWe9T55lRaeYH0emqbtHx0Dekd3uqGNQTRAq0Aw6kItSfMoyS6Bx5UFE5U5v+pVvwfa20p6OMtmVWz+C88bds1LPJbmnd91VF+lcKDOnUPdYu+FT8nGxMVuA354SbaUHgcFqayj7a4HZ5gbki7GZ4Bbc4DLysE1cjHx1Y2UiMCg+q4dWiMgQAwv9Ag32gSSQaP2CpfKMQ41wtvLppUVJnRFbfzePuQ5uLCfpCLXxWGRpJFjFt9"
    ];
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
    cloud-init
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
          node_name = "pve";
          additional_vmstats_tags = ["vmid" "status"];
          insecure_skip_verify = true;
          interval = "30s";
          response_timeout = "20s";
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
  networking.firewall.allowedTCPPorts = [22];
  system.stateVersion = "25.05";
}
