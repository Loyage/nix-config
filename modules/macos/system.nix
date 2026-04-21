###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 5; # Define the state version of the system configuration.
    primaryUser = "loyage";
  };
  programs.zsh.enable = true;
  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
}

