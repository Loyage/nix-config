{ pkgs
, myvars
, ...
}:
let
  inherit (myvars) username darwinHostname;
in
{
  networking.hostName = darwinHostname;
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
  nix.settings.trusted-users = [ username ];
  networking.computerName = darwinHostname;
  system.defaults.smb.NetBIOSName = darwinHostname;
}
