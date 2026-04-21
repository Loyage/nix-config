{ myvars
, ...
}:
let
  inherit (myvars) username macosHostname;
in
{
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
  networking.hostName = macosHostname;
  networking.computerName = macosHostname;
  system.defaults.smb.NetBIOSName = macosHostname;
}
