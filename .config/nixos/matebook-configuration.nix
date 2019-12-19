{ config, pkgs, lib, ... }:

{
  imports =
    [ ./matebook-hardware-configuration.nix
      ./all-packages.nix
      ./all-users.nix
    ];

  # environment.variables = {
  #   GDK_SCALE = "2";
  #   GDK_DPI_SCALE = "0.5";
  #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  #   XCURSOR_SIZE = "32";
  #   # QT_SCALE_FACTOR
  #   # GDK_SCALE = "1";
  #   # GDK_DPI_SCALE = "1";
  #   # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  # };

  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    wireguard
    kitty
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ext4" ];

  fonts.fontconfig.dpi = 170;
  i18n.consoleFont = "ter-i32b";
  i18n.consolePackages = with pkgs; [ terminus_font ];
  boot.earlyVconsoleSetup = true;

  networking.networkmanager.enable = true;
  networking.hostId = "664d4279";

  time.timeZone = "America/Los_Angeles";
  networking.hostName = "matebook";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.bumblebee.enable = false;
  services.upower.enable = true;
  services.logind.lidSwitch = "suspend";

  services.compton.enable = true;
  services.compton.backend = "xrender";

  services.xserver = {
    layout = "us";

    # displayManager.sddm.enable = true;
    # desktopManager.plasma5.enable = true;

    videoDrivers = [ "intel" ];
    dpi = 170; # 170, 227, 259, 276

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager.sessionCommands = "${pkgs.xorg.xhost}/bin/xhost +SI:localuser:$USER";

    # windowManager.default = "i3";

    windowManager.session = lib.singleton {
      name = "exwm";
      start =
        ''
          ${pkgs.emacs}/bin/emacs --daemon -f exwm-enable
          ${pkgs.emacs}/bin/emacsclient -c
        '';
    };

    # windowManager.i3 = {
    #   enable = true;
    #   # package = pkgs.i3-gaps;
    #   extraPackages = with pkgs; [
    #     dmenu #application launcher most people use
    #     i3status # gives you the default i3 status bar
    #     i3lock #default i3 screen locker
    #   ];
    # };

    synaptics = {
      enable = true;
      palmDetect = true;
      twoFingerScroll = true;
      minSpeed = "1.0";
      maxSpeed = "2.0";
    };
  };

  #hardware.nvidia.optimus_prime.enable = true;
  #hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  #hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";
  virtualisation.docker.enable = true;
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.

  system.stateVersion = "18.09"; # Did you read the comment?
}
