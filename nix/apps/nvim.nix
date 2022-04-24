self: system:
with (self.lib.pkgsForSystem' system);
  self.lib.mkApp {
    drv = fnctl.AstroNvim;
  }
