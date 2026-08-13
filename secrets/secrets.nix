let
  myvars = import ../vars;
  keys = myvars.publicKeys;
in
{
  # pi agent 的 deepseek API key（机密，age 加密）
  "deepseek-api-key.age".publicKeys = keys;

  # git-crypt 对称 key（解锁 vars/private.nix 等加密文件，机密）
  # 新机器首次解锁：先从 thinkpad scp 或密码管理器获取 keyfile，
  # 或在本机 `agenix -d git-crypt-key.age` 解密后 `git-crypt unlock <keyfile>`
  "git-crypt-key.age".publicKeys = keys;
}
