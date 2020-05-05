{ config, lib, pkgs, ... }:

let
  allowedPorts = {
    allowedTCPPorts = [ 111 2049 4000 4001 4002 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 ];
  };
in {
  fileSystems."/export/kloenk" = {
    device = "/persist/data/kloenk";
    options = [ "bind" ];
  };

  fileSystems."/export/Filme" = {
    device = "/persist/intenso/Filme";
    options = [ "bind" ];
  };

  fileSystems."/export/mama" = {
    device = "/persist/mama";
    options = [ "bind" ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export 6.0.2.0/24(rw,sync,no_subtree_check,crossmnt,fsid=0) 192.168.178.0/24(ro,no_subtree_check,root_squash,anonuid=1000,anongid=1000,crossmnt,fsid=0)
    /export/kloenk 6.0.2.0/24(rw,nohide,no_subtree_check,root_squash,anonuid=1000,anongid=1000) 192.168.178.0/24(ro,hide,all_squash)
    /export/Filme 6.0.2.0/24(rw,nohide,no_subtree_check,root_squash,anonuid=1000,anongid=1000) 192.168.178.0/24(ro,nohide,no_subtree_check,root_squash,anonuid=1000,anongid=1000)
    /export/mama 6.0.2.0/24(rw,nohide,no_subtree_check,root_squash,anonuid=1000,anongid=1000) 192.168.178.0/24(rw,nohide,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
  '';

  # set ports
  networking.firewall.interfaces.eno1 = allowedPorts;
  networking.firewall.interfaces."vlan1337" = allowedPorts;

  services.nfs.server = {
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
  };

  # only reload so barahir does not have to restart
  systemd.services.nfs-server.reloadIfChanged = true;
}
