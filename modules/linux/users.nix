{ pkgs
, myvars
, ...
}:
let
  inherit (myvars) username;
in
{
  users.users."${username}" = {
    isNormalUser = true;
    home = "/home/${username}";
    description = username;
    group = "loyage";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };
  users.groups.loyage = { };

}
