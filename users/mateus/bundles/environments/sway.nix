{ config, lib, pkgs, ... }:

{
options.my.sway.enable = lib.mkEnableOption "Bundle de ambiente desktop Sway";

config = lib.mkIf config.my.sway.enable {

programs = {
sway = {
enable = true;
extraPackages = [ ];
};
xwayland.enable = true;
};

users.users.mateus.packages = with pkgs; [
grim
slurp
];
};
}
