{ pkgs, ... }:

pkgs.buildEnv {
  name    = "fnctl-userland";
  meta = with pkgs.lib; {
    description = "extended coreutils package set.";
    homepage    = "https://github.com/fnctl/nix.git";
    license     = licenses.mit;
    maintainers = [ maintainers.jakelogemann ];
    platforms   = platforms.linux;
    priority    = -502;
  };

  pathsToLink      = ["/bin"];
  ignoreCollisions = true;
  paths = (pkgs.callPackage ./pkgs.nix {});
}
