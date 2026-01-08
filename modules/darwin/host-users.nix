{ hostname
, username
, ...
}:
{
  networking.hostName = hostname;
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
  nix.settings.trusted-users = [ username ];
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
