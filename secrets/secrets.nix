let
  # Import variables from vars/default.nix
  myvars = import ../vars { lib = (import <nixpkgs> {}).lib; };
  keys = myvars.publicKeys;
in
{
  "example.age".publicKeys = keys;
}
