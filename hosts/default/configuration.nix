{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gnome-wayland.nix
      ./nvidia.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "America/Kentucky/Louisville";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb.variant = "";
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.libinput.enable = true;

  users.users.agluck = {
    isNormalUser = true;
    description = "Andrew Gluck";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "agluck" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Need electron for now, a couple of packages uses it
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    binutils
    gcc11
    vim
    neovim
    neofetch
    home-manager
    google-chrome
    bottom
    nodejs_21
    zoom-us
    kitty
    wofi
    wget
    speedtest-cli
    curl
    git
    fd
    steam
    volta
    teams-for-linux
    obsidian
    todoist
    slack
    yarn
    gnome-console
    discord
    todoist-electron
    asciiquarium
    chatblade
    _1password-gui
    firefox
    gnome.file-roller
    gnome.nautilus
    du-dust
    bat
    eza
    ripgrep
    fzf
    catppuccin-gtk
    zellij
    xiphos
  ];

  location.provider = "manual";
  location.latitude = 40.267193;
  location.longitude = -86.134903;

  # All values except 'enable' are optional.
  services.redshift = {
    enable = true;
    brightness = {
      # Note the string values below.
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  services.gnome.core-utilities.enable = false;
  virtualisation.docker.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" "Hack" ]; })
  ];

  programs.neovim.defaultEditor = true;
  programs.hyprland.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [ "blue" ]; # You can specify multiple accents here to output multiple themes
      size = "standard";
      variant = "mocha";
    };
  };

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  powerManagement.powertop.enable = true;

  services.openssh.enable = true;

  systemd.services.ssh-tunnel = {
    enable = true;
    description = "SSH Tunnel for *.dev.pro-unlimited.com";
    after = [ "network.target" ];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      User = "agluck";
      ExecStart = "/run/current-system/sw/bin/ssh -N -D 8899 agluck@andrews-mbp";
      restart = "always";
      restartSec = 3;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    3389
  ];

  system.stateVersion = "23.11"; # Did you read the comment?

}
