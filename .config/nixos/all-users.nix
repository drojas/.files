{ config, pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  users.extraUsers.david = {
    uid = 1000;
    isNormalUser = true;
    name = "david";
    group = "david";
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "network-manager" "systemd-journal"
      "docker"
    ];
    createHome = true;
    home = "/home/david";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
    ];
  };

  users.extraGroups.david = {
    gid = 1000;
  };
}
