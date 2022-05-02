{ 
  name ? (with builtins; head (split "\n" (readFile /etc/hostname))),
  pwd ? builtins.getEnv "PWD",
  flake ? builtins.getFlake pwd,
  self ? flake.outputs.nixosConfigurations."${name}",
  ...
}@args: 

(args // { 
  inherit self args flake; 
  inherit (flake) inputs outputs;
  inherit (self) config options pkgs;
  inherit (self.pkgs) lib;
})
