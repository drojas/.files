{ config, pkgs, ... }:

with import <nixpkgs> {};

{
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      "dot" = "git --git-dir=$HOME/.files/ --work-tree=$HOME";
    };
    shellInit =
      ''
      if status is-interactive
          neofetch
      end
      '';
  };

  programs.emacs = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
  };

  programs.git = {
    enable = true;
    userName = "David Rojas Camaggi";
    userEmail = "drojascamaggi@gmail.com";
  };

  home = {
    activation.linkMyFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
      # source - http://news.ycombinator.com/item?id=11070797

      git --git-dir=$HOME/.files/ --work-tree=$HOME status || git clone --bare git@github.com:drojas/.files.git $HOME/.files
      git --git-dir=$HOME/.files/ --work-tree=$HOME checkout
      git --git-dir=$HOME/.files/ --work-tree=$HOME config status.showUntrackedFiles no
    '';
    file = {
      ".emacs.d" = {
        source = fetchFromGitHub {
          owner = "syl20bnr";
          repo = "spacemacs";
          rev = "3f559a4233815c6129f9ad593d5dee9fff199a1c";
          sha256 = "1p356dg5kql5jjmd01q63bw02cdr42wibcyrqls1nhl0d39d50v8";
        };
        recursive = true;
      };
    };
    packages = [
      pkgs.neofetch
    ];
  };


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # services.compton = {
  #   enable = true;
  #   fade = false;
  #   shadow = true;
  #   fadeDelta = 4;
  #   inactiveOpacity = "0.8";
  #   extraOptions =
  #     ''
  #       no-dock-shadow = true;
  #     '';
  # };
}
