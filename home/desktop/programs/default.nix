{ pkgs
, config
, ...
}:
let
  ai-tools = with pkgs; [
    opencode
    claude-code
    codex
    gemini-cli
  ];

  gui-tools = with pkgs; [
    neovide
    zathura
  ];
in
{
  home.packages = ai-tools ++ gui-tools;

  xdg.configFile =
    let
      mkLink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/config";
    in
    {
      "avater.png".source = mkLink "${confPath}/avater.png";
      "kitty".source = mkLink "${confPath}/kitty";
      "zathura".source = mkLink "${confPath}/zathura";
    };
}
