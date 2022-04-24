self: system: with (self.lib.pkgsForSystem system);
runCommand "sanity" {} "test '0' -eq '0' && touch $out"
