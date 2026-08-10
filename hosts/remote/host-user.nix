{ lib, ... }:
let
  remoteUsername = builtins.getEnv "USER";
  remoteHomeDirectory = builtins.getEnv "HOME";
in
{
  home.username = lib.mkForce remoteUsername;
  home.homeDirectory = lib.mkForce remoteHomeDirectory;
}
