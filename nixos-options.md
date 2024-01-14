## _module\.args

Additional arguments passed to each module in addition to ones
like ` lib `, ` config `,
and ` pkgs `, ` modulesPath `\.

This option is also available to all submodules\. Submodules do not
inherit args from their parent module, nor do they provide args to
their parent module or sibling submodules\. The sole exception to
this is the argument ` name ` which is provided by
parent modules to a submodule and contains the attribute name
the submodule is bound to, or a unique generated name if it is
not bound to an attribute\.

Some arguments are already passed by default, of which the
following *cannot* be changed with this option:

 - ` lib `: The nixpkgs library\.

 - ` config `: The results of all options after merging the values from all modules together\.

 - ` options `: The options declared in all modules\.

 - ` specialArgs `: The ` specialArgs ` argument passed to ` evalModules `\.

 - All attributes of ` specialArgs `
   
   Whereas option values can generally depend on other option values
   thanks to laziness, this does not apply to ` imports `, which
   must be computed statically before anything else\.
   
   For this reason, callers of the module system can provide ` specialArgs `
   which are available during import resolution\.
   
   For NixOS, ` specialArgs ` includes
   ` modulesPath `, which allows you to import
   extra modules from the nixpkgs package tree without having to
   somehow make the module aware of the location of the
   ` nixpkgs ` or NixOS directories\.
   
   ```
   { modulesPath, ... }: {
     imports = [
       (modulesPath + "/profiles/minimal.nix")
     ];
   }
   ```

For NixOS, the default value for this option includes at least this argument:

 - ` pkgs `: The nixpkgs package set according to
   the ` nixpkgs.pkgs ` option\.



*Type:*
lazy attribute set of raw value

*Declared by:*
 - [\<nixpkgs/lib/modules\.nix>](https://github.com/NixOS/nixpkgs/blob//lib/modules.nix)



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


