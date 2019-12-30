{ config, pkgs, ... }:

with import <nixpkgs> {};

{
  imports = [ ./key-manager.nix ./source-manager.nix ];
  programs.home-manager.enable = true;

  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 64;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      "dot" = "git --git-dir=$HOME/.files/ --work-tree=$HOME";
      "pbcopy" = "xclip -selection clipboard";
      "pbpaste" = "xclip -selection clipboard -o";
    };
    # TODO: move to dotfiles?
    shellInit =
      ''
      if status is-interactive
          neofetch
      end

      # emacs ansi-term support
      if test -n "$EMACS"
         set -x TERM eterm-color
      end

      # this function may be required
      function fish_title
         true
      end
      '';
  };

  programs.emacs = {
    enable = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "haafibkemckmbknhfkiiniobjpgkebko" # Panda 5
      "chklaanhfefbnpoihckbnefhakgolnmc" # JSON View
      "chphlpgkkbolifaimnlloiipkdnihall" # OneTab
      "hdokiejnpimakedhajhdlcegeplioahd" # LastPass
      "naepdomgkenhinolocfifgehidddafch" # BrowserPass
      "mpbpobfflnpcgagjijhmgnchggcjblin" # HTTP/2 and SPDY indicator
    ];
  };

  programs.git = {
    enable = true;
    userName = "David Rojas Camaggi";
    userEmail = "drojascamaggi@gmail.com";
  };

  #
  # TODO: mkDerivation
  #
  # https://nixos.org/nixos/nix-pills/basic-dependencies-and-hooks.html
  #

  services.key-manager.enable = false;
  services.key-manager.github = {
    username = "drojas";
    ssh = {
      matebook = "$HOME/.ssh/id_rsa.pub";
    };
  };

  services.source-manager.enable = true;
  services.source-manager.git = {
    dotfiles = {
      remote = "git@github.com:drojas/.files.git";
      workTree = "$HOME";
      gitDir = ".files/";
      cloneFlags = "--bare";
      extraConfig = ''
          status.showUntrackedFiles no
        '';
      as = "dot";
    };
    morphic = {
      remote = "git@github.com:drojas/morphic.git";
      workTree = "$HOME/Code/morphic";
    };
  };

  home = {
    sessionVariables = {
      VISUAL = "emacsclient";
      EDITOR = "emacsclient";
      LANG = "en_US.UTF-8";
    };

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
    packages = with pkgs; [
      neofetch
      lastpass-cli
      # gnupg # TODO: figure which is better choice between this and programs.gpg
      pass
      xclip
    ];
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    # extraConfig = ''
    #   allow-emacs-pinentry
    #   allow-loopback-pinentry
    #   pinentry-program ${pkgs.pinentry}/bin/pinentry-gtk-2
    # '';
  };
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [
    "chromium"
    "firefox"
  ];

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
}
