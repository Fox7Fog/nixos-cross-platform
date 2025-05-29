{ inputs, outputs }:

let
  inherit (inputs.nixpkgs) lib;
in {
  mkNixosSystem = import ./mkNixosSystem.nix { inherit inputs outputs lib; };
  mkDarwinSystem = import ./mkDarwinSystem.nix { inherit inputs outputs lib; };
  mkHome = import ./mkHome.nix { inherit inputs outputs lib; };
}
