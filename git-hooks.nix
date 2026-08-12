# Pre-commit hooks 配置 (git-hooks.nix)
#
# 用法：
#   nix flake check                    # 手动运行一次检查
#   nix develop                        # 进入 devShell，shellHook 自动安装 hooks
#   pre-commit run --all-files         # 手动对全部文件运行 hooks
{ self, git-hooks }:
system:
git-hooks.lib.${system}.run {
  src = self;
  hooks = {
    # Nix 格式化（RFC 风格，与 nixpkgs 一致）
    nixfmt-rfc-style.enable = true;
    # 检测未使用的 Nix 绑定
    deadnix.enable = true;
    # 删除行尾空白
    trailing-whitespace.enable = true;
    # 确保文件以换行结尾
    end-of-file-fixer.enable = true;
  };
}
