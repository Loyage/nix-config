{ pkgs
, config
, ...
}: {
  programs.zsh = {
    dotDir = config.home.homeDirectory;
    enable = true;
    initContent = ''
      for f in ~/.config/zsh/*; do
          if [ ! -d $f ]; then
              source $f
          fi
      done
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "eza"
        "sudo"
        "autojump"
        "dirhistory"
      ];
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh-you-should-use/you-should-use.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];
  };
}
