{
    base = import ./base.nix;
    gui = import ./gui/default.nix;
    digitalocean = import ./digitalocean/default.nix;
    jlogemann = import ./jlogemann/default.nix;
}