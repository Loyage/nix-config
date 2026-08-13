{
  # 用户信息（所有主机共享）
  username = "loyage";
  userFullName = "Loyage Mao";
  useremail = "792058350@qq.com";

  # macOS 主机
  macosHostname = "LoyagedeMacBook-Air";

  # SSH 公钥（用于 agenix 加密）
  # ⚠️ 注意：age/agenix 只支持 ed25519 公钥（ssh-rsa 会解密失败），
  # 每台需要解密机密的主机都要把它的 ed25519 公钥加进这个列表。
  publicKeys = [
    # 本机 thinkpad (NixOS) — ~/.ssh/id_ed25519
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII5mat02toeqIPmh6hJuWqI0PU2+1N0GxZ5uvxHoZVMQ loyage@thinkpad"
    # MacBook Air (macOS) — ~/.ssh/id_ed25519
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGjwRoaSbb5uRHL2Fr7jIh5XlwVw0tFNX2MOLswyD2Bq loyage@LoyagedeMacBook-Air"
  ];
}
