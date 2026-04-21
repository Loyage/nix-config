{ lib
, config
, ...
}: {
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = false;
    configFile = ./EDM115-newline.omp.json;
  };
  # 必须禁用默认 zshIntegration，把 oh-my-posh 初始化提到最高优先级，否则会吞行
  programs.zsh.initContent =
    let
      cfg = config.programs.oh-my-posh;
    in
    lib.mkOrder 500 ''
      eval "$(${lib.getExe cfg.package} init zsh --config ${cfg.configFile})"
    '';
}
