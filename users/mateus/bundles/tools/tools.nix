{ config, lib, pkgs, ... }:

{
options.my.tools.enable = lib.mkEnableOption "Bundle de ferramentas";

config = lib.mkIf config.my.tools.enable {

environment.defaultPackages = lib.mkForce [];

xdg.portal.enable = true;

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
};

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"discord"
"spotify"
"vscode"
];

users.users.mateus.packages = with pkgs; [
discord
gimp
spotify
tree
unzip
vscode
zip
];
};
}
