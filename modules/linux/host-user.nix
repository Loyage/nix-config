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
}
