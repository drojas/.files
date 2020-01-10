{ config, pkgs, lib, ... }:

let
  username = "david";
in {
  imports = [
    (builtins.fetchTarball {
      url = "https://github.com/rycee/home-manager/archive/release-19.09.tar.gz";
      sha256 = "1d3391by9r4vfbq1qisj7lbsacxrh8p6lpqhwccsmj3pfzkmvssc";
    } + "/nixos/default.nix")
  ];
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
  home-manager.useUserPackages = true;
  home-manager.users.david =
    let
      dotSrc = builtins.fetchGit {
        url = "https://github.com/drojas/.files.git";
        rev = "139a5b6b46a602c92f632084a89b907a5d7ba923";
      };
    in
      (import "${dotSrc}/.config/nixpkgs/home.nix");
}
