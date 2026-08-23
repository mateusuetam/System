{ config, lib, pkgs, ... }:

{
options.my.tools.enable = lib.mkEnableOption "Bundle de ferramentas";

config = lib.mkIf config.my.tools.enable {

environment.defaultPackages = lib.mkForce [];

xdg.portal.enable = true;

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"discord"
"discord-unwrapped"
"spotify"
"steam"
"steam-unwrapped"
"vscode"
];

programs = {
bash = {
enable = true;
interactiveShellInit = ''
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
'';
};
git.enable = true;
steam.enable = true;
};

users.users.mateus.packages = with pkgs; [
discord
gimp
proton-vpn
spotify
tree
unzip
vscode
wireguard-tools
zip
];
};
}
