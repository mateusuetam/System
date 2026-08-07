{ config, lib, pkgs, ... }:

{
options.my.fonts.enable = lib.mkEnableOption "Bundle de fontes";

config = lib.mkIf config.my.fonts.enable {

fonts.packages = with pkgs; [
nerd-fonts.symbols-only
noto-fonts
noto-fonts-cjk-sans
noto-fonts-color-emoji
roboto
roboto-mono
roboto-serif
];
};
}
