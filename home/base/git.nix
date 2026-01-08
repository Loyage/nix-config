{ myvars
, ...
}: {
  programs.git = {
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
    };
  };
}
