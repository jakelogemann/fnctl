self: final: prev: with prev; {
  nix = nixFlakes;
  nixops = self.inputs.nixops.defaultPackage.${system};
  fnctl = self.outputs.packages.${system};
}
