{ pkgs, ... }:

{
  users.users.pbb = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDfsy5TuBCmxCrS/Zei1mTWMVko1yZlL/0QdhqNxa64LbF/gWK792ibpbVT3ybqjkRG53OegWNNAbWsXEOaAmiMwPoYGFfw1C7Q5GbyPk7RfwsKkGhVk8k7STe48MvpIT1hTw62Bj/udPVPA/guiPGiMUKMVZHwrSMiqIz5aeOcFLyp6C0IBGPCuon84IACf2/mgJoqD9+E5o3Caqw+tGOFfxYZO17t+aGNEYL9XON1tBtUPlEgEQRwPaEoj7vsZUPYyqHb4QrjxH/DEKMv5nKj7Kd5vsRUm5F658qaiHHXAwTmSDuyb5075UD0PTMtSenqKeAEkgVPAaGjWULgoOtQYS8e/syZgrxuWghK+yx7PkWUfUE0H2C5n5cXh80Rs27MhAlNq85+CBiwVKvYP/hcwORhMocCZM+ev3eHV12P56CQGyxNhOKdrgHHDzzhiFYX2aZVTtSw/0S5AJA7xVZGAvmwbGlgbBBofW4wlheTu3Yi1gi8rnuCahB1r6Dg9TtozjdEHfskWpg2QQ4cgx+lyrg+OkjOQrCdci0sTyGqghyNpo8kmppLfT7QkLECMwepJdUgREqXFCDl7n8ljvIxNTCVERbs/27YT9n2y5gkbz1zBqkAi+uSM8/b5KRpsMzVKMoaPvBbMwVy+36jPyz6C3bXSvgJwEEgjUo92bxEXw=="
    ];
    packages = with pkgs; [ vim ripgrep htop ];
  };
}
