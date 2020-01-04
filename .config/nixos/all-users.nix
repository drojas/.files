{ config, pkgs, ... }:

let
  username = "david";

in

{
  # TODO: use emacs settings for multi-term instead?
  # users.defaultUserShell = pkgs.zsh;
  users.extraUsers.david = {
    shell = pkgs.fish;
    uid = 1000;
    isNormalUser = true;
    name = username;
    group = username;
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "network-manager" "systemd-journal"
      "docker"
    ];
    createHome = true;
    home = "/home/${username}";
    # useDefaultShell = true;
    openssh.authorizedKeys.keys = [
    ];
  };

  users.extraGroups.david = {
    gid = 1000;
  };
}
