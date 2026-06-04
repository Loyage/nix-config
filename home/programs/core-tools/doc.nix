{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    pandoc # markdown to docx
    mdbook # markdown to html
  ];
}
