{ lib
, pkgs
, nixosOptionsDoc
, modules
}:
with lib;
with builtins;
let
  eval = lib.evalModules {
    modules = map
      (m: { pkgs ? pkgs, ... }@args: {
        options = (m args).options;
      })
      modules;
  };
  optionsDoc = nixosOptionsDoc
    {
      inherit (eval) options;
    };
in
pkgs.runCommand "options-doc.md" { } ''
  cat ${optionsDoc.optionsCommonMark} >> $out
''
