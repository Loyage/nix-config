{ config, lib, mylib, ... }:
let
  secretsPath = "${config.home.homeDirectory}/.secrets";
in
{
  # programs.openclaw = {
  #   enable = false;
  #
  #   # 文档目录（包含 AGENTS.md, SOUL.md, TOOLS.md 等）
  #   documents = mylib.relativeToRoot "config/openclaw";
  #
  #   config = {
  #     gateway = {
  #       mode = "local";
  #       auth = {
  #         # 从文件读取 gateway token
  #         tokenFile = "${secretsPath}/openclaw-gateway-token";
  #       };
  #     };
  #
  #     # channels.telegram = {
  #     #   # Telegram bot token 文件路径
  #     #   tokenFile = "${secretsPath}/telegram-bot-token";
  #     #   # TODO: 替换为你的 Telegram User ID（从 @userinfobot 获取）
  #     #   allowFrom = [ 123456789 ];
  #     #   groups = {
  #     #     "*" = {
  #     #       requireMention = true;
  #     #     };
  #     #   };
  #     # };
  #     #
  #     # providers.anthropic = {
  #     #   # Anthropic API key 文件路径
  #     #   apiKeyFile = "${secretsPath}/anthropic-api-key";
  #     # };
  #   };
  #
  #   instances.default = {
  #     enable = true;
  #     plugins = [
  #       # 在这里添加插件
  #       # { source = "github:acme/hello-world"; }
  #     ];
  #   };
  # };
}
