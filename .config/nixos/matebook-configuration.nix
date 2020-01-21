{ config, pkgs, lib, ... }:

let
  artwork = builtins.fetchTarball {
    url = https://github.com/NixOS/nixos-artwork/archive/master.tar.gz;
  };

in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  imports =
    [ ./matebook-hardware-configuration.nix
      ./all-packages.nix
      ./all-users.nix
    ];

  # TODO: evaluate moving these to all-packages
  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    # kubectl
    emacsGit
    latte-dock
  ];

  virtualisation.docker.enable = true;
  # services.kubernetes = {
  #   roles = [ "master" "node" ];
  # #   # addons.dashboard.enable = true;
  #   masterAddress = "localhost";
  #   easyCerts = true;
  # };
  # services.dockerRegistry.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ext4" ];

  fonts.fontconfig.dpi = 170;
  i18n.consoleFont = "ter-i32b";
  i18n.consolePackages = with pkgs; [ terminus_font ];
  boot.earlyVconsoleSetup = true;

  networking.networkmanager.enable = true;
  networking.hostName = "matebook";
  time.timeZone = "America/Los_Angeles";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.bumblebee.enable = true;
  services.upower.enable = true;
  services.logind.lidSwitch = "suspend";

  services.compton.enable = true;
  services.compton.backend = "glx";

  services.xserver = {
    layout = "us,es";

    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    desktopManager.default = "plasma5";
    desktopManager.xterm.enable = false;

    videoDrivers = [ "intel" ];
    dpi = 170; # 170, 227, 259, 276

    xkbOptions = "grp:alt_shift_toggle, ctrl:swapcaps";

    displayManager.sessionCommands = ''
      ${pkgs.xorg.xhost}/bin/xhost +SI:localuser:$USER
    '';
    windowManager.session = lib.singleton {
      name = "exwm";
      start = with pkgs; ''
        ${emacsGit}/bin/emacs --daemon -f exwm-enable
        ${emacsGit}/bin/emacsclient -e '(progn (spacemacs/exwm-app-launcher "plasmashell"))' -c
      '';
    };

    # displayManager.auto.enable = true;
    # displayManager.auto.user = "david";
  };

  system.stateVersion = "19.09";
  system.autoUpgrade.enable = true;
}
