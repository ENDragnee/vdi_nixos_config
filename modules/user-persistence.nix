# modules/user-persistence.nix
{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist/home/vdi" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "projects" # Assuming you code here!

      # App State
      ".config/Code" # VSCode config and extensions
      ".config/chromium" # Chromium profile
      ".mozilla" # Firefox profile
      ".cache/clipcat" # Clipboard history

      # Security & SSH
      ".ssh"
      ".gnupg"
      ".age" # Your SOPS age keys
      ".local/share/keyrings"

      # Shell State
      ".local/share/direnv"
      ".local/share/fish"
    ];

    files = [
      ".bash_history"
    ];
  };
}
