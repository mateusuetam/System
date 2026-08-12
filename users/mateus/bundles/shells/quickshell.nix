{ config, lib, pkgs, ... }:

{
options.my.quickshell.enable = lib.mkEnableOption "Bundle com configurações e pacotes para o Quickshell";

config = lib.mkIf config.my.quickshell.enable {

fonts.packages = with pkgs; [
monaspace
];

users.users.mateus.packages = with pkgs; [
brightnessctl
cliphist
gammastep
libnotify
quickshell
wl-clipboard
];

systemd.user.services.cliphist-watch = {
description = "Clipboard";
partOf = [ "graphical-session.target" ];
wantedBy = [ "graphical-session.target" ];
after = [ "graphical-session.target" ];

serviceConfig = {
ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
Restart = "always";
RestartSec = "3s";
};
};

systemd.user.services.quickshell = {
description = "Quickshell Wayland UI";
partOf = [ "graphical-session.target" ];
after = [ "graphical-session.target" ];
wantedBy = [ "graphical-session.target" ];

path = with pkgs; [
bash
procps
util-linux
cliphist
gammastep
brightnessctl
libnotify
bluez
psmisc
coreutils
systemd
wl-clipboard
"/run/current-system/sw"
"/etc/profiles/per-user/%u"
];

environment = {
QT_LOGGING_RULES = "quickshell.dbus.properties=false;qt.qpa.services=false";
};

serviceConfig = {
ExecStart = "${pkgs.quickshell}/bin/quickshell";
Restart = "on-failure";
KillMode = "process";
};
};
};
}
