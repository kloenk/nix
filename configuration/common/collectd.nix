{ config, pkgs, ... }:

{
  services.collectd2.enable = true;
  services.collectd2.enableSyslog = true;

  services.collectd2.plugins = {
    ping.options.Host = "51.254.249.187";  # pix permissions
    cpu.options.ValuesPercentage = false;
    disk.options.IgnoreSelected = true;
    
    memory.hasConfig = false;
    swap.hasConfig = false;
    interface.hasConfig = false;
    df.hasConfig = false;
    load.hasConfig = false;
    uptime.hasConfig = false;
    entropy.hasConfig = false;
    dns.hasConfig = false;
    users.hasConfig = false;
  };
}