{ inputs }:

{
  unstable = import ./unstable.nix { inherit inputs; };
  custom = import ./custom.nix { inherit inputs; };
}
