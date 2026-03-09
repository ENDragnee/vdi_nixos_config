{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    # Runs in all shell sessions (perfect for exported variables)
    shellInit = ''
      set -gx SOPS_AGE_KEY_FILE ${config.home.homeDirectory}/.age/key.txt
    '';

    # Runs only in interactive sessions
    # (Home Manager automatically wraps this in `if status is-interactive`)
    interactiveShellInit = ''
      # Commands to run in interactive sessions can go here
    '';

    # Optional: You can also define shell aliases declaratively here in the future!
    # shellAliases = {
    #   ll = "ls -l";
    #   update = "sudo nixos-rebuild switch --flake .#vdi";
    # };
  };
}
