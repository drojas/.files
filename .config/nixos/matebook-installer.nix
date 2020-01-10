{config, pkgs, lib, ...}:

with import <nixpkgs> {};

let
  dotSrc = fetchFromGitHub {
    owner = "drojas";
    repo = "dot";
    rev = "63a7599359371906f182620688e10e24291e4612";
    sha256 = "1sgbslzd7xlr076lsddc8ds085xlhg949qvz6br6wnrx4xf05qrb";
    fetchSubmodules = true;
  };
in
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
    ./all-packages.nix
    "${dotSrc}/nixpkgs/nixos/modules/programs/dot.nix"
  ];

  # TODO:
  # - add initial /etc/configuration template to some file in installer for easier setup
  # - make installation process to copy the template to the right place or just take it from the usb after installing depending on what is easier

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  programs.dot.enable = true;

  # configure proprietary drivers
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  # boot.initrd.kernelModules = [ "wl" ];
  # boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [
    "kvm-intel"
    # "wl"
  ];
  boot.extraModulePackages = [
    # config.boot.kernelPackages.broadcom_sta
  ];

  # programs that should be available in the installer
  environment.systemPackages = with pkgs; [
    fish
    git
    gnupg
    vim
  ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
