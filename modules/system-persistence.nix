# modules/system-persistence.nix
{
  config,
  pkgs,
  ...
}: {
  # Ensure the directory exists
  systemd.tmpfiles.rules = [
    "d /persist/var/log 0755 root root -"
    "d /persist/var/lib 0755 root root -"
  ];

  # The magic impermanence configuration
  environment.persistence."/persist" = {
    hideMounts = true; # Hides the bind mounts from tools like `df`

    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/docker"
      "/etc/NetworkManager/system-connections"

      "/var/lib/lightdm"
      "/var/cache/lightdm"
      "/var/lib/AccountsService"
      # "/var/lib/cloud"
      "/etc/ssh"
    ];

    files = [
      "/etc/machine-id"
    ];
  };

  # Required for impermanence to work properly with user mounting
  programs.fuse.userAllowOther = true;
}
