{ lib }:
{
  # 用户信息（所有主机共享）
  username = "loyage";
  userFullName = "Loyage Mao";
  useremail = "792058350@qq.com";

  # macOS 主机
  macosHostname = "LoyagedeMacBook-Air";

  # SSH 公钥（用于 agenix 加密）
  publicKeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIAXuxU51HU+F/LtXawz/e4mirwRaLECQsOClxO/hKEXlBqk85YqUcnvFmM/2lMnxLxi63u7Ng/8NT/ZWizZQM+eGslIC7qc8GcEsMpnfv+AHTSk0qpSwhI+CC3r0M0EidA886s7VxUrPwNOFE+rLBk+JdHZR+eHFWDImsYAYMyj98XctdvAkgydjPcTw58RbgkgoLUnDJJ7d33q8o6JDuF014nmfRn7BjBNRXSt/gimILe9tDyUKpu7C+yAlX1jSgmgmLdgGtnT7j5T5blUoUouuxmVeYG+haEiygvZGVmUMFnvQTIbE7mvk4mjkorXHpjxGXGtGfnPAw11ZtX4NODacXArATemJPPDDHgn1QfsPEDaZGBOvolcOdKdlyf2wWOevHgFBN1yJiYoiIPYzRUwJSdb4LU0QPcwBWqL4XGpkby2pkzPV+U56QPafTnHPt+afmHaMOkNBRL9n7q72BxD3Oq9y8e8gyjQ2QEKg1rN9EUFpolkFke3HItycJRLE= loyage@legion"
  ];
}
