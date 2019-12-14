{ config, pkgs, ... }:
let
  lockCmd = "xlock -mode blank -erasedelay 0";

in rec {

  imports = with builtins;
    map (name: ./configurations + "/${name}") (attrNames (readDir ./configurations));

  nixpkgs.config.allowUnfree = true;


  home.username = "david";
  home.homeDirectory = "/home/david";

  home.packages = with pkgs; [
    htop
    kitty # terminal emulator
    xclip
    hledger # cli accounting
    hledger-ui
    hledger-web
    pass
    scrot # screenshots
    zip
    unzip
    alsaUtils
    spotify
    ranger # cli file manager
    slack
    zathura # pdf viewer
    signal-desktop
    gvfs
    albert # menu
    insomnia
    xlockmore
    copyq
    gnupg
    inotify-tools
    fzy
    ripgrep
    #sqlpackage
    #fsharp10
    #msbuild
  ];


  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    firefox.enable = true;
    feh.enable = true;
    direnv.enable = true;
    direnv.enableZshIntegration = true;
    fzf.enable = true;

    # tmux = {
    #   enable = true;
    #   tmuxinator.enable = true;
    # };
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      #defaultKeymap = "vicmd";
      dotDir = ".config/zsh";
      history.share = false;
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" "sudo" "colorize" "colored-man-pages" ];
      oh-my-zsh.theme = "bira";
      shellAliases = {
        ".." = "cd ..";
        "ll" = "ls -l";
        # "mux" = "tmuxinator";
        "dot" = "git --git-dir=$HOME/.files/ --work-tree=$HOME";
        "r" = "ranger";
        # diff two files in a terminal
        "d" = "kitty +kitten diff";
        # do git diff in a termial
        "gd" = "git difftool --no-symlinks --dir-diff";
      };
      initExtra = builtins.readFile ../zsh/zshrc;
    };
    #bash = {
    #  enable = true;
    #  enableAutojump = true;
    #  historyControl = [ "ignoredups" "erasedups" ];
    #  historyIgnore = [ "ls" "cd" "exit" ];
    #  profileExtra = "if [ -f ~/.bashrc ]; then\n . ~/.bashrc\n fi";
    #  shellAliases = {
    #    ".." = "cd ..";
    #    "ll" = "ls -l";
    #    "mux" = "tmuxinator";
    #    "dot" = "git --git-dir=$HOME/.files/ --work-tree=$HOME";
    #    "r" = "ranger";
    #    # diff two files in a terminal
    #    "d" = "kitty +kitten diff";
    #    # do git diff in a termial
    #    "gd" = "git difftool --no-symlinks --dir-diff";
    #  };
    #  initExtra = builtins.readFile ../bash/bashrc;
    #};

    autorandr = {
     enable = true;
     profiles = {
       "laptop" = {
         fingerprint = {
           eDP1 = "00ffffffffffff0028892a4200000000001b0104a51d147803de50a3544c99260f505400000001010101010101010101010101010101b798b8a0b0d03e700820080c25c41000001ab798b8a0b0d041720820080c25c41000001a000000fe004a444920202020202020202020000000fe004c504d3133394d3432324120200039";
         };
         config = {
           eDP1 = {
             enable = true;
             mode = "3000x2000";
             rate = "60";
           };
         };
       };

       "work" = {
         fingerprint = {
           DP1 = "00ffffffffffff0010acbea0424544300f1c0104a5351e783ae245a8554da3260b5054a54b00714f8180a9c0a940d1c0e100d10001014dd000a0f0703e803e3035000f282100001a000000ff0035394a4a34383442304445420a000000fc0044454c4c205032343135510a20000000fd001d4c1e8c36000a202020202020012902031df150101f200514041312110302161507060123091f0783010000565e00a0a0a02950302035000f282100001a023a801871382d40582c25000f282100001e011d007251d01e206e2855000f282100001ea36600a0f0701f80302035000f282100001a0000000000000000000000000000000000000000000000000000eb";
           eDP1 = "00ffffffffffff0028892a4200000000001b0104a51d147803de50a3544c99260f505400000001010101010101010101010101010101b798b8a0b0d03e700820080c25c41000001ab798b8a0b0d041720820080c25c41000001a000000fe004a444920202020202020202020000000fe004c504d3133394d3432324120200039";
         };
         config = {
           eDP1 = {
             enable = false;
           };
           DP1 = {
             mode = "3840x2160";
             rate = "60";
           };
         };
       };

       "5k2k" = {
         fingerprint = {
            DP-0 = "00ffffffffffff001e6d2077a53c0200021d0104b55021789e09c1ae5044af260e50542108007140818081c0a9c0d1c0810001010101e77c70a0d0a0295030203a00204a3100001a9d6770a0d0a0225030203a00204a3100001a000000fd00303d1e874c000a202020202020000000fc004c472048445220354b0a20202002e50203197144900403012309070783010000e305c000e30605014dd000a0f0703e803020650c204a3100001a286800a0f0703e800890650c204a3100001a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e37012790300030028701d0186ff136801188060006f083d002f000800b88e0086ff136801188060006f083d002f000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ab90";
         };
         config = {
           DP-0 = {
             enable = true;
             mode = "5120x2160";
             rate = "60.00";
           };
         };
       };

       "4k" = {
         fingerprint = {
            DP-2 = "00ffffffffffff0028892a4200000000001b0104a51d147803de50a3544c99260f505400000001010101010101010101010101010101b798b8a0b0d03e700820080c25c41000001ab798b8a0b0d041720820080c25c41000001a000000fe004a444920202020202020202020000000fe004c504d3133394d3432324120200039";
         };
         config = {
           DP-2 = {
             enable = true;
             mode = "3840x2160";
             rate = "60";
           };
         };
       };
     };
     hooks.postswitch = {
       "restart-xmonad" = "xmonad --restart";
       "kill-albert" = "pkill albert";
       "change-background" = "${pkgs.feh}/bin/feh --bg-fill -z ~/photo/wallpaper";
       "change-dpi" = ''
          case "$AUTORANDR_CURRENT_PROFILE" in
            laptop)
              DPI=170
              ;;
            4k)
              DPI=135
              ;;
            5k2k)
              DPI=133
              ;;
            work)
              DPI=135
              ;;
            *)
              echo "Unknown profle: $AUTORANDR_CURRENT_PROFILE"
              exit 1
          esac

          echo "Xft.dpi: $DPI" | ${pkgs.xorg.xrdb}/bin/xrdb -merge
        '';
      };
    };
    git = {
      enable = true;
      userName = "Dmitriy Tadyshev";
      userEmail = "dmitriy@tadyshev.com";
      signing.key = "3762F98A01D3E704C1CCCF5F2605552C1DF82E49";
      signing.signByDefault = true;
      extraConfig=''
        [diff]
            tool = kitty
            guitool = kitty.gui
        [difftool]
            prompt = false
            trustExitCode = true
        [difftool "kitty"]
            cmd = kitty +kitten diff $LOCAL $REMOTE
        [difftool "kitty.gui"]
            cmd = kitty kitty +kitten diff $LOCAL $REMOTE
      '';
    };
  };

  xsession = {
      enable = true;
      preferStatusNotifierItems = true;
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmobar
        ];
        config = pkgs.runCommand "xmonad.hs" {
          lockCmd = lockCmd;
          xmobar = "${pkgs.haskellPackages.xmobar}/bin/xmobar";
          albert = "${pkgs.albert}/bin/albert";
          } ''
            substituteAll ${~/.config/xmonad/xmonad.hs} $out
          '';
      };
      pointerCursor = {
        package = pkgs.paper-icon-theme;
        name = "Paper";
        size = 24;
      };
      initExtra = ''
        autorandr -c
      '';
  };

  services = {
    #openssh = {
    #  enable = true;
    #  permitRootLogin = "no";
    #  passwordAuthentication = false;
    #  ports = [ 22 2222 ];
    #};

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    screen-locker = {
      enable = true;
      lockCmd = lockCmd;
    };

    compton = {
      enable = true;
      fade = false;
      shadow = true;
      fadeDelta = 4;
      extraOptions = ''
        no-dock-shadow = true;
      '';
    };

    redshift = {
      enable = true;
      latitude = "37.8";
      longitude = "122.4";
    };
  };

  # home.file = {
    # ".tmux.conf".source = ../tmux/tmux.conf;
    # ".tmuxinator".source = ../tmuxinator;
  # };
}
