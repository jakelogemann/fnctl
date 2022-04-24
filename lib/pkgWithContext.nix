/* Impure import is used for ad-hoc inclusion. Given only nixpkgs, it
** bootstraps all of the functions.
*/{ pkgs ? (import <nixpkgs> {}) , lib ? pkgs.lib, pkgContext ? (lib // {
    inherit (builtins) getEnv toPath readDir;
    inherit (pkgs) fetchDockerConfig fetchDockerLayer fetchipfs fetchs3;
    inherit (pkgs) fetchgitPrivate fetchgit fetchgitLocal;
    inherit (pkgs) fetchurl fetchzip fetchmail fetchpatch;
    inherit (pkgs) makeDesktopItem makeAutostartItem makeFontsCache;
    inherit (pkgs) makeSetupHook makeDBusConf;
    inherit (pkgs) mkShell requireFile;
    inherit (pkgs) runCommand runCommandNoCC runCommandCC;
    inherit (pkgs) stdenv newScope buildEnv;
    inherit (pkgs) symlinkJoin linkFarm copyPathsToStore copyPathToStore;
    inherit (pkgs) writeScript writeScriptBin writeShellScriptBin;
    inherit (pkgs) writeText writeTextDir writeTextFile;
    inherit pkgs lib; })
, ... }:

pkgPath: 

lib.callPackageWith (pkgContext // {
  # Redundant definiton of this function is unfortunately necessary. Or I'm
  # tired.
  pkgWithContext = pkgPath: lib.callPackageWith pkgContext pkgPath;
}) pkgPath

