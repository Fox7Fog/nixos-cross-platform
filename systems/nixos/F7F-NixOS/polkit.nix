{ config, pkgs, ... }:
{
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [ lxqt.lxqt-policykit ];
  systemd.user.services.lxqt-policykit-agent = {
    description = "lxqt-policykit-agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
    };
  };
}

