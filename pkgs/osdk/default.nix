{ stdenv, buildEnv, callPackage, writeShellScriptBin, writeText, pkgs }: with pkgs.lib;
buildEnv {
  name = "osdk";
  meta = { 
    description = "OS Development Kit (OSDK)";
    homepage = "https://github.com/lgmn-io/dandruff.git";
    priority = -502;
    maintainers = with pkgs.lib.maintainers; [ jakelogemann ];
  };
  pathsToLink      = ["/bin"];
  ignoreCollisions = true;
  paths = callPackage ./pkgs.nix {};
}
