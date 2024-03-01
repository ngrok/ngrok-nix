ngrok-nix
=========

Run ngrok as a service on your NixOS machine

configuration.nix
---------

When using `configuration.nix` you can include ngrok service as follows:

```nix
{ pkgs, config, ... }:
let
  ngrok = builtins.fetchGit {
  };
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    "${ngrok}/nixos.nix"
  ];
  services.ngrok = {
    enable = true;
    extraConfig = {
      authtoken = "<YOUR_AUTHTOKEN>";
    };
    tunnels = {
      # ...
    };
  };
}
```

flake.nix
---------

With flakes, this are even easier:

```nix
{
  inputs = {
# ...
    ngrok.url = "github:ngrok/ngrok-nix";
# ...
  };
}
```
