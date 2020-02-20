{ config, ... }:

{
  services.sshguard = {
    enable = true;
    services = [
      "sshd"
      "postfix"
      "dovecot2"
    ];
  };
}
