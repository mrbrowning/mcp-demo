{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
    ./services
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;
  networking.hostName = "mcp-demo";
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    inetutils
    lsof
    mtr
    podman-tui
    sysstat
    vim
    wget
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.mosh.enable = true;

  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users = {
    mbrowning = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESlq9MXjS7b3XF6WGaAe6ffRFCU4eSBX2hLgPILHfhO mcpuser@laptop"
      ];
      packages = with pkgs; [
        tree
      ];
    };
  };

  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  system.stateVersion = "24.11";
}
