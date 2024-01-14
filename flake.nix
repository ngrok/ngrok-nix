{
  description = "nix modules for working with ngrok";

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: {
    nixosModules = {
      ngrok = import ./nixos.nix;
    };
  } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      docs =
        pkgs.callPackage ./gen-module-docs.nix {
          modules = [ self.nixosModules.ngrok ];
        };
    in
    {
      packages.write-module-docs = pkgs.writeShellScriptBin "write-module-docs" ''
        cp ${docs} "$1"
      '';
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.gnumake
        ];
      };
    });
}
