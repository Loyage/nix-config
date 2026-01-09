{ mylib, inputs, pkgs, ... }:
{
  imports = mylib.scanPaths ./.;
  environment.systemPackages = [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
