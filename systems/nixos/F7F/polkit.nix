# Custom polkit rules
{ config, pkgs, lib, ... }:

{
  # Enable Polkit
  security.polkit.enable = true;

  # Enable the Polkit authentication agent
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

  # Allow members of the wheel group to execute privileged operations
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel") &&
          (action.id == "org.freedesktop.policykit.exec" ||
           action.id.indexOf("org.freedesktop.packagekit.") == 0 ||
           action.id.indexOf("org.freedesktop.systemd1.") == 0 ||
           action.id == "org.libvirt.unix.manage")) {
          return polkit.Result.YES;
      }
    });
  '';

  # Enable D-Bus service
  services.dbus.enable = true;

  # Configure environment variables for X11 authorization
  environment.sessionVariables = {
    # Ensure XDG_RUNTIME_DIR is set
    XDG_RUNTIME_DIR = "/run/user/$(id -u)";
  };
}
