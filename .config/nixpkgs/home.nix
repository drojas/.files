{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };

      background_opacity = 0.95;

      window = {
        padding.x = 10;
        padding.y = 10;
        decorations = "buttonless";
      };

      font = {
        size = 12.0;
        use_thin_strokes = true;

        normal.family = "FuraCode Nerd Font";
        bold.family = "FuraCode Nerd Font";
        italic.family = "FuraCode Nerd Font";
      };

      cursor.style = "Beam";

      shell = {
        program = "${pkgs.fish}/bin/fish";
        args = [
          "-C"
          "neofetch"
        ];
      };

      colors = {
        # Default colors
        primary = {
          background = "0x1b182c";
          foreground = "0xcbe3e7";
        };

        # Normal colors
        normal = {
          black =   "0x100e23";
          red =     "0xff8080";
          green =   "0x95ffa4";
          yellow =  "0xffe9aa";
          blue =    "0x91ddff";
          magenta = "0xc991e1";
          cyan =    "0xaaffe4";
          white =   "0xcbe3e7";
        };

        # Bright colors
        bright = {
          black =   "0x565575";
          red =     "0xff5458";
          green =   "0x62d196";
          yellow =  "0xffb378";
          blue =    "0x65b2ff";
          magenta = "0x906cff";
          cyan =    "0x63f2f1";
          white = "0xa6b3cc";
        };
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      "dot" = "git --git-dir=$HOME/.files/ --work-tree=$HOME";
    };
  };

  programs.emacs = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    enableIcedTea = true;
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.git = {
    enable = true;
    userName = "David Rojas Camaggi";
    userEmail = "drojascamaggi@gmail.com";
  };

  home.file = {
    ".emacs.d" = {
      source = fetchFromGitHub {
        owner = "syl20bnr";
        repo = "spacemacs";
        rev = "3f559a4233815c6129f9ad593d5dee9fff199a1c";
        sha256 = "1x0s5xlwhajgnlnb9mk0mnabhvhsf97xk05x79rdcxwmf041h3fd";
      };
      recursive = true;
    };
  };
};
