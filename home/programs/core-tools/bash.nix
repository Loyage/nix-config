{ lib
, config
, ...
}:
let
  cfg = config.programs.oh-my-posh;
in
{
  programs.bash = {
    enable = true;
    initExtra = lib.mkMerge [
      (lib.mkOrder 500 ''
        eval "$(${lib.getExe cfg.package} init bash --config ${./beauty/ohmyposh/zen.toml})"
      '')
      ''
        if [ -d ~/.config/bash ]; then
            for f in ~/.config/bash/*; do
                if [ -f "$f" ]; then
                    source "$f"
                fi
            done
        fi
        if [ -f ~/.bashrc_custom ]; then
            source ~/.bashrc_custom
        fi
      ''
    ];
  };
}
