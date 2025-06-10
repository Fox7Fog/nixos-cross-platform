{ inputs }:

let
  inherit (inputs.nixpkgs) lib;
in {
  mkNixosSystem = import ./mkNixosSystem.nix { inherit inputs lib; };
  mkHome = import ./mkHome.nix { inherit inputs lib; };
}
