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
      docs = pkgs.callPackage ./gen-module-docs.nix {
        modules = [ self.nixosModules.ngrok ];
      };
    in
    {
      packages.write-nixos-docs = pkgs.writeShellScriptBin "write-nixos-docs" ''
        cp ${docs} "$1"
      '';
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.gnumake
        ];
      };
    }) // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = (p: builtins.elem (lib.getName p) [
          "ngrok"
        ]);
      };
      lib = nixpkgs.lib;
    in
    {
      hydraJobs = self.packages.${system} // {
        test-nixos-module = (import ./nixos-test.nix {
          inherit pkgs;
          ngrokModule = self.nixosModules.ngrok;
        });
      };
    });
}
