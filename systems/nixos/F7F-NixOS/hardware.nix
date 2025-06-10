{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Bootloader / kernel modules
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  # Load i915 later in the boot process to avoid Wayland cursor glitches
  boot.initrd.kernelModules = [ ];
  # Kernel modules for KVM and VFIO
  boot.kernelModules = [ 
    "kvm-intel"
    "vfio-pci"
    "vfio"
    "vfio_iommu_type1"
    "vfio_virqfd"
  ];
  boot.extraModulePackages = [ ];
  # Kernel parameters for IOMMU and graphics
  boot.kernelParams = [ 
    "i915.enable_psr=0"
    "intel_iommu=on"
    "iommu=pt"
  ];
  # KVM settings
  boot.extraModprobeConfig = ''
    options kvm ignore_msrs=1
    options kvm-intel nested=1  # Enable nested virtualization
  '';

  # Filesystems with optimized settings
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

  # Bootloader configuration for OpenCore dual-boot
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = false; # Prevent NixOS from managing UEFI boot variables
      efiSysMountPoint = "/boot";   # Explicitly set ESP mount point for bootloader
    };
  };

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
