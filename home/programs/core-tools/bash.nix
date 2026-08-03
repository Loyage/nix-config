{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.programs.oh-my-posh;
in
{
  home.packages = with pkgs; [
    blesh
  ];

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
      (lib.mkOrder 1500 ''
        if [[ $- == *i* && -f ${pkgs.blesh}/share/blesh/ble.sh ]]; then
            source ${pkgs.blesh}/share/blesh/ble.sh
            bleopt complete_auto_complete=1
            bleopt complete_menu_complete=1
            bleopt complete_menu_filter=1
        fi
      '')
    ];
  };
}
