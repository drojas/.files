{config, pkgs, lib, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

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
  ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
