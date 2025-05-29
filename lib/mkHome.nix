{ inputs, outputs, lib }:

{ username, system, pkgs, desktop ? null }:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit inputs outputs desktop; };
  modules = [
    ../home/profiles/${username}
  ];
}
