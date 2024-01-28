{ lib, pkgs, config, ... }:
with lib;
with builtins;
let
  cfg = config.programs.ngrok;
in
{
  options = {
    programs.ngrok = {
      enable = mkEnableOption "ngrok";

      tunnels = mkOption {
        type = with types; attrs;
        default = { };
        description = ''
          This is a map of names to tunnel definitions. See [tunnel-configurations](https://ngrok.com/docs/agent/config/#tunnel-configurations) for more details.
        '';
      };

      log = mkOption {
        type = with types; uniq str;
        default = "false";
        description = ''
          This is the destination where ngrok should write the logs.
          Possible values are `stdout`, `stdin`, `false` to disable logging, or a file path.
        '';
      };

      log_format = mkOption {
        type = with types; uniq str;
        default = "term";
        description = ''
          This is the format of written log records. Possible values are logfmt or json.
        '';
      };

      log_level = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          This is the logging level of detail. In increasing order of verbosity, possible values are: crit, warn, error, info, and debug.
        '';
      };

      extraConfig = mkOption {
        type = with types; attrs;
        default = { };
        description = ''
          Additional agent configuration. See [agent config](https://ngrok.com/docs/agent/config/) for options.
        '';
      };

      extraConfigFiles = mkOption {
        type = with types; listOf str;
        default = [ "${config.xdg.configHome}/ngrok/ngrok.yml" ];
        description = ''
          Additional configuration files placed after the declarative options. See [config file merging](https://ngrok.com/docs/agent/config/#config-file-merging) for merging details.
          Use this for sensitive configuration that shouldn't go into the nixos configuration and nix store.
        '';
      };
    };
  };
  config = mkIf cfg.enable
    {
      home.packages = with pkgs;
        let
          ngrokConfig = pkgs.writeTextFile {
            name = "ngrok-config.yml";
            text = toJSON
              ({
                inherit (cfg) tunnels log log_level log_format;
                version = "2";
              } // cfg.extraConfig);
          };
          configFiles = [ ngrokConfig ] ++ cfg.extraConfigFiles;
          configArgs = concatStringsSep " " (map (file: "--config \\\"${file}\\\"") configFiles);
          ngrokWrapped = pkgs.symlinkJoin {
            name = "ngrok-${ngrok.version}-wrapped";
            paths = [ ngrok ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/ngrok \
                --add-flags "${configArgs}"
            '';
          };
        in
        [
          ngrokWrapped
        ];
    };
}
