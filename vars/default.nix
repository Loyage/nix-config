# vars 入口：合并公开配置（public.nix）与私有配置（private.nix）。
#
# ⚠️ private.nix 含公网 IP 等敏感数据，由 git-crypt 加密（见 .gitattributes）。
#    clone 后必须先 `git-crypt unlock <keyfile>` 才能求值本配置。
let
  public = import ./public.nix;
  private = import ./private.nix;
in
public // private
