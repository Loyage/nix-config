let
  myvars = import ../vars;
  keys = myvars.publicKeys;
in
{
  # pi agent 的 deepseek API key（机密，age 加密）
  "deepseek-api-key.age".publicKeys = keys;
}
