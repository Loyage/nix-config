{ pkgs, myvars, ... }: {
  # Agenix secret management configuration.
  # identityPaths are the private keys used to decrypt the secrets.
  # The system will try to use all of them until one works.
  age.identityPaths = [
    # System keys (typically for NixOS/Darwin system-level decryption)
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
    # User keys
    "${if pkgs.stdenv.isDarwin then "/Users" else "/home"}/${myvars.username}/.ssh/id_rsa"
    "${if pkgs.stdenv.isDarwin then "/Users" else "/home"}/${myvars.username}/.ssh/id_ed25519"
  ];

  # You can define secrets here or in other modules.
  age.secrets.deepseek-api-key = {
    # pi agent 的 deepseek API key（加密自 secrets/deepseek-api-key.age）
    file = ../../secrets/deepseek-api-key.age;
    # 默认 path 为 /run/agenix/deepseek-api-key（symlink → /run/agenix.d/deepseek-api-key）
    mode = "0400";
    owner = myvars.username;
  };
}
