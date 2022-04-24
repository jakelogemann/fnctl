{
  lib,
  makeWrapper,
  fzf,
  git,
  ripgrep,
  stdenv,
  writeScript,
  buildEnv,
  neovim,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "AstroNvim";
  version = "1.4.2";
  src = fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v${version}";
    sha256 = "sha256-ng70fl53H5Hbu+4k2tqjQ8F1mSfpOMLm50PJAohbpfM=";
  };
  inherit neovim;
  nativeBuildInputs = [makeWrapper neovim];
  buildInputs = [neovim];

  buildPhase = ''
    runHook preBuild
    # nvim -u $(pwd)/init.lua --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -vp $out/bin $out/share/nvim/runtime/{colors,lua,pack/packer/opt,pack/packer/start}
    cp -Lrs $neovim/share/* $out/share/
    cp -r $(pwd)/colors/* $out/share/nvim/runtime/colors/
    cp -r $(pwd)/lua/* $out/share/nvim/runtime/lua/
    cp  $(pwd)/{packer_snapshot,init.lua} $out/share/nvim/runtime/

    # trailing slash very important for NVIMDIR
    makeWrapper "${lib.getExe neovim}" "$out/bin/${pname}" \
        --add-flags "-u $out/share/nvim/runtime/init.lua" \
        --set VIM "$out/share/nvim/runtime" \
        --set VIMRUNTIME "$out/share/nvim/runtime" \
        --prefix PATH : ${lib.makeBinPath [fzf git ripgrep]}

    # Doesn't work yet, something about packer's packpath not existing...
    # $out/bin/astro-nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

    runHook postInstall
  '';
}
