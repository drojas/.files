{ config, pkgs, ... }:

with import <nixpkgs> {};

{
  programs.home-manager.enable = true;

  # https://wiki.archlinux.org/index.php/HiDPI#X_Resources
  # xresources = {
  #   properties = {
  #     "Xcursor.size" = 128;
  #     "Xft.dpi" = 259; # 276
  #     "Xft.autohint" = 0;
  #     "Xft.lcdfilter" = "lcddefault";
  #     "Xft.hintstyle" = "hintfull";
  #     "Xft.hinting" = 1;
  #     "Xft.antialias" = 1;
  #     "Xft.rgba" = "rgb";
  #   };
  #   extraConfig = builtins.readFile(
  #     pkgs.fetchFromGitHub {
  #       owner = "dracula";
  #       repo = "xresources";
  #       rev = "ca0d05cf2b7e5c37104c6ad1a3f5378b72c705db";
  #       sha256 = "0lxv37gmh38y9d3l8nbnsm1mskcv10g3i83j0kac0a2qmypv1k9f";
  #     } + "/Xresources.dark"
  #   );
  # };

  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 64;
  };

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

  programs.chromium = {
    enable = true;
    extensions = [
      "hdokiejnpimakedhajhdlcegeplioahd" # lastpass
    ];
  };

  programs.git = {
    enable = true;
    userName = "David Rojas Camaggi";
    userEmail = "drojascamaggi@gmail.com";
  };

  home = {
    sessionVariables = {
      VISUAL = "emacsclient";
      EDITOR = "emacsclient";
      LANG = "en_US.UTF-8";
      # PATH = "~/.cabal/bin:~/.local/bin:$PATH";
    };
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
      pkgs.lastpass-cli
    ];
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
