{ myvars, lib, ... }: {
  # SSH 客户端配置（~/.ssh/config）与 authorized_keys 的声明式管理
  # 数据源：vars/default.nix 的 sshHosts / authorizedKeys

  programs.ssh = {
    enable = true;

    # home-manager 即将移除 programs.ssh 的隐式默认值（enableDefaultConfig），
    # 这里显式声明与旧默认值一致的 settings."*"，避免行为变化。
    enableDefaultConfig = false;

    settings = {
      # 全局默认值（对应旧的 enableDefaultConfig 默认配置）
      # home-manager 会把 settings."*" 自动渲染为最后一个 `Host *` 块
      "*" = {
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };
    }
    # 从 vars.sshHosts 生成 ~/.ssh/config 的 Host 块（裸属性名会自动加 Host 前缀）
    // lib.mapAttrs (
      _: host:
      {
        HostName = host.hostname;
        User = host.user;
        Port = host.port;
      }
      // lib.optionalAttrs (host ? identityFile) { IdentityFile = host.identityFile; }
      // lib.optionalAttrs (host ? localForwards) { LocalForward = host.localForwards; }
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
