{ lib, pkgs, config, ... }:
with lib;
with builtins;
let
  cfg = config.services.ngrok;
in
{
  options = {
    services.ngrok = {
      enable = mkEnableOption "ngrok service";

      authtoken = mkOption {
        type = with types; uniq (nullOr str);
        default = null;
        description = ''
          Your ngrok authtoken. To avoid storing your authtoken in nix config, see the `extraConfigFiles` option.
        '';
      };

      tunnels = mkOption {
        type = with types; attrs;
        default = { };
        description = ''
          This is a map of names to tunnel definitions. See [tunnel-configurations](https://ngrok.com/docs/agent/config/#tunnel-configurations) for more details.
        '';
      };

      log_format = mkOption {
        type = with types; uniq str;
        default = "logfmt";
        description = ''
          This is the format of written log records. Possible values are logfmt or json.
        '';
      };

      log_level = mkOption {
        type = with types; uniq str;
        default = "info";
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
        default = [ ];
        description = ''
          Additional configuration files placed after the declarative options. See [config file merging](https://ngrok.com/docs/agent/config/#config-file-merging) for merging details.
          Use this for sensitive configuration that shouldn't go into the nixos configuration and nix store.
        '';
      };
    };
  };
  config = mkIf cfg.enable
    {
      users.groups = {
        ngrok = { };
      };
      users.users.ngrok = {
        isSystemUser = true;
        home = "/var/lib/ngrok";
        createHome = true;
        shell = null;
        group = "ngrok";
      };
      systemd.services.ngrok =
        let
          ngrokConfig = pkgs.writeTextFile {
            name = "ngrok-config";
            text = toJSON
              ({
                inherit (cfg) authtoken tunnels log_level log_format;
                version = "2";
                log = "stdout";
              } // cfg.extraConfig);
          };
          startArg = if length (attrNames cfg.tunnels) > 0 then "--all" else "--none";
          extraConfigs = concatStringsSep " " (map (file: "--config ${file}") cfg.extraConfigFiles);
        in
        {
          description = "The ngrok agent.";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          unitConfig = {
            StartLimitInterval = "5s";
            StartLimitBurst = "10s";
          };
          serviceConfig = {
            ExecStart = "${pkgs.ngrok}/bin/ngrok --config ${ngrokConfig} ${extraConfigs} start ${startArg}";
            Restart = "always";
            RestartSec = "15";
            User = "ngrok";
            Group = "ngrok";
          };
        };
    };
}
