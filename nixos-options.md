## services\.ngrok\.enable



Whether to enable ngrok service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## services\.ngrok\.authtoken

Your ngrok authtoken\. To avoid storing your authtoken in nix config, see the ` extraConfigFiles ` option\.



*Type:*
null or string



*Default:*
` null `



## services\.ngrok\.extraConfig



Additional agent configuration\. See [agent config](https://ngrok\.com/docs/agent/config/) for options\.



*Type:*
attribute set



*Default:*
` { } `



## services\.ngrok\.extraConfigFiles



Additional configuration files placed after the declarative options\. See [config file merging](https://ngrok\.com/docs/agent/config/\#config-file-merging) for merging details\.
Use this for sensitive configuration that shouldn’t go into the nixos configuration and nix store\.



*Type:*
list of string



*Default:*
` [ ] `



## services\.ngrok\.log_format



This is the format of written log records\. Possible values are logfmt or json\.



*Type:*
string



*Default:*
` "logfmt" `



## services\.ngrok\.log_level



This is the logging level of detail\. In increasing order of verbosity, possible values are: crit, warn, error, info, and debug\.



*Type:*
string



*Default:*
` "info" `



## services\.ngrok\.tunnels



This is a map of names to tunnel definitions\. See [tunnel-configurations](https://ngrok\.com/docs/agent/config/\#tunnel-configurations) for more details\.



*Type:*
attribute set



*Default:*
` { } `


