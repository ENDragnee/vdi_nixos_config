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

  # networking.hostName = lib.mkForce "";
  boot.kernelParams = ["console=ttyS0,115200n8"];
  services.getty.helpLine = "VDI Serial Console";
  security.sudo.extraRules = [
    {
      users = ["vdi"];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
  systemd.services.vdi-agent = {
    description = "VDI NixOS Sync Agent";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    wantedBy = ["multi-user.target"];
    path = [
      pkgs.git
      "/run/wrappers"
      "/run/current-system/sw"
    ];
    serviceConfig = {
      ExecStart = "/persist/bin/vdi-agent";

      EnvironmentFile = "/persist/etc/vdi-agent.env";

      User = "vdi";
      Group = "users";

      Restart = "always";
      RestartSec = "10s";
    };
  };
  systemd.services.break-hostname-symlink = {
    description = "Break NixOS hostname symlink for Cloud-Init";
    before = ["cloud-init.service" "systemd-logind.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/rm -f /etc/hostname";
    };
  };

  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      preserve_hostname = false;
      manage_etc_hosts = true;

      ssh_deletekeys = false;
      ssh_genkeytypes = [];

      cloud_init_modules = [
        "migrator"
        "seed_random"
        "bootcmd"
        "write-files"
        "growpart"
        "resizefs"
        "set_hostname"
        "update_hostname"
        "update_etc_hosts"
      ];
      cloud_config_modules = [
        "ssh"
        "mounts"
        "runcmd"
      ];
    };
  };
  services.qemuGuest.enable = true;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
  systemd.services.cloud-init.serviceConfig.SuccessExitStatus = [0 1 2 3 4 5 6 7 8 9];
  systemd.services.cloud-config.serviceConfig.SuccessExitStatus = [0 1];
  systemd.services.cloud-final.serviceConfig.SuccessExitStatus = [0 1];
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
  networking.firewall.allowedTCPPorts = [22 8081];
  system.stateVersion = "25.05";
}
