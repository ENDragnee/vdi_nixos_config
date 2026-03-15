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
      "/var/lib/docker" # CRITICAL: Keeps your docker containers/images
      "/etc/NetworkManager/system-connections" # Keeps WiFi passwords
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # Required for impermanence to work properly with user mounting
  programs.fuse.userAllowOther = true;
}
