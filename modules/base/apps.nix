{ pkgs, inputs, ... }: {
  # Install packages from nix's official package repository.
  # These are available to all users and reproducible across machines.
  environment.systemPackages = with pkgs; [
    # Core tools
    wget
    curl
    git
    neovim
    yazi
    zsh
    just
    jq

    # Development & System
    gcc
    libiconv
    home-manager

    # Secret management
    age
    inputs.agenix.packages.${stdenv.hostPlatform.system}.default
  ];
}
