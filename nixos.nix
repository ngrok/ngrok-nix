{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
with builtins;
let
  cfg = config.services.ngrok;
in
{
  options = {
    services.ngrok = {
      enable = mkEnableOption "ngrok service";

      tunnels = mkOption {
        type = with types; attrs;
        default = { };
        description = ''
          [Deprecated: Use endpoints instead] This is a map of names to tunnel definitions. See [tunnel-configurations](https://ngrok.com/docs/agent/config/#tunnel-configurations) for more details.
        '';
      };

      endpoints = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
        description = ''
          This is a list of endpoint definitions. See [Endpoint Definitions](https://ngrok.com/docs/agent/config/v3/#endpoint-definitions) for more details.
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

      configFileVersion = mkOption {
        type = types.ints.between 2 3;
        default = 3;
        description = ''
          The version of the ngrok config file. See [ngrok Agent Configuration File](https://ngrok.com/docs/agent/config/).
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

      user = mkOption {
        type = types.str;
        default = "ngrok";
        description = "User which runs the ngrok agent.";
      };

      group = mkOption {
        type = types.str;
        default = "ngrok";
        description = "Group which runs the ngrok agent.";
      };
    };
  };
  config = mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      isSystemUser = true;
      home = "/var/lib/${cfg.user}";
      createHome = true;
      shell = null;
      inherit (cfg) group;
    };

    systemd.services.ngrok =
      let
        commonConfig = {
          version = "${toString cfg.configFileVersion}";

          inherit (cfg) tunnels endpoints;
        };

        v2Config =
          commonConfig
          // {
            inherit (cfg) log_level log_format;
            log = "stdout";
          }
          // cfg.extraConfig;

        v3Config =
          commonConfig
          // cfg.extraConfig
          // {
            agent = {
              inherit (cfg) log_level log_format;
              log = "stdout";
            } // (cfg.extraConfig.agent or { });
          };

        configFile = if cfg.configFileVersion == 2 then v2Config else v3Config;

        ngrokConfig = pkgs.writeTextFile {
          name = "ngrok-config";
          text = toJSON configFile;
        };
        startArg =
          if (length (attrNames cfg.tunnels) > 0 || length cfg.endpoints > 0) then "--all" else "--none";
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
          User = cfg.user;
          Group = cfg.group;
        };
      };
  };
}
