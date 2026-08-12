{ config, lib, pkgs, ... }:

{
options.my.kde.enable = lib.mkEnableOption "Bundle de ambiente desktop KDE";

config = lib.mkIf config.my.kde.enable {

services = {
desktopManager.plasma6.enable = true;
displayManager.plasma-login-manager.enable = true;
};

environment.plasma6.excludePackages = with pkgs.kdePackages; [
discover
plasma-browser-integration
kwin-x11
qtsensors
qttools
khelpcenter
krdp
];

users.users.mateus.packages = with pkgs; [
kdePackages.kcalc
];
};
}
