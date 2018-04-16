{ config, pkgs, ... }:
let
  keymap = pkgs.writeText "keymap.xkb" ''
      xkb_keymap {
        xkb_keycodes  { include "evdev+aliases(qwerty)"  };
        xkb_types     { include "complete"	};
        xkb_compat    { include "complete"	};
        xkb_symbols   {
          include "pc+us+inet(evdev)+ctrl(nocaps)"
          key <TAB> { [ Escape ] };
          key <ESC> { [ Tab, ISO_Left_Tab ] };
        };
        xkb_geometry  { include "pc(pc104)"	};
      };
    '';
in
{

  boot.cleanTmpDir = true;

  security.sudo.wheelNeedsPassword = false;
  security.wrappers = { slock = { source = "${pkgs.slock}/bin/slock"; }; };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  hardware = {
    enableAllFirmware = true;
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
  };

  services = {
    timesyncd.enable = true;
    printing.enable = true;
    openssh = {
      enable = true;
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
    offlineimap = {
      install = true;
      enable = true;
      path = [ pkgs.python pkgs.gnupg pkgs.pass pkgs.bash ];
      onCalendar = "*:0/2";
    };
    compton = {
      enable = true;
      fade = true;
      shadow = true;
      fadeDelta = 4;
      extraOptions = ''
        clear-shadow = true;
        no-dock-shadow = true;
      '';
    };
    redshift = {
      enable = true;
      latitude = "41.9";
      longitude = "-87.6";
    };
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "ctrl:nocaps";
      exportConfiguration = true;
      windowManager = {
        default = "xmonad";
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };

      # map escape key to tab
      displayManager.sessionCommands = ''
        ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${keymap} $DISPLAY
      '';
      displayManager.slim = {
        enable = true;
        theme = pkgs.fetchurl {
          url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
          sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
        };
      };
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig.ultimate.enable = true;
    fonts = with pkgs; [
      corefonts
      inconsolata
      hasklig
      fira-code
      powerline-fonts
      ttf_bitstream_vera
      dejavu_fonts
      nerdfonts
      vistafonts
      terminus_font
    ];
  };

  programs = {
    vim.defaultEditor = true;
    gnupg.agent.enable = true;
    tmux = {
      enable = true;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "af-magic";
        plugins = [
          "common-aliases"
          "compleat"
          "cabal"
          "git"
          "git-extras"
          "sudo"
          "systemd"
          "tmux"
          "tmuxinator"
          "vi-mode"
          "dirhistory"
          "dirpersisthistory"
          "zsh-autosuggestions"
          "colored-man-pages"
          "colorize"
          "pass"
        ];
      };
      shellInit = ''
        unsetopt beep
      '';
      interactiveShellInit = ''
        export HISTSIZE=1000
        export SAVEHIST=50000
        export KEYTIMEOUT=10
        setopt autocd extended_glob
        setopt hist_ignore_space
        setopt hist_ignore_dups
        unsetopt share_history
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    slim slock albert

    # cli
    kitty zsh tmuxinator
    htop xclip wget tree
    feh jq weechat hledger
    neomutt msmtp notmuch notmuch-mutt
    pass gnupg scrot zip
    unzip alsaUtils
    ranger texlive.combined.scheme-basic
    rubber w3m

    git nodejs gnumake cabal2nix
    dmenu firefox spotify
    slack zathura xorg.xkbcomp
    signal-desktop

    (pkgs.haskell.packages.ghc822.ghcWithPackages (self : [
      self.cabal-install
      self.cabal-helper
      self.xmobar
      self.yeganesh
      self.ghc
     ]))
  ];

  environment.etc."X11/keymap.xkb".source = keymap;

  system.stateVersion = "18.03";
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;

}
