{ pkgs
, config
, mylib
, myvars
, ...
}:
let
  skillsDir = "${config.home.homeDirectory}/nix-config/config/skills";
  mkSkillLink = skillPath:
    let
      skillName = builtins.baseNameOf skillPath;
    in
    {
      name = ".agents/skills/${skillName}";
      value.source = config.lib.file.mkOutOfStoreSymlink "${skillsDir}/${skillName}";
    };
in
{
  home = {
    inherit (myvars) username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${myvars.username}" else "/home/${myvars.username}";
    stateVersion = "25.11";
  };

  home.file = builtins.listToAttrs (builtins.map mkSkillLink (mylib.scanPaths skillsDir));

  programs.home-manager.enable = true;
}
