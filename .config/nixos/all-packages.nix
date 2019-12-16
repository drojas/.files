{ config, pkgs, ... }:
{

  boot.cleanTmpDir = true;

  security.sudo.wheelNeedsPassword = false;

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 139 445 51820 ];
    firewall.allowedUDPPorts = [ 137 138 ];
    #firewall.allowedUDPPorts = [ 137 138 config.networking.wireguard.interfaces.wg0.listenPort ];
    hosts = {
      # "172.31.98.1" = [ "aruba.odyssys.net" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nix = {
      trustedUsers = [ "root" "david" ];
  };


  hardware = {
    enableAllFirmware = true;
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    #pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.support32Bit = true;
  };

  services = {
    timesyncd.enable = true;
    xserver = {
      enable = true;
      xkbOptions = "ctrl:nocaps";
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig.ultimate.enable = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      hasklig
      fira-code
      powerline-fonts
      ttf_bitstream_vera
      dejavu_fonts
      # nerdfonts
      vistafonts
      terminus_font
      latinmodern-math
      hack-font
      font-awesome
      source-code-pro
    ];
  };

  environment.pathsToLink = [ "/libexec" ];

  environment.systemPackages = with pkgs; [
    blueman
  ];
}
