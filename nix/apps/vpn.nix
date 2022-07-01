self: system:
with (self.lib.pkgsForSystem' system);
  self.lib.mkApp {
    drv = writeShellApplication {
      name = "vpn";
      runtimeInputs = [openconnect];
      text = ''
        user="$1"; shift 1;
          set -x; exec ${lib.getExe openconnect} \
            --passwd-on-stdin  \
            --background  \
            --protocol=gp  \
            --csd-wrapper=${openconnect}/libexec/openconnect/hipreport.sh \
            -F _login:user="$user" \
            -F _challenge:passwd=1 \
            "$@"
      '';
    };
  }
