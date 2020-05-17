{
  config,
  pkgs,
  lib,
  ...
}:

with import <nixpkgs> {};

let
  dotSrc = fetchFromGitHub {
    owner = "drojas";
    repo = "dot";
    rev = "63a7599359371906f182620688e10e24291e4612";
    sha256 = "1sgbslzd7xlr076lsddc8ds085xlhg949qvz6br6wnrx4xf05qrb";
    fetchSubmodules = true;
  };
in {
  imports = [
    "${dotSrc}/home-manager/modules/programs/dot.nix"
  ];
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  nixpkgs.config  = (import ./config.nix);

  programs.home-manager.enable = true;
  programs.dot.enable = true;

  services.random-background = {
    enable = true;
    # display = "center";
    # imageDirectory = "${(builtins.fetchTarball {
    #   url = http://github.com/NixOS/nixos-artwork/archive/master.tar.gz;
    # })}/wallpapers";
    imageDirectory = "%h/backgrounds";
    interval = "1m";
  };

  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 64;
  };

  # TODO: add services at init
  # programs.treehouse.enable = true;
  # programs.treehouse.servers."api.example.com" = {
  #   "GET /hello/:name" = let
  #     src = writeScript "greeter" ''
  #       #!/usr/bin/env bash

  #       echo "Hello $1!"
  #     '';
  #   in callPackage (builtins.mkDerivation {
  #     pname = "greeter";
  #     version = "0.0.0";
  #     phases = "installPhase fixupPhase";
  #     installPhase = ''
  #       mkdir -p $out/bin
  #       cp ${src} $out/.wrapped
  #       chmod +x $out/.wrapped
  #       makeWrapper $out/.wrapped $out/bin/dot --prefix PATH : ${ gitPath }
  #     '';
  #     src = src;
  #     nativeBuildInputs = [ makeWrapper ];
  #   }) {};
  # };

  programs.fish = {
    enable = true;
    shellAliases = {
      "pbcopy" = "xclip -selection clipboard";
      "pbpaste" = "xclip -selection clipboard -o";
      # "k" = "sudo kubectl";
      # "h" = "sudo helm";
    };
    # TODO: move to dotfiles?
    shellInit =
      ''
      if status is-interactive
          ${neofetch}/bin/neofetch | ${lolcat}/bin/lolcat
          ${fortune}/bin/fortune \
            | ${cowsay}/bin/cowsay \
            | ${lolcat}/bin/lolcat
          # sudo kubectl cluster-info | ${lolcat}/bin/lolcat
          dot status --porcelain | ${lolcat}/bin/lolcat
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
    package = with pkgs; emacsGit;
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
    extraConfig = {
      url = {
        "git@github.com:drojas/" = {
          insteadOf = "drojas:";
        };
        "git@github.com:drojas/morphic.git" = {
          insteadOf = "morphic:";
        };
        "git@github.com:" = {
          insteadOf = "gh:";
        };
      };
    };
  };

  #
  # TODO: mkDerivation
  #
  # https://nixos.org/nixos/nix-pills/basic-dependencies-and-hooks.html
  #

  home = {
    sessionVariables = {
      VISUAL = "emacsclient";
      EDITOR = "emacsclient";
      LANG = "en_US.UTF-8";
    };

    file = {
      ".config/konsolerc" = {
        text = ''
            [Desktop Entry]
            DefaultProfile=David.profile

            [KonsoleWindow]
            ShowMenuBarByDefault=false
            showTerminalSizeHintItem=false
          '';
      };

      ".local/share/konsole/David.profile" = {
        # Font=Source Code Pro for Powerline,10,-1,5,57,0,0,0,0,0
        text = ''
            [Appearance]
            AntiAliasFonts=true
            BoldIntense=false
            ColorScheme=Dracula
            LineSpacing=0
            Font=Source Code Pro for Powerline,10
            UseFontLineChararacters=true

            [General]
            Environment=TERM=xterm-256color
            Name=David
            Parent=FALLBACK/

            [Scrolling]
            ScrollBarPosition=2
        '';
      };

      ".local/share/konsole/Dracula.colorscheme" = {
        text = ''
            [Background]
            Color=40,42,54

            [BackgroundFaint]
            Color=40,42,54

            [BackgroundIntense]
            Color=40,42,54

            [Color0]
            Color=40,42,54

            [Color0Faint]
            Color=40,42,54

            [Color0Intense]
            Color=40,42,54

            [Color1]
            Color=255,85,85

            [Color1Faint]
            Color=255,85,85

            [Color1Intense]
            Color=255,85,85

            [Color2]
            Color=80,250,123

            [Color2Faint]
            Color=80,250,123

            [Color2Intense]
            Color=80,250,123

            [Color3]
            Color=241,250,140

            [Color3Faint]
            Color=241,250,140

            [Color3Intense]
            Color=241,250,140

            [Color4]
            Color=98,114,164

            [Color4Faint]
            Color=98,114,164

            [Color4Intense]
            Color=98,114,164

            [Color5]
            Color=255,121,198

            [Color5Faint]
            Color=255,121,198

            [Color5Intense]
            Color=255,121,198

            [Color6]
            Color=139,233,253

            [Color6Faint]
            Color=139,233,253

            [Color6Intense]
            Color=139,233,253

            [Color7]
            Color=248,248,242

            [Color7Faint]
            Color=248,248,242

            [Color7Intense]
            Color=248,248,242

            [Foreground]
            Color=248,248,242

            [ForegroundFaint]
            Color=248,248,242

            [ForegroundIntense]
            Color=248,248,242

            [General]
            Blur=false
            Description=Dracula
            Opacity=0
            Wallpaper=
        '';
        };
    };

    activation = {
      spacemacs = config.lib.dag.entryAfter [ "installPackages" ] ''
        git clone gh:syl20bnr/spacemacs ~/.emacs.d 2>.dev.null || true
      '';
      githubKeys =
        let
          username = "drojas";
          sshKeyPath = "~/.ssh/id_rsa";
        in (
          config.lib.dag.entryAfter [ "installPackages" ] ''
      #       export githubuser=${username}
      # #       echo "Using username $githubuser"
      #       read -s -p "Enter github password for user $githubuser: " githubpass
      #       $DRY_RUN_CMD curl -u "$githubuser:$githubpass" -d "{\"title\":\"`hostname`\",\"key\":\"$(cat ${sshKeyPath}.pub)\"}" https://api.github.com/user/keys
          ''
        );
      projects = config.lib.dag.entryAfter [ "githubKeys" ] ''
        dot init git@github.com:drojas/.files.git
        git clone morphic: ~/Code/morphic 2>/dev/null || true
      '';

    };

    packages = with pkgs; [
      lastpass-cli
      # gnupg # TODO: figure which is better choice between this and programs.gpg
      gopass
      xclip
      i3lock
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
  # programs.browserpass.enable = true;
  programs.browserpass.browsers = [
    "chromium"
    "firefox"
  ];

  # https://wiki.archlinux.org/index.php/HiDPI#X_Resources
  xresources = {
    properties = {
      "Xcursor.size" = 128;
      "Xft.dpi" = 170; # 259; # 276
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintfull";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
    };
    extraConfig = builtins.readFile(
      pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "xresources";
        rev = "ca0d05cf2b7e5c37104c6ad1a3f5378b72c705db";
        sha256 = "0ywkf2bzxkr45a0nmrmb2j3pp7igx6qvq6ar0kk7d5wigmkr9m5n";
      } + "/Xresources"
    );
  };
}
