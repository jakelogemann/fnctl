{ readDir, mapAttrs }:
# Converting a Directory to an Attrset
#
# If we have a directory full of files, we might want to access them in Nix,
# whilst maintaining their directory hierarchy. We can represent files using
# their paths and directories using "attribute sets" (both of which can be nested).
#
# We can use these attribute sets however we like, e.g. importing the
# files, putting them in derivations, etc. If we give a path value, the
# files will be added to the Nix store (this is good for reproducibility):
#
# > toJSON (dirToAttrs ./modules)
#
# {
#   "bar.nix": "/nix/store/nrcaxv07q84xrfgw3y7lh7bclw0vk85w-bar.nix",
#   "baz.nix": "/nix/store/wrf067305zzkhm3wicyibk10g7iqqwdk-baz.nix",
#   "foo.nix": "/nix/store/1w1115h7lvzfzaqla19sy7aqsqy5mvsm-foo.nix",
#   "notANixFile.txt": "/nix/store/hi7inqg5sbh2bk2i1irggypa48xiaj9f-notANixFile.txt"
# }
#
# We might prefer the hierarchy to be preserved in the store, which we can
# do by coercing our path to a string:
#
# > toJSON (dirToAttrs "${./modules}")
#
# {
#   "bar.nix": "/nix/store/1rkzbs7057sndsjxc7nw5gb5kbmkvdna-modules/bar.nix",
#   "baz.nix": "/nix/store/1rkzbs7057sndsjxc7nw5gb5kbmkvdna-modules/baz.nix",
#   "foo.nix": "/nix/store/1rkzbs7057sndsjxc7nw5gb5kbmkvdna-modules/foo.nix",
#   "notANixFile.txt": "/nix/store/1rkzbs7057sndsjxc7nw5gb5kbmkvdna-modules/notANixFile.txt"
# }
#
# If we convert with toString, the path will be used as-is (this is good if
# we have relative paths, symlinks, etc.):
#
# > toJSON (dirToAttrs (toString ./modules))
#
# {
#   "bar.nix": "/tmp/nix-build-useful_hacks.html.drv-0/panpipe4790/modules/bar.nix",
#   "baz.nix": "/tmp/nix-build-useful_hacks.html.drv-0/panpipe4790/modules/baz.nix",
#   "foo.nix": "/tmp/nix-build-useful_hacks.html.drv-0/panpipe4790/modules/foo.nix",
#   "notANixFile.txt": "/tmp/nix-build-useful_hacks.html.drv-0/panpipe4790/modules/notANixFile.txt"
# }
#
targetDir:

let
  dirToAttrs' = aDir: mapAttrs mapFunc (readDir aDir);

  mapFunc = n: v:
    if v == "regular" || v == "symlink" then targetDir + "/${n}"
    else dirToAttrs' (targetDir + "/${n}");

in dirToAttrs' targetDir
