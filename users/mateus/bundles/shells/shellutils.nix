{ config, lib, pkgs, ... }:

{
options.my.shellutils.enable = lib.mkEnableOption "Bundle de ferramentas para shells";

config = lib.mkIf config.my.shellutils.enable {

users.users.mateus.packages = with pkgs; [
adwaita-icon-theme
bc
brightnessctl
cliphist
gammastep
libnotify
mpv
wl-clipboard
];
};
}
