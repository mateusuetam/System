{ config, lib, pkgs, ... }:

{
options.my.minimalshell.enable = lib.mkEnableOption "Bundle para ambientes minimalistas";

config = lib.mkIf config.my.minimalshell.enable {

users.users.mateus.packages = with pkgs; [
foot
mako
playerctl
swayidle
swaylock
waybar
];
};
}
