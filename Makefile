all: nixos-options.md

nixos-options.md: flake.lock *.nix
	nix run .#write-module-docs -- nixos-options.md
