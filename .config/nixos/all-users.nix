{ config, pkgs, lib, ... }:

let
  username = "david";
in {
  imports = [
    (builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/release-19.09.tar.gz";
      sha256 = "0xqzz4pb084wsnglq8z6dhbz3c8l3v44bz0bzf51yqrs6g33ky8k";
    } + "/nixos/default.nix")
  ];
  # home-manager.useUserPackages = true;
  security.sudo.wheelNeedsPassword = false;
  # environment.variables.KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";
  security.sudo.extraConfig = ''
    Defaults:%kubernetes env_keep+=KUBECONFIG
  '';
  users.extraUsers."${username}" = {
    # TODO: use emacs settings for multi-term instead?
    shell = pkgs.fish;
    uid = 1000;
    isNormalUser = true;
    name = username;
    group = username;
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "network-manager" "systemd-journal"
      "docker"
      "kubernetes"
    ];
    createHome = true;
    home = "/home/${username}";
    # useDefaultShell = true;
    openssh.authorizedKeys.keys = [
    ];
    packages = with pkgs; [
      # nodejs-12_x
      # nodePackages.lerna
    ];
  };

  users.extraGroups.${username} = {
    gid = 1000;
  };
  home-manager.users."${username}" = (import ../nixpkgs/home.nix);
}
