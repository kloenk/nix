{ pkgs, ... }:

{
  users.users.y0sh = {
    isNormalUser = true;
    #extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [''
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDniKpmb3sMMZWZjErihlI1qIwq3MIgCej3e2r2L9Fe7jE1ctLsAP8R29lJxGTYQclgNb8DasAR9JubJ46dLS88ZqLZK9MgJTgSO3mr89bIfn+P0MQlsTXld0qX8U0IvbIdJRFHHKwT0aLvT9MenQuGpTA5IzkboVekVYJ0ei7Mj5O+DWlSqAdYmN1oDi5Ov75Ejv5pSsDBcLrykS0PXDYMPfCAoak1p7AKJ2lM4CIIDYMw7Od+LYN+ez9Nv+moggptHtWuWzUWILBW/YfNmBWckX+KXVegwA0nPJHn5kjozLNCT4z359VSnuyAe69SFcZ7woJHdml7VXLnB7aE0TuzJlP8eX4LTtiQ1dj2AYRHiuos7o5jJcZWE5tK+7Hjj0mXRavrB0FBDvy23FO/yy4WpgVKGhEUzakj3Q01L6DJovC5Ad/prs5WVuKEYfft0xiNsQGPfphJmqYkrpyy8fDJJLGBC+ReISH7jWeMB3vCK+ZgN5O6Pj/vrAk9loyh+Dpg41dqeyd2mEEcsWVNppQuACpopvcN5x71bF1VB8NAUDXINOiEzjVVsUZjZcAHaE3LVwuCaLZwJ6ap2bY1ZaTCxN20nZYU+Ijew3HtbpDbX7yIT91niu3eDTgtQRCSXzZc0NPtCpHx/TzA5e5O67u02+fOQhhV2Xp4Uaf17xrQhw==
          ''];
    packages = with pkgs; [ vim ripgrep htop termite.terminfo ];
  };
}
