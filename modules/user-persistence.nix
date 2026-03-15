# modules/user-persistence.nix
{
  config,
  pkgs,
  ...
}: {
  home.persistence."/persist" = {
    allowOther = true;
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
      {
        directory = ".ssh";
        mode = "0700";
      }
      {
        directory = ".gnupg";
        mode = "0700";
      }
      {
        directory = ".age";
        mode = "0700";
      }
      {
        directory = ".local/share/keyrings";
        mode = "0700";
      }

      # Shell State
      ".local/share/direnv"
      ".local/share/fish"
    ];

    files = [
      ".bash_history"
    ];
  };
}
