{ pkgs, ... }:
let
  nvd-last = (
    pkgs.writeShellApplication {
      name = "nvd-last";
      runtimeInputs = [ pkgs.nvd ];
      text = builtins.readFile ./bin/nvd-last.sh;
    }
  );
in
{
  home = {
    username = "mbrowning";
    homeDirectory = "/home/mbrowning";

    packages = with pkgs; [
      # Network debugging
      dnsutils
      ethtool
      ldns
      mtr
      nmap
      socat

      # Nix tools
      nix-output-monitor
      nvd

      # System debugging
      strace

      # Custom tools
      nvd-last
    ];

    stateVersion = "24.11";
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      enableCompletion = true;
    };

    git = {
      enable = true;
      userName = "User McProtocol";
      userEmail = "email@website.com";
    };
  };
}
