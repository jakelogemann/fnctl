{
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation rec {
  pname = "fnctl-icons";
  version = "2022.06.28";
  src = builtins.path {
    path = ./src;
    filter = path': type': (builtins.any (ext: lib.hasSuffix ".${ext}" path') ["png" "svg"]);
  };
  installPhase = ''
    dst=$out/share/icons/fnctl
    mkdir -vp "$dst" && cp -vr "$(pwd)" "$dst"
  '';
}
