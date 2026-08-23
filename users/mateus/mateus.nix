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
niri.enable = false;
sway.enable = true;

minimalshell.enable = true;
quickshell.enable = false;
quickshelldev.enable = false;
shellutils.enable = true;

course.enable = true;
firefox.enable = true;
fonts.enable = true;
neovim.enable = true;
tools.enable = true;

homemanager = {
enable = true;
homeDir = "/home/mateus";
user = "mateus";
group = "users";
};
};
};
}
