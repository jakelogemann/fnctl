{ pkgs, buildEnv, ... }:  

buildEnv {
  name = "gui-wrappers";
  meta.description = "custom i3-gaps wrapper scripts";
  meta.homepage = "https://github.com/lgmn-io/dandruff.git";
  meta.priority = -502;
  meta.maintainers = with pkgs.lib.maintainers; [ jakelogemann ];
  pathsToLink      = ["/bin"];
  ignoreCollisions = true;
  paths = (with pkgs; [

    (writeShellScriptBin "terminal.sh" ''
        exec ${alacritty}/bin/alacritty $@
    '')

    (writeShellScriptBin "redshift.sh" ''
        pgrep redshift | xargs -rn1 kill -9
        exec ${redshift}/bin/redshift -o -x; sleep 3; ${redshift}/bin/redshift -m randr -b '1.0:0.75' -l '42.99:-71.46' -t '6250:4500'
    '')

    (writeShellScriptBin "compton.sh" ''
        pgrep compton | xargs -rn1 kill -9; sleep 3; 
        exec ${compton}/bin/compton -f -i 0.85 -e 0.85 -c -D7 -o0.85 -C -r 8
    '')

    (writeShellScriptBin "feh.sh" ''
        pgrep feh | xargs -rn1 kill -9; sleep 3; 
        exec ${feh}/bin/feh --no-fehbg --bg-fill ${./background.jpg}
    '')

    (writeShellScriptBin "feh.sh" ''
        pgrep dunst | xargs -rn1 kill -9; sleep 3;
        exec ${dunst}/bin/dunst -config /etc/i3/dunstrc
    '')

    (writeShellScriptBin "rofi.sh" ''
        exec ${rofi}/bin/rofi $@
    '')

    (writeShellScriptBin "filemanager.sh" ''
        exec ${alacritty}/bin/alacritty -e ${ranger}/bin/ranger $@
    '')

  ]);
}
