{ myvars, lib, ... }: {
  # SSH 客户端配置（~/.ssh/config）与 authorized_keys 的声明式管理
  # 数据源：vars/default.nix 的 sshHosts / authorizedKeys

  programs.ssh = {
    enable = true;

    # 从 vars.sshHosts 生成 ~/.ssh/config 的 Host 块
    matchBlocks = lib.mapAttrs (
      _: host:
      {
        hostname = host.hostname;
        user = host.user;
        port = host.port;
      }
      // lib.optionalAttrs (host ? identityFile) { identityFile = host.identityFile; }
      // lib.optionalAttrs (host ? localForwards) { localForwards = host.localForwards; }
    ) myvars.sshHosts;
  };

  # 本机 authorized_keys（允许哪些公钥登录，公钥非机密）
  # 不用 home.file（它是 symlink 到 nix store、owner=root，sshd StrictModes 会拒绝），
  # 用 activation 写真实文件并 chmod 600，三平台（NixOS/macOS/remote）行为一致。
  home.activation.writeAuthorizedKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.ssh"
    cat > "$HOME/.ssh/authorized_keys" <<'EOF'
${lib.concatStringsSep "\n" myvars.authorizedKeys}
EOF
    chmod 600 "$HOME/.ssh/authorized_keys"
  '';
}
