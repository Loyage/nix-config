{ pkgs, myvars, ... }:
{
  age = {
    # System and user keys are tried in order until one decrypts the secret.
    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
      "${if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home"}/${myvars.username}/.ssh/id_rsa"
      "${
        if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home"
      }/${myvars.username}/.ssh/id_ed25519"
    ];

    secrets = {
      deepseek-api-key = {
        # 默认 path 为 /run/agenix/deepseek-api-key。
        file = ../../secrets/deepseek-api-key.age;
        mode = "0400";
        owner = myvars.username;
      };
      mimo-api-key = {
        file = ../../secrets/mimo-api-key.age;
        mode = "0400";
        owner = myvars.username;
      };
      git-crypt-key = {
        # 用法：git-crypt unlock /run/agenix/git-crypt-key
        file = ../../secrets/git-crypt-key.age;
        mode = "0400";
        owner = myvars.username;
      };
    };
  };
}
