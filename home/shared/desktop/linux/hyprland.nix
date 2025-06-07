{ config, pkgs, lib, ... }:

{
  imports = [
    ./waybar.nix
    ./mako.nix
  ];

  home.sessionVariables = {
    # Required for NVIDIA on Hyprland
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT6CT_PLATFORMTHEME = "qt6ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    
    settings = {
      monitor = [
          # 100% scale
          "eDP-1,1920x1080@60,0x0,1"
          "DP-1,1920x1080@74.97,1920x0,1"
          # Uncomment below for 125% scale
          # "eDP-1,1920x1080@60,0x0,1.25"
          # "DP-1,1920x1080@74.97,1920x0,1.25"
        ];
      
      exec-once = [
        "hyprpaper"
        "waybar"
        "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        "wl-paste --watch cliphist store"
      ];
      
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
        sensitivity = 0;
      };
      
      # Set COSMIC cursor theme globally for Hyprland
      env = [
        "XCURSOR_THEME,Cosmic"
        "XCURSOR_SIZE,24"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(45475aee)";
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
        blur = {
          enabled = false;
        };
        dim_inactive = false;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
      };
      
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      gestures.workspace_swipe = true;
      misc.force_default_wallpaper = -1;
      
      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,title:^(Firefox — Sharing Indicator)$"
      ];
      
      "$mainMod" = "SUPER";
      
      bind = [
        "$mainMod, RETURN, exec, ${pkgs.alacritty}/bin/alacritty"
        "$mainMod, SPACE, exec, ${pkgs.wofi}/bin/wofi --show drun"
        "$mainMod, B, exec, ${pkgs.brave}/bin/brave"
        "$mainMod, E, exec, ${pkgs.cosmic-files}/bin/cosmic-files"
        "$mainMod, Q, killactive,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod, F, fullscreen,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        
        # Focus movement
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Mouse bindings
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # Media keys
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        
        # Screenshots
        ", Print, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "$mainMod, Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy"
        
        # Lock screen
        "$mainMod CTRL, L, exec, ${pkgs.swaylock-effects}/bin/swaylock -f"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  # Additional Wayland packages
  home.packages = with pkgs; [
    unstable.waybar
    wofi
    swaylock-effects
    swayidle
    hyprpaper
    wl-clipboard
    cliphist
    grim
    slurp
    pavucontrol
    brightnessctl
    kdePackages.polkit-kde-agent-1
    libnotify
    qt6.qtbase
    qt6ct
  ];
}
