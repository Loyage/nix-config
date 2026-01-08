{ pkgs
, ...
}: {
  programs.zsh = {
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
        "brew"
        "eza"
        "conda"
        "archlinux"
        "sudo" # <Esc> twice to add 'sudo' before the last command
        # "zsh-syntax-highlighting" # highlights
        # "fast-syntax-highlighting" # highlights
        "autojump" # load autojump, which can 'j' to frequently used folders
        "dirhistory" # <Alt> + ↑↓←→
        # "you-should-use" # if alias exists, suggest it: https://github.com/MichaelAquilina/zsh-you-should-use
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

  home.shellAliases = { };
}
