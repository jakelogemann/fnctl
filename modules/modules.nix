{
    digitalocean = import ./digitalocean/digitalocean.nix;
    fnctl = import ./fnctl/fnctl.nix;
    users = import ./users/users.nix;
}