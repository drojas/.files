{ lib, config, ... }:

with lib;

let
  cfg = config.projects;
in {
  options.projects = {
    enable = mkEnableOption "projects";
    git = mkOption {
      type = types.loaOf (types.submodule {
        options = {
          remote = mkOption {
            type = types.str;
            example = "git@github.com:<account>/<repository>.git";
          };
          as = mkOption {
            type = types.str;
            description = ''
              Name of git wrapper that will be added to $HOME/bin.

              This binary is useful for configuring dotfiles
              and executing git commands in multiple repositories
              from the same script or terminal

              Why an executable instead of just an alias?
              Executables are accessible on any terminal
              while aliases require definitions in application-specific
              configurations.
            '';
          };
          workDir = mkOption {
            type = types.string;
            default = "";
            example = "$HOME/Code";
          };
          workTree = mkOption {
            type = types.string;
            example = "my-repository-dirname";
          };
          gitDir = mkOption {
            type = types.string;
            example = "my-repository-dirname";
          };
          cloneFlags = mkOption {
            type = types.str;
            example = "--bare";
          };
          extraConfig = mkOption {
            type = types.lines;
            example = ''
              user.email "email"@example.com"
              user.name "John Doe"
            '';
          };
        };
      });
    };
  };

  # todo: install hook to keep hashes updated

  config = {
    # source - http://news.ycombinator.com/item?id=11070797
    home.activation = mapAttrs' (name: value: nameValuePair name (config.lib.dag.entryAfter ["writeBoundary"] (
      let
        workDir = if value.workDir != "" then "-C ${value.workDir}" else "";
        gitDir = "--git-dir=${value.gitDir}";
        workTree = "--work-tree=${value.workTree}";
        # status = "$DRY_RUN_CMD git ${workDir} ${gitDir} ${workTree} status --porcelain";
        clone = "$DRY_RUN_CMD git clone ${value.cloneFlags} ${value.remote} ${value.gitDir}";
        checkout = "$DRY_RUN_CMD git ${workDir} ${gitDir} ${workTree} checkout";
        config = (l: "$DRY_RUN_CMD git --git-dir=${value.gitDir} --work-tree=${value.workTree} config ${l}");
        extraConfig = foldl (a: l:
          ''${a}
            ${if l != "" then (config l) else ""}
          '') "" (splitString "\n" value.extraConfig);
      in ''
           ${clone} 2>/dev/null || true
           ${checkout}
           ${extraConfig}
         ''
    ))) cfg.git;
  };
}
