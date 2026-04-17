{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # Runtime & Languages
    python3
    uv
    (lib.lowPrio nodejs)
    cargo
    lua
    luarocks

    # Build Tools
    cmake
    gnumake
    gcc
  ];
}
