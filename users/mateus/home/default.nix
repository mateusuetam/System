{ config, lib, pkgs, ... }:

{
options.my.homemanager = {
enable = lib.mkEnableOption "Bundle de gerenciamento de dotfiles";

homeDir = lib.mkOption {
type = lib.types.str;
example = "/home/username";
description = "Diretório HOME onde os dotfiles serão instalados.";
};

owner = lib.mkOption {
type = lib.types.str;
example = "username:users";
description = "Usuário e grupo proprietários dos dotfiles.";
};
};

config = lib.mkIf config.my.homemanager.enable {

system.activationScripts.homemanager = {
deps = [ "users" ];

text =
let
inherit (config.my.homemanager) homeDir owner;

configDir = "${homeDir}/.config";

dotfiles = [
{
bundles = [];
source = ./.bashrc;
target = "${homeDir}/.bashrc";
}

{
bundles = [ "niri" "sway" ];
source = ./.config/mimeapps.list;
target = "${configDir}/mimeapps.list";
}

{
bundles = [ "niri" "sway" ];
source = ./.icons/default/index.theme;
target = "${homeDir}/.icons/default/index.theme";
}

{
bundles = [ "niri" ];
source = ./.config/niri/config.kdl;
target = "${configDir}/niri/config.kdl";
}

{
bundles = [ "sway" ];
source = ./.config/sway/config;
target = "${configDir}/sway/config";
}

{
bundles = [ "minimalshell" ];
source = ./.config/foot/foot.ini;
target = "${configDir}/foot/foot.ini";
}

{
bundles = [ "minimalshell" ];
source = ./.config/mako/config;
target = "${configDir}/mako/config";
}

{
bundles = [ "minimalshell" ];
source = ./.config/swaylock/config;
target = "${configDir}/swaylock/config";
}

{
bundles = [ "minimalshell" ];
source = ./.config/waybar/config.jsonc;
target = "${configDir}/waybar/config.jsonc";
}

{
bundles = [ "minimalshell" ];
source = ./.config/waybar/style.css;
target = "${configDir}/waybar/style.css";
}

{
bundles = [ "quickshell" ];
source = ./.config/alacritty/alacritty.toml;
target = "${configDir}/alacritty/alacritty.toml";
}

{
bundles = [ "quickshell" ];
source = ./.config/quickshell;
target = "${configDir}/quickshell";
}

{
bundles = [ "shellutils" ];
source = ./.config/mpv/mpv.conf;
target = "${configDir}/mpv/mpv.conf";
}
];

bundleEnabled = bundle: lib.attrByPath [ "my" bundle "enable" ] false config;
dotfileEnabled = dotfile: (dotfile.bundles == []) || lib.any bundleEnabled dotfile.bundles;

activeDotfiles = lib.filter dotfileEnabled dotfiles;
inactiveDotfiles = lib.filter (dotfile: !(dotfileEnabled dotfile)) dotfiles;

activeCommands = lib.concatMapStringsSep "\n" (dotfile: '' link_dotfile "${dotfile.source}" "${dotfile.target}" '') activeDotfiles;
inactiveCommands = lib.concatMapStringsSep "\n" (dotfile: '' remove_dotfile "${dotfile.source}" "${dotfile.target}" '') inactiveDotfiles;

in
''
set -euo pipefail

if [ ! -d "${configDir}" ]; then
${pkgs.coreutils}/bin/mkdir -p "${configDir}"
${pkgs.coreutils}/bin/chown "${owner}" "${configDir}"
fi

link_dotfile() {
local source_store_path="$1"
local target_home_path="$2"
local parent_dir
local current_target

parent_dir="$(${pkgs.coreutils}/bin/dirname "$target_home_path")"

if [ ! -d "$parent_dir" ]; then
${pkgs.coreutils}/bin/mkdir -p "$parent_dir"
${pkgs.coreutils}/bin/chown "${owner}" "$parent_dir"
fi

if [ -L "$target_home_path" ]; then
current_target="$(${pkgs.coreutils}/bin/readlink -f "$target_home_path" 2>/dev/null || true)"

if [ "$current_target" = "$source_store_path" ]; then
return 0
fi

elif [ -e "$target_home_path" ]; then
echo "homemanager: não sobrescrevendo '$target_home_path'." >&2
echo "homemanager: o destino existe e não é um symlink." >&2
return 0
fi

${pkgs.coreutils}/bin/ln -sfn "$source_store_path" "$target_home_path"
${pkgs.coreutils}/bin/chown -h "${owner}" "$target_home_path"
}

remove_dotfile() {
local target_home_path="$2"
local current_target
local parent_dir

if [ ! -L "$target_home_path" ]; then
return 0
fi

current_target="$(${pkgs.coreutils}/bin/readlink -f "$target_home_path" 2>/dev/null || true)"

case "$current_target" in "/nix/store/"*) ${pkgs.coreutils}/bin/rm -f "$target_home_path"

parent_dir="$(${pkgs.coreutils}/bin/dirname "$target_home_path")"

while [ "$parent_dir" != "${homeDir}" ] && [ "$parent_dir" != "${configDir}" ]; do
if [ -d "$parent_dir" ] && [ -z "$(${pkgs.coreutils}/bin/ls -A "$parent_dir")" ]; then
${pkgs.coreutils}/bin/rmdir "$parent_dir"
parent_dir="$(${pkgs.coreutils}/bin/dirname "$parent_dir")"
else
break
fi
done
;;
*)
echo "homemanager: preservando symlink externo:" "'$target_home_path'" >&2;;
esac
}

${activeCommands}
${inactiveCommands}
'';
};
};
}
