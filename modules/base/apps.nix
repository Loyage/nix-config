{ pkgs, ... }: {
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    neovim
    yazi
    yadm
    gcc
    zsh
    just
    jq
    home-manager
  ];
}
