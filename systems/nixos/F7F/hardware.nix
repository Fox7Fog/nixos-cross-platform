{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Bootloader / kernel modules
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  # Load i915 later in the boot process to avoid Wayland cursor glitches
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  # Disable Panel Self Refresh (PSR) which is known to cause cursor issues on some Intel GPUs
  boot.kernelParams = [ "i915.enable_psr=0" ];

  # Filesystems with optimized settings

#  fileSystems."/" =
#    { device = "/dev/disk/by-uuid/c5d27bfd-1e9c-4e7a-8c0b-c10771c16084";
#      fsType = "btrfs";
#      options = [ "subvol=@" ];
#    };
#
#  fileSystems."/boot" =
#    { device = "/dev/disk/by-uuid/CAB0-777D";
#      fsType = "vfat";
#    };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = [ "subvol=@" "noatime" "compress=zstd" "space_cache=v2" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # Graphics - Hybrid Intel/NVIDIA setup
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload.enable = true;
      # GPU with outputs attached (usually Intel)
      intelBusId = "PCI:0:2:0";
      # High performance GPU (NVIDIA)
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # CPU microcode (Intel)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable NVME TRIM support
  services.fstrim.enable = true;

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
