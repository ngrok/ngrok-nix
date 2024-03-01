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
    url = "https://github.com/ngrok/ngrok-nix";
    rev = "c56189898f263153a2a16775ea2b871084a4efb0";
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
    ngrok.url = "github:ngrok/ngrok-nix";
  };

  outputs = { self, ngrok, ... }@inputs: {
    nixosConfigurations."<YOUR_HOSTNAME>" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ngrok.nixosModules.ngrok
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;
          services.ngrok = {
            enable = true;
            extraConfig = {
              authtoken = "<YOUR_AUTHTOKEN>";
            };
            tunnels = {
              # ...
            };
          };
        })
      ];
    };
  };
}
```
