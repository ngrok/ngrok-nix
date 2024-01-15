all: nixos-options.md

nixos-options.md: flake.lock *.nix
	nix run .#write-nixos-docs -- nixos-options.md
