{
  # 公开配置（可安全提交到公开仓库）：
  # 用户名、主机名、公钥等非机密数据

  # 用户信息（所有主机共享）
  username = "loyage";

  # 仓库默认位于 $HOME 下的这个目录；NIX_CONFIG_ROOT 可在求值时覆盖。
  repositoryDirectory = "nix-config";

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
    # NixOS thinkpad 本机（hostname: nixos）— ~/.ssh/id_ed25519
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBOMetoPGnwCyaaLrTu1e03t0zfJFBtorpauDUwEsFfD loyage@nixos"
    # remote jzh 服务器
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkGycDKREAwvpU0/IOwkh7kaalg02N4mFDmVt828M8g jzh@cyy"
  ];

  # authorized_keys 的兼容默认值。建议各目标机通过 Home Manager 的
  # local.authorizedKeys option 覆盖，只保留该主机实际需要的登录密钥。
  authorizedKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCY61zbJWpNoORecdhomRIRtvzJI7Fr/xXlN6XaLjKeSLvqrZUOWxg9+7y2UYIRrXg1iCXDkI+53LVW14ZFK4ykDW50FLLedkZnnSGB9l/bfeugHqjVfqpYRZPxyJ/j+m1vq9cIYIcbny/lnuwa0cGHw94fn8NM6scp8qJDs0noBq8A0S92D23XpdFLm4zvN9rD5AYjhFjZMiMwmjoTDmOvh34U7Yca9DtH8tccSA5AMkPvxyLP3/itWvkvSDTC3RJXeXDwbGhXcr2rFw7UJtREnUfv5HImvxAjyh1YxafsArQCgi2/fgpvn2IN+XhIAoT4S79T+Yd1O1mEGIxkyQ2tsd1K9102qD66t3/TNURCsrNXjKhUvnAHuhLIWw4fFx9jXUIjQtLHom2JFbD00llNaJR97eDHkVRI/kr2aWia5tR7zYq5Z3GmxIheirsOSV7fi7gJT7D5akZoGRwJ22d/bWErYKkmvYT/7SvydtZMMCDtKEc2dgjFHEvOvfC1fMsuVaFL+nLk+YyHXHKSzbI06/QyY8CzmrkMAoygVv9leNoC25o41o57+hcQUHRBA6JhoYY36SvPCtnXF0X9rzlDdr8+WqvTtNuzQhRl9Rx3WKB2Qp4OwqWJq/4WMTZFBxTxCZpJjPOLm6GQ/CSBbYZyQU8/OFjHuZ9XSulurer0uQ== u0_a178@localhost" # miphone
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCV1J/NqKNahfccMkTigSP5B/G/ZDJh2gF9TdQmGUIm08EbFEcEdDd607/+YpMS9frFLnBjGQgLvciQhNbOHM6QQMoTkSBCNOrLPrTHzGwVz4Cvi+kqyiSsDq7K5o4rJ2DDQgydvSb/NtCWyvX8dyvhJ4e3+riaugqABJSpETlhlCb3gl4ejTxlt+SuonUsgzx3lxuTD7TLwCTEoQTLeGOL+Cj+y+ML9dM/+UckVBL1k/95baSusnejd9bdH9TfWwzFk2EEpS2aqbvMkaBugHNfQp5fTxLf4W3k6Bml0TiQmk78e5ucMHsWhoiBKoM0GULlrludJOgjXOE0tL3syJnUrkwKXcrnlljw0/ECrr6qGIgqBkzqIXqyRKAx22StGy6+/Q6fqE4TjV/bGNbZNqOd5IOF3LDhBoJ49nKC5fD94+xNYAihOrFhilq/c3Vyzp4xYeOzIJRfB+9H3w1YsJeCygEpneNloCqnlwEeIqww0gKennzaZqdE2i7lqu6cCes= loyage@nixos" # legion
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCdr1CWl5mI4gXYGbHP4CyQv22X1RtxrXof/tzSqewVfdAEvDv/gXuwzScX8ytkUis/DbsJZyDx3qlnZa3WF8Kg5XUI1EsaMAAB1sHaNOLLi+TgV6do5Oyc2ov1eAO+egww6MJ7TzZnJVpXlJ1Da6HDSiyN/yTU/BOz0QLOOU/bMOE7wYR6O/HFr9xsx0F94xO4NlrCB5eksBSgnClsdBZlpGtYq81BGPQaBJ6uTnwGcyk1d85j/5WMDw6/GR99j0Nud6Ukpzt4cfiMK/TavaY9DnrhJtkm1HUW4s7+b/DyM1ZYC6wF0NC5IlOcWjZRa0vJEOsBCaLfF4g4clGT7jlCYgzUTjZJrwkTwr+dcj2gZI60aWff2jloeVZa3wYsx8dVKAxghlcZ/z4VjE81aCX5syMioLwVMT01q5GLx08iWHQ2BgIII/x+cmadOUnuzITlGorlguwy175H6PR4kR0zJYX2LVxevHvBJRkRLDR1levsOb2k9cFsUrZ1NKS096BzOqspN2fQVyRHrd7SaIkpR6bJmdTopgazb1VqwCMLQD7W8IghfeRAecpHLm05IrfQnQ8+9pQziDRiR+JjxMXMaHir8jA5HdKZjKAnRhAp8eIRcUEn0I7Du0xd4IwtH1W5bflmnxo96rbtFHk5Iffcv2/mMRfRNeGXw05v5+Wddw== 792058350@qq.com" # mac
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCTeZTVZNN/l4+jUL41dol5GwkwJqv6tUcz9nM8CA2E6bU6abDpsns+JkkNgcUWBcykL9V4BB0h+qRJJgR7YrE5kq72FmrgcjPsHQMN9KeCxtMV+Yw5lYquCQh1j+qNWB0mRVnd6KDn5AIDfEZFyY4dk5z5nuEFqRDW/P/EZDnGRi9U7L11/QygHzK4A4fDQNfXbHzYAZLqjEqBKRMqxiVuK9+p6Im0yQVxcm3j/Miu8yYpcmLaz56veYmL48dUseNxxTsRjRvKdcbB4kV+HmrbwqmMUbTglZKmrWNp1cBjYsxZT6lCLsXmvwrr98jBCik1mRsp4xovCgkVJ6BiI1MnaxPgdvNl6zKZL/fv+5Umu0QXiMx0qgyAdI3ofWbcvK1v1ZwUf5EDXlYybjFyJ2JUiqGOlzZ/ye9m8cuTbyZ7AcJGdfxcLFC1uyKTb/UtAK5TI7LN9RP+98tLmAtMtO5UQRDHWdaOfZSNkN/vLOPug/4hERu91sUtATZltmfolH0= 792058350@qq.com" # thinkpad
  ];

  # 可在公开配置中按 hostname 分配密钥；未列出的主机回退到上面的兼容值。
  # authorizedKeysByHost.example-host = [ "ssh-ed25519 ..." ];
  authorizedKeysByHost = { };
}
