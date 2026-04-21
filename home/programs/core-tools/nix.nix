{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    statix # lints and suggestions for nix
    nix-output-monitor # monitor nix build output in real time
    hydra-check # check hydra(nix's build farm) for the build status of a package
    nix-index # A small utility to index nix store paths
    nix-init # generate nix derivation from url
    nix-melt # A TUI flake.lock viewer
    nix-tree # A TUI to visualize the dependency graph of a nix derivation
  ];
}
