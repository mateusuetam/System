{ config, lib, pkgs, ... }:

let
cfg = config.my.homemanager;

homeDir = cfg.homeDir;
configDir = "${homeDir}/.config";

minimal = config.my.minimalshell.enable;
quickshell = config.my.quickshell.enable;
niri = config.my.niri.enable;
sway = config.my.sway.enable;
wayland = niri || sway;

bundles = [
{
name = "base";
enabled = true;
links = {
"${homeDir}/.bashrc" = "${./.bashrc}";
};
remove = [];
}

{
name = "minimalshell";
enabled = minimal;
links = {
"${configDir}/foot/foot.ini" = "${./.config/foot/foot.ini}";
"${configDir}/mako/config" = "${./.config/mako/config}";
"${configDir}/swaylock/config" = "${./.config/swaylock/config}";
"${configDir}/waybar/config.jsonc" = "${./.config/waybar/config.jsonc}";
"${configDir}/waybar/style.css" = "${./.config/waybar/style.css}";
};
remove = [
"${configDir}/foot"
"${configDir}/mako"
"${configDir}/swaylock"
"${configDir}/waybar"
];
}

{
name = "quickshell";
enabled = quickshell;
links = {
"${configDir}/alacritty/alacritty.toml" = "${./.config/alacritty/alacritty.toml}";
"${configDir}/quickshell" = "${./.config/quickshell}";
};
remove = [
"${configDir}/alacritty"
"${configDir}/quickshell"
];
}

{
name = "niri";
enabled = niri;
links = {
"${configDir}/niri/config.kdl" = "${./.config/niri/config.kdl}";
};
remove = [
"${configDir}/niri"
];
}

{
name = "sway";
enabled = sway;
links = {
"${configDir}/sway/config" = "${./.config/sway/config}";
};
remove = [
"${configDir}/sway"
];
}

{
name = "wayland";
enabled = wayland;
links = {
"${configDir}/mimeapps.list" = "${./.config/mimeapps.list}";
"${homeDir}/.icons/default/index.theme" = "${./.icons/default/index.theme}";
};
remove = [
"${configDir}/mimeapps.list"
"${homeDir}/.icons/default/index.theme"
];
}
];

disabledBundles = builtins.filter (bundle: !bundle.enabled) bundles;
cleanupTargets = lib.concatMap (bundle: bundle.remove) disabledBundles;
activeTmpfiles = lib.foldl' (acc: bundle:
if bundle.enabled then
let
parents = lib.unique (builtins.map builtins.dirOf (builtins.attrNames bundle.links));
parentDirs = builtins.listToAttrs (builtins.map (path: {
name = path;
value = {"d" = {user = cfg.user; group = cfg.group; mode = "0755";};};
})
parents);
links = lib.mapAttrs (target: source: {
"L" = {user = cfg.user; group = cfg.group; argument = source;};
})
bundle.links;
in
acc // parentDirs // links
else
acc)
{}
bundles;

cleanupScript = pkgs.writeShellScript "homemanager-cleanup" ''
set -eu

HOME_DIR=${lib.escapeShellArg homeDir}
CONFIG_DIR=${lib.escapeShellArg configDir}

if [ -L "$HOME_DIR" ]; then
echo "ERRO! HOME é um symlink: $HOME_DIR" >&2
exit 1
fi

if [ ! -d "$HOME_DIR" ]; then
echo "ERRO! HOME não existe: $HOME_DIR" >&2
exit 1
fi

if [ -L "$CONFIG_DIR" ]; then
echo "ERRO! ~/.config é um symlink." >&2
exit 1
fi

remove_target() {
local target="$1"
local parent_dir
local real_parent

if [ "$target" = "$HOME_DIR" ]; then
echo "ERRO! tentativa de remover HOME recusada: $target" >&2
exit 1
fi

if [ "$target" = "$CONFIG_DIR" ]; then
echo "ERRO! tentativa de remover ~/.config recusada: $target" >&2
exit 1
fi

case "$target" in
*"/../"*|*".." )
echo "ERRO! caminho com '..' recusado: $target" >&2
exit 1
;;
esac

case "$target" in
"$CONFIG_DIR/"*)
;;
"$HOME_DIR/.icons/default/index.theme")
;;
*)
echo "ERRO! alvo fora das áreas permitidas: $target" >&2
exit 1
;;
esac

[ -e "$target" ] || [ -L "$target" ] || return 0

parent_dir="$(${pkgs.coreutils}/bin/dirname -- "$target")"
real_parent="$(${pkgs.coreutils}/bin/realpath -e -- "$parent_dir")" || { echo "ERRO! não foi possível resolver o diretório pai: $parent_dir" >&2; exit 1; }

case "$real_parent" in
"$HOME_DIR"|"$HOME_DIR"/*)
;;
*)
echo "ERRO! diretório pai está fora da HOME: $real_parent" >&2
exit 1
;;
esac

${pkgs.coreutils}/bin/rm -rf --one-file-system -- "$target"
}

${lib.concatMapStringsSep "\n" (target: "remove_target ${lib.escapeShellArg target};") cleanupTargets}
'';

in
{
options.my.homemanager = {
enable = lib.mkEnableOption "Bundle de gerenciamento de dotfiles";

homeDir = lib.mkOption {
type = lib.types.strMatching "^/home/[A-Za-z0-9][A-Za-z0-9._-]*$";
example = "/home/mateus";
description = "Diretório HOME onde os dotfiles serão instalados.";
};

user = lib.mkOption {
type = lib.types.str;
example = "mateus";
description = "Usuário proprietário dos dotfiles.";
};

group = lib.mkOption {
type = lib.types.str;
example = "users";
description = "Grupo proprietário dos dotfiles.";
};
};

config = lib.mkIf cfg.enable {

systemd.tmpfiles.settings."homemanager" = {
"${configDir}".d = {
user = cfg.user;
group = cfg.group;
mode = "0755";
};

"${homeDir}/.icons".d = {
user = cfg.user;
group = cfg.group;
mode = "0755";
};

"${homeDir}/.icons/default".d = {
user = cfg.user;
group = cfg.group;
mode = "0755";
};
} // activeTmpfiles;

system.activationScripts.homemanager-cleanup =
lib.mkIf (cleanupTargets != []) {
deps = [ "users" ];
text = ''
${cleanupScript}
'';
};
};
}
