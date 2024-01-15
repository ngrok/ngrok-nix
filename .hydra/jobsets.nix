{ pulls }:
with builtins;
let
  defaults = {
    type = 1;
    enabled = 1;
    hidden = false;
    keepnr = 0;
    schedulingshares = 1;
    checkinterval = 600;
    enableemail = false;
    emailoverride = "";
    inputs = {
      foo = {
        type = "string";
        value = "bar";
        emailresponsible = false;
      };
    };
  };
  pr_data = fromJSON (readFile pulls);
  makePr = num: info: {
    name = "ngrok-nix-pr-${num}";
    value = defaults // {
      description = "PR ${num}: ${info.title}";
      flake = "git+ssh://git@github.com/ngrok/ngrok-nix?ref=${info.head.ref}";
    };
  };
  mapAttrsToList =
    # A function, given an attribute's name and value, returns a new value.
    f:
    # Attribute set to map over.
    attrs:
    map (name: f name attrs.${name}) (attrNames attrs);
  pull_requests = listToAttrs (mapAttrsToList makePr pr_data);
  jobsetsAttrs = pull_requests // {
    main = defaults // {
      description = "ngrok-nix";
      flake = "git+ssh://git@github.com/ngrok/ngrok-nix";
    };
  };
  makeSpec = contents: derivation {
    name = "spec.json";
    system = "x86_64-linux";
    preferLocalBuild = true;
    allowSubstitutes = false;
    builder = "/bin/sh";
    args = [
      (toFile "builder.sh" ''
        echo "$contents" > $out
      '')
    ];
    contents = toJSON contents;
  };
in
{
  jobsets = makeSpec jobsetsAttrs;
}
