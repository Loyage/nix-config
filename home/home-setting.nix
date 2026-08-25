{
  pkgs,
  config,
  mylib,
  myvars,
  ...
}:
let
  skillsSourceDir = ../config/skills;
  skillsTargetDir = "${config.home.homeDirectory}/nix-config/config/skills";
  researchSkillsTargetDir = "${config.home.homeDirectory}/nix-config/config/research-skills";
in
{
  home = {
    inherit (myvars) username;
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${myvars.username}" else "/home/${myvars.username}";
    stateVersion = "25.11";
  };

  home.file =
    builtins.listToAttrs (
      builtins.map (
        skillPath:
        let
          skillName = builtins.baseNameOf skillPath;
        in
        {
          name = ".agents/skills/${skillName}";
          value.source = config.lib.file.mkOutOfStoreSymlink "${skillsTargetDir}/${skillName}";
        }
      ) (mylib.scanPaths skillsSourceDir)
    )
    // {
      # 全局安装科研 skill 集合；各 skill 通过 disable-model-invocation
      # 隐藏，只有手动调用 /skill:research-skill 后才进入上下文。
      ".agents/skills/research-skills".source =
        config.lib.file.mkOutOfStoreSymlink researchSkillsTargetDir;

      # Pi Agent 全局指令文件
      ".pi/agent/AGENTS.md".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/config/pi/AGENTS.md";
    };

  programs.home-manager.enable = true;
}
