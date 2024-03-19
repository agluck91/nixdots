{ pkgs, ... }:
{
  networking = {
    hostName = "nixdev";
    networkmanager.enable = true;
    nameservers = [ "10.10.1.1" "1.1.1.1" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
  environment.systemPackages = with pkgs; [
    networkingmanagerapplet
  ];

  services.openssh.enable = true;
}
