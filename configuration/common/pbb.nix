{ pkgs, ... }:

{
  users.users.pbb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRwBqKRQVVNKNN9XXlcumgGjdvo8WVujZGvWtnyvsBRPJoRQxgO6ONKM9GAnXEDok+OZE2/GNvLW08K0k7IL9xk4OVtttjQ2Qj0I4na6z4MmTUVtMspaxQup6wnXGxKIdKrMNKM7O8zrpHFusUym2dnYNSf06yIk55MZkOdCePkpdDEBCwDcqQFrE9Jg0jofdIvOdcVPzisJEwny/QGN30auWN2imr+Ij0Wqhp79Q1x4VT6f8uje2e8V5k0ZZYApDB+dankAtTc38FBRu5utVmKrSrEPEb8oPQN0YNQ6o/cQrrQr2r4AImS+FQRohIkliLt7FNkvigqie1ebU3w9XC2xGuUxlyLTKGxXoiQIk3j/XY07X4fG8/pcIndaT+C5kkejmoZ2yKZqxCHENDP+77lkcVGoE5VrX//C/YPsyGG06JfzZ29oBvIGPuPoehdyiFh0hMP6D2XLmt6K688z3tRgSV/CG8z4QKEoVGOTi0my4Wahi/kb4PQsmSosRC2GzHxueZjK7e3h35OW+keXbZlIULTRPWBk1JSoha13QAS1sLNZlks35DktOyV2YyOuXHZ9y5WYQL2+E2jIVE6FzSC84Aoaj+Kq64tE/Ey9AT4cu+zb0DNEiIKtiaKzZZ8a3pyVbXLripJTAYPFr8L/SS6H7b5G4Oi3wxyap5ACQ5JQ== milan"
    ];
    packages = with pkgs; [ vim ripgrep htop ];
  };
}
