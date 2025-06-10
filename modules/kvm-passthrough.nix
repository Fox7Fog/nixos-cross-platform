{ config, pkgs, lib, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.qemu.package = pkgs.qemu_kvm;
  virtualisation.qemu.swtpm.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  users.groups.libvirtd.members = [ "fox7fog" ];

  # Enable KVM and IOMMU for hardware passthrough
  boot.kernelModules = [ "kvm-intel" "vfio-pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
  boot.extraModprobeConfig = ''
    options kvm ignore_msrs=1
  '';

  # Enable IOMMU (Intel VT-d example)
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  # Example: PCI device passthrough (replace with your device IDs)
  # boot.extraKernelParams = [ "vfio-pci.ids=1234:5678,abcd:ef01" ];

  environment.systemPackages = with pkgs; [ virt-manager virt-viewer ];

  # Optionally, enable bridge networking
  networking.bridges.br0.interfaces = [ "enp3s0" ];
  networking.interfaces.br0.useDHCP = true;
}
