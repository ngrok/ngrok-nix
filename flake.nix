{
  description = "nix modules for working with ngrok";

  outputs = { self, nixpkgs }: {
    nixosModules = {
      ngrok = import ./nixos.nix;
    };
  };
}
