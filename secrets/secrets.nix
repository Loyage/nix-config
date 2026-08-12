let
  myvars = import ../vars;
  keys = myvars.publicKeys;
in
{
  "example.age".publicKeys = keys;
}
