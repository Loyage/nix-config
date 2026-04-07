{ pkgs
, myvars
, ...
}:
let
  inherit (myvars) username macosHostname;
in
{
  networking.hostName = macosHostname;
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
  nix.settings.trusted-users = [ username ];
  networking.computerName = macosHostname;
  system.defaults.smb.NetBIOSName = macosHostname;
}
