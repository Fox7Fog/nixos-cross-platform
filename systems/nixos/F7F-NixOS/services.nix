{ config, pkgs, lib, ... }:

{
  # Global dark mode configuration
  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  # GTK and Qt configuration for Hyprland
  # Enable X11 forwarding
  # (removed duplicate services.xserver block)


  environment.sessionVariables = {
    # GTK Theme settings
    GTK_THEME = "Adwaita:dark";
    GTK2_RC_FILES = "${pkgs.gtk2}/share/themes/Adwaita-dark/gtk-2.0/gtkrc";
    # Force GTK to use portal
    GTK_USE_PORTAL = "1";
    # X11 display
    DISPLAY = ":0";
    XAUTHORITY = "$HOME/.Xauthority";

    # Qt specific settings
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    
    # Force Electron and Chromium to use Wayland
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    
    # Force dark mode for various frameworks
    FORCE_DARK_MODE = "1";
    THEME_VARIANT = "dark";
    COLOR_SCHEME = "prefer-dark";
    
    # XDG specific settings
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };

  # Configure GTK default theme
  environment.etc = {
    # GTK3 settings
    "gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Adwaita-dark
      gtk-icon-theme-name=Adwaita
      gtk-font-name=Sans 10
      gtk-cursor-theme-name=Adwaita
      gtk-cursor-theme-size=24
      gtk-enable-animations=true
    '';
    
    # GTK4 settings
    "gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-application-prefer-dark-theme=1
      gtk-theme-name=Adwaita-dark
      gtk-icon-theme-name=Adwaita
      gtk-font-name=Sans 10
      gtk-cursor-theme-name=Adwaita
      gtk-cursor-theme-size=24
      gtk-enable-animations=true
    '';
  };

  # Display manager and desktop
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = false;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  # Network
  networking.networkmanager.enable = true;

  # RustDesk client: allow ports for relay/remote desktop (if you use direct connections)
  networking.firewall.allowedTCPPorts = [ 21115 21116 21117 21118 21119 ];
  networking.firewall.allowedUDPPorts = [ 21115 21116 21117 21118 21119 ];

  # Printing
  services.printing.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Docker (from unstable)
  virtualisation.docker = {
    enable = true;
    package = pkgs.unstable.docker;
  };

  # KVM/QEMU Virtualization with full VMM support
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;  # Enable TPM emulation
        ovmf.enable = true;   # Enable UEFI support
      };
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;  # Enable USB redirection
  };

  # Enable virt-manager and related tools
  programs.virt-manager.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Theme and appearance packages
    adwaita-qt
    qt5.qtbase
    qt6.qtbase
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    gtk2
    gtk3
    gtk4
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    adwaita-icon-theme
    hicolor-icon-theme
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # Virtualization packages
    virt-viewer
    spice-gtk
    win-virtio  # Windows VirtIO drivers
    swtpm       # TPM emulator
    polkit_gnome  # Add polkit authentication agent
  ];

  # Enable polkit for authentication
  security.polkit = {
    enable = true;
    # Allow members of the wheel group to manage libvirt without password
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.libvirt.unix.manage" &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      });
    '';
  };

  # Auto-start polkit authentication agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Enable dconf (required for virt-manager settings)
  programs.dconf.enable = true;

  # Copy custom Hyprland config to /etc/hyprland-custom
  # To use your custom config, manually symlink or copy /etc/hyprland-custom to ~/.config/hypr
  environment.etc."hyprland-custom".source = "/home/fox7fog/.dotfiles/linux-config/.config/hypr";

  # Enable Hyprland (from unstable)
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };


  # Example: Secure cascade agent service
  systemd.services.cascade = {
    description = "Cascade Agent (placeholder)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/true"; # Placeholder command
      DynamicUser = true; # creates transient user, avoids missing user error
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      CapabilityBoundingSet = [ ];
    };
  };
  # Production-grade: Disable IPv6 at the kernel level
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
  };
}
