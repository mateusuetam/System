{ config, lib, pkgs, ... }:

{
imports = [
./bundles
./home
];

options.my.users.mateus = {
enable = lib.mkEnableOption "Habilitar configurações e bundles de usuário";
};

config = lib.mkIf config.my.users.mateus.enable {

users.users.mateus = {
isNormalUser = true;
extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
};

my = {
gnome.enable = false;
kde.enable = false;
niri.enable = true;
sway.enable = false;

minimalshell.enable = false;
quickshell.enable = true;
quickshelldev.enable = true;
shellutils.enable = true;

course.enable = true;
firefox.enable = true;
fonts.enable = true;
neovim.enable = true;
tools.enable = true;

homemanager = {
enable = true;
homeDir = "/home/mateus";
owner = "mateus:users";
};
};
};
}
