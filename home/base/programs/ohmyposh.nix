{ lib
, config
, ...
}: {
  # shell prompt
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = false;
    configFile = ../../../config/ohmyposh/EDM115-newline.omp.json;
  };
  # 这里必须禁用默认的 zshIntegration，把 oh-my-posh 的初始化代码提到最高优先级，否则会产生吞行 bug
  programs.zsh.initContent =
    let
      cfg = config.programs.oh-my-posh;
    in
    lib.mkOrder 500 ''
      eval "$(${lib.getExe cfg.package} init zsh --config ${cfg.configFile})"
    '';
}
