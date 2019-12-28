{ lib, config, ... }:

with lib;

let
  cfg = config.services.key-manager;
in {
  options.services.key-manager = {
    enable = mkEnableOption "key-manager";
    github = mkOption {
      type = types.submodule {
        options = {
          username = mkOption {
            type = types.str;
          };
          ssh = mkOption {
            type = types.attrsOf types.str;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.activation = mapAttrs' (name: value: nameValuePair "a.ssh.github.${name}.key-manager" (
      # source: https://gist.github.com/juanique/4092969
      # alternative: https://tiborsimon.io/articles/programming/upload-ssh-key-via-github-api/
      config.lib.dag.entryAfter ["writeBoundary"] ''
        export githubuser=${cfg.github.username}
        echo "Using username ${cfg.github.username}"
        read -s -p "Enter github password for user ${cfg.github.username}: " githubpass
        $DRY_RUN_CMD curl -u "$githubuser:$githubpass" -d "{\"title\":\"`hostname`\",\"key\":\"$(cat ${value})\"}" https://api.github.com/user/keys
      ''
    )) cfg.github.ssh;
  };
}
