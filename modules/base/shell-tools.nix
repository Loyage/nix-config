{ pkgs
, inputs
, ...
}: {
  environment.variables.EDITOR = "nvim --clean";
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    wget
    curl
    rsync

    fastfetch
    neovim
    yazi
    zsh
    just

    # Development & System
    gcc
    libiconv
    home-manager

    duf # Disk Usage/Free Utility - a better 'df' alternative
    dust # A more intuitive version of `du` in rust
    gdu # disk usage analyzer(replacement of `du`)
    ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)

    file
    which
    tree
    tealdeer

    # Secret management
    age
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default
  ];
}
