{ config, lib, pkgs, ... }:

{
options.my.tools.enable = lib.mkEnableOption "Bundle de ferramentas";

config = lib.mkIf config.my.tools.enable {

environment.defaultPackages = lib.mkForce [];

xdg.portal.enable = true;

nixpkgs.config.allowUnfreePredicate = pkg:
builtins.elem (lib.getName pkg) [
"spotify"
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
};

users.users.mateus.packages = with pkgs; [
gimp
spotify
tree
unzip
vscode
zip
];
};
}
