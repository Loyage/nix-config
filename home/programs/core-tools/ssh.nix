{
  config,
  myvars,
  lib,
  pkgs,
  ...
}:
let
  detectedHost = if pkgs.stdenv.isDarwin then myvars.macosHostname else builtins.getEnv "HOSTNAME";
  defaultAuthorizedKeys = myvars.authorizedKeysByHost.${detectedHost} or myvars.authorizedKeys;
in
{
  options.localConfig.authorizedKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = defaultAuthorizedKeys;
    description = ''
      Public keys allowed to log in to this host. Override this per host; the
      global key list is retained only as a compatibility fallback.
    '';
  };

  config = {
    # SSH 客户端配置（~/.ssh/config）与 authorized_keys 的声明式管理。
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
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

    # Store symlinks can fail ssh StrictModes in user namespaces. Materialize
    # both SSH files atomically with private permissions and the current owner.
    home = {
      file.".ssh/config".force = true;
      activation = {
        materializeSshConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          configFile="$HOME/.ssh/config"
          tmp="$(mktemp "$HOME/.ssh/.config.XXXXXX")"
          run cp --dereference "$configFile" "$tmp"
          run chmod 600 "$tmp"
          run mv -f "$tmp" "$configFile"
        '';

        writeAuthorizedKeys = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          run install -d -m 700 "$HOME/.ssh"
          tmp="$(mktemp "$HOME/.ssh/.authorized_keys.XXXXXX")"
          cat > "$tmp" <<'EOF'
          ${lib.concatStringsSep "\n" config.localConfig.authorizedKeys}
          EOF
          run chmod 600 "$tmp"
          run mv -f "$tmp" "$HOME/.ssh/authorized_keys"
        '';
      };
    };
  };
}
