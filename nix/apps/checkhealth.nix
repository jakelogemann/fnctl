self: system:
with (self.lib.pkgsForSystem' system);
  self.lib.mkApp {
    drv = writeShellApplication {
      name = "checkhealth";
      runtimeInputs = [dogdns less];
      text = let
        checkedDomains = lib.concatStringsSep " " [
          "google.com"
          "digitalocean.com"
          "status.digitalocean.com"
          "cloud.digitalocean.com"
        ];
      in ''
        echo "# Should ensure its valid nixos system."
        echo "# Should check connectivity to ${checkedDomains}."
        echo "# Should check ..."
        echo "# Should check ..."
        echo "# Should check ..."
        echo "# Should check ..."
        echo "# Should check ..."
        echo "# Should check ..."
        echo "# Should check ..."
      '';
    };
  }
