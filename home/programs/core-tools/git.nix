{
  myvars,
  ...
}:
{
  programs = {
    gh = {
      enable = true;
      # Home Manager owns config.yml as an immutable Nix-store symlink.
      # Configure gh declaratively rather than letting `gh auth login` rewrite it.
      settings.git_protocol = "ssh";
    };
    lazygit.enable = true; # git TUI tool
    git = {
      enable = true;
      lfs.enable = true;

      settings = {
        user = {
          name = myvars.username;
          email = myvars.useremail;
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        fetch.prune = true;

        # replace https with ssh
        url = {
          "ssh://git@github.com/Loyage" = {
            insteadOf = "https://github.com/Loyage";
          };
        };
      };
    };
  };
}
