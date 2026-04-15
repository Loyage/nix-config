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
  # age.secrets.example = {
  #   file = ../../secrets/example.age;
  #   path = "/tmp/example-secret"; # where the secret will be decrypted to
  #   mode = "0400";
  #   owner = myvars.username;
  # };
}
