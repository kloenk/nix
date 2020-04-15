{ lib
, substituteAll
, bash
, coreutils
, openssh
, pass
, rsync
, findutils
, passDir ? "/home/$USER/.password-store"
}:

substituteAll {
  name = "deploy-secrets";
  version = "0.0.1";

  src = ./deploy_secrets.sh;
  isExecutable = true;
  
  path = lib.makeBinPath [
    coreutils
    openssh
    pass
    rsync
    findutils
  ];
  secrets = passDir;


  meta = { license = lib.licenses.mit; };
}
