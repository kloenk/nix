{ ... }:

{
  services.engelsystem = {
    enable = true;
    appName = "test";
    mail.from.address = "noreply@engelsystem.de";
    mail.from.name = "Engelsystem";
    mail.username = "test@example.com";
    apiKeyFile = "/tmp/test.apikey";
    domain = "default";
  };
}
