## services\.ngrok\.enable



Whether to enable ngrok service\.



*Type:*
boolean



*Default:*
` false `



*Example:*
` true `



## services\.ngrok\.configFileVersion

The version of the ngrok config file\. See [ngrok Agent Configuration File](https://ngrok\.com/docs/agent/config/)\.



*Type:*
integer between 2 and 3 (both inclusive)



*Default:*
` 3 `



## services\.ngrok\.endpoints



This is a list of endpoint definitions\. See [Endpoint Definitions](https://ngrok\.com/docs/agent/config/v3/\#endpoint-definitions) for more details\.



*Type:*
list of (attribute set)



*Default:*
` [ ] `



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



## services\.ngrok\.group



Group which runs the ngrok agent\.



*Type:*
string



*Default:*
` "ngrok" `



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



\[Deprecated: Use endpoints instead] This is a map of names to tunnel definitions\. See [tunnel-configurations](https://ngrok\.com/docs/agent/config/\#tunnel-configurations) for more details\.



*Type:*
attribute set



*Default:*
` { } `



## services\.ngrok\.user



User which runs the ngrok agent\.



*Type:*
string



*Default:*
` "ngrok" `


