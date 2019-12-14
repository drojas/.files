{ config, pkgs, ... }:
{
  imports =
    [ ./matebook-hardware-configuration.nix
      ./all-packages.nix
      ./all-users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;

  networking.networkmanager.enable = true;
  networking.hostId = "664d4279";

  #networking.nat = {
  #  enable = true;
  #  internalInterfaces = [ "wg0" ];
  #  externalInterface = "wlp60s0";
  #};

  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 16; # keep the latest eight 15-minute snapshots (instead of four)
    monthly = 12;  # keep only one monthly snapshot (instead of twelve)
  };


  time.timeZone = "US/Central";
  networking.hostName = "matebook";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";
  hardware.bumblebee.enable = false;
  services.upower.enable = true;
  services.logind.lidSwitch = "suspend";

  services.xserver = {
    synaptics = {
      enable = true;
      palmDetect = true;
      twoFingerScroll = true;
      minSpeed = "1.0";
      maxSpeed = "2.0";
    };
    videoDrivers = [ "intel" ];
  };

  #hardware.nvidia.optimus_prime.enable = true;
  #hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  #hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    wireguard
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
