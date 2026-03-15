{
  config,
  pkgs,
  ...
}: {
  # Install Compilers, Runtimes, and Language Servers
  home.packages = with pkgs; [
    # C / C++
    gcc
    gnumake
    cmake
    clang-tools # Provides clangd LSP for VSCode

    # Java
    jdk17 # Or jdk21 if you prefer
    maven
    gradle

    # JavaScript / TypeScript / Node.js
    nodejs_22
    yarn
    nodePackages.typescript
    nodePackages.typescript-language-server

    # HTML / CSS / JSON
    nodePackages.vscode-langservers-extracted # Provides HTML/CSS/JSON LSPs
    nodePackages.prettier # Formatter

    # Golang
    go
    gopls # Go Language Server
    delve # Go Debugger

    # PHP & Laravel
    php82
    php82Packages.composer
    phpactor # PHP Language Server

    # Python & Django
    python311
    python311Packages.pip
    python311Packages.virtualenv
    pyright # Python type checker / LSP
    black # Python formatter

    # Docker Tools
    docker-compose
  ];

  # Manage VSCode and its Extensions Declaratively
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # C/C++
        ms-vscode.cpptools

        # Java
        redhat.java
        vscjava.vscode-java-debug
        vscjava.vscode-java-test
        vscjava.vscode-maven

        # Web (JS/TS/HTML/CSS)
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode

        # Go
        golang.go

        # Python
        ms-python.python
        ms-python.vscode-pylance

        # Docker
        ms-azuretools.vscode-docker

        # Optional: Dracula Theme for VSCode!
        dracula-theme.theme-dracula
      ];

      # Configure VSCode settings directly in Nix!
      userSettings = {
        "workbench.colorTheme" = "Dracula";
        "editor.formatOnSave" = true;
        "[python]" = {"editor.defaultFormatter" = "ms-python.black-formatter";};
        "[javascript]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
        "[html]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      };
    };
  };
}
