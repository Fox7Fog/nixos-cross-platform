# Intel-specific Hyprland configuration
{ config, lib, pkgs, ... }:

{
  # Enable OpenGL with Intel drivers
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # VAAPI
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Environment variables for Intel GPU
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Use Intel's media driver
    VDPAU_DRIVER = "va_gl"; # Hardware video acceleration
  };
}
