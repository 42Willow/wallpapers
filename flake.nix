{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, ... }:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; };
    in {
      # packages = forAllSystems (system: {
      #   default = packages.${system}.callPackage ./nix {};
      # });
      packages.default = pkgs.callPackage ./nix { };

      # devShells = forAllSystems (system: {
      #   default = pkgsForEach.${system}.callPackage ./nix/shell.nix {};
      # });

      # nixosModules.default = import ./nix/module.nix inputs;
    });
}
