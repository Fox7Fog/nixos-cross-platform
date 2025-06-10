# Hyprland configuration for Home Manager
{ config, lib, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      "$mod" = "SUPER";
      
      monitor = ",preferred,auto,1";
      
      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "blueman-applet"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee)";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_is_master = true;
      };

      # Window rules
      windowrule = [
        "float, ^(pavucontrol)$"
        "float, ^(blueman-manager)$"
        "float, ^(nm-connection-editor)$"
      ];

      # Keybindings
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive,"
        "$mod SHIFT, E, exit,"
        "$mod, E, exec, dolphin"
        "$mod, V, togglefloating,"
        "$mod, D, exec, wofi --show drun"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        
        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        
        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move windows to workspaces
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Screenshots
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +'%Y%m%d_%H%M%S').png"
      ];

      bindm = [
        # Mouse bindings
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Additional Hyprland-related home configuration
  home.packages = with pkgs; [
    waybar        # Status bar
    wofi          # Application launcher
    mako          # Notification daemon
    swaylock-effects # Screen locker with effects
    wl-clipboard  # Clipboard utilities
    grim          # Screenshot utility
    slurp         # Screen area selection
    pamixer       # PulseAudio CLI mixer
    brightnessctl # Brightness control
  ];

  # Waybar configuration
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.5);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: white;
      }
    '';
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      modules-left = ["hyprland/workspaces" "hyprland/mode"];
      modules-center = ["hyprland/window"];
      modules-right = [
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "clock"
        "tray"
      ];
      
      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
      };
      
      "clock" = {
        format = "{:%Y-%m-%d %H:%M}";
        tooltip = true;
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      
      "cpu" = {
        format = "{usage}% ";
        tooltip = false;
      };
      
      "memory" = {
        format = "{}% ";
      };
      
      "temperature" = {
        critical-threshold = 80;
        format = "{temperatureC}°C ";
      };
      
      "battery" = {
        format = "{capacity}% {icon}";
        format-icons = ["" "" "" "" ""];
      };
      
      "network" = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      
      "pulseaudio" = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
    }];
  };
}
