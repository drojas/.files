self: super:
{

  # Environment for nixops
  nixops-env = super.buildEnv {
    name = "nixopsEnv";
    paths = with super.pkgs; [ nixops ];
  };

  # Environment for inklings
  inklings-env = super.buildEnv {
    name = "inklingsEnv";
    paths = with super.pkgs; [ pgcli openjdk leiningen ];
  };

  # Environment for clojure
  clojure-env = super.buildEnv {
    name = "inklingsEnv";
    paths = with super.pkgs; [ openjdk leiningen ];
  };

  # myHaskellEnv =
  #   super.haskellPackages.ghcWithHoogle
  #         (haskellPackages: with haskellPackages; [
  #           # libraries
  #           xmonad
  #           xmonad-contrib
  #           xmonad-extras
  #           # tools
  #           cabal-install
  #         ]);


  # haskell-env = self.buildEnv {
  #     name = "haskell-environment";
  #     paths = with self; [
  #       #cabal2nix
  #       #ctags
  #       #cachix
  #       #haskellPackages.xmonad
  #       #haskell.compiler.ghc863Binary
  #       stack
  #       myHaskellEnv
  #       #cabal-install
  #       (import (builtins.fetchTarball https://github.com/domenkozar/hie-nix/tarball/master ) {}).hie86
  #     ];
  # };

}

