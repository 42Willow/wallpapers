with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "wallppuccin";

  # fetchFromGitHub is a build support function that fetches a GitHub
  # repository and extracts into a directory; so we can use it
  # fetchFromGithub is actually a derivation itself :)
  src = ../wallpapers;
  # the src can also be a local folder, like:
  # src = /home/sam/my-site;

  # This overrides the shell code that is run during the installPhase.
  # By default; this runs `make install`.
  # The install phase will fail if there is no makefile; so it is the
  # best choice to replace with our custom code.

  installPhase = ''
    mkdir -p $out/bin
    
    # for each wallpaper in the images folder, convert it with lutgen
    for i in $src/wallpapers/images/*/**; do
      # ${pkgs.lutgen}/bin/lutgen apply -p catppuccin-macchiato $i -o $out/bin/$(basename $i)
      cp -r $i $out/bin/$(basename $i).original
    done
  '';
}
