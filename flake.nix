{
  description = ''
    Reproducible and high quality Catppuccin wallpapers.
  '';

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    inherit (nixpkgs) lib;

    genSystems = lib.genAttrs (import systems);
    pkgsFor = nixpkgs.legacyPackages;
    version = self.shortRev or "dirty";
  in {
    overlays.default = _: prev: let
      callWallpaper = style:
        prev.callPackage ./nix/builder.nix {
          inherit style version;
        };
    in rec {
      # Complete repository: larger and more varied collection.
      # Naturally, means longer build times.
      full = wallppuccin;
      wallppuccin = callWallpaper null;

      # Call individual collections by category.
      images = callWallpaper "images";
      pixel = callWallpaper "pixel";
    };

    # Generate package outputs from available overlay packages.
    packages = genSystems (system:
      (self.overlays.default null pkgsFor.${system})
      // {
        default = self.packages.${system}.wallppuccin;
      });


    formatter = genSystems (system: pkgsFor.${system}.alejandra);
  };
}