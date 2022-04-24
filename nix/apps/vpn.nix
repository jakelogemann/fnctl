self: system:
with (self.lib.pkgsForSystem' system);
  self.lib.mkApp {
    drv = writeShellApplication {
      name = "vpn";
      runtimeInputs = [openconnect];
      text = ''
        set -x; exec ${lib.getExe openconnect} \
          --passwd-on-stdin  \
          --background  \
          --protocol=gp  \
          --non-inter \
          --csd-wrapper=${openconnect}/libexec/openconnect/hipreport.sh \
          -F _login:user="$USER" \
          -F _challenge:passwd=1 \
          "$@"
        '';
    };
  }
