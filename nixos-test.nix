{ pkgs, ngrokModule }:
pkgs.nixosTest {
  name = "ngrok-module";
  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ngrokModule
    ];

    services.ngrok = {
      enable = true;
      authtoken = "test12";
      tunnels = {
        test = {
          proto = "http";
          addr = "1234";
        };
      };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "22.05";
  };
  testScript = { nodes, ... }: ''
    machine.wait_for_unit("ngrok.service")
  '';
}
