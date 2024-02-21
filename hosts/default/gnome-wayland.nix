{ pkgs, ... }: { 

  services.xserver = {
    enable = true;  
    displayManager.gdm = {
      enable = true;  
      wayland = true; 
    };
    desktopManager.gnome.enable = true; 
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
  };
}
