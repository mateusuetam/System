{ config, lib, pkgs, ... }:

{
options.my.quickshelldev.enable = lib.mkEnableOption "Bundle para desenvolvimento do Quickshell";

config = lib.mkIf config.my.quickshelldev.enable {

users.users.mateus.packages = with pkgs; [
qt6.qtwayland

(symlinkJoin {
name = "qmllint-wrapped";
paths = [ qt6.qtdeclarative ];
nativeBuildInputs = [ pkgs.makeWrapper ];
postBuild = ''
wrapProgram $out/bin/qmllint \
--add-flags "-I ${pkgs.qt6.qtdeclarative}/lib/qt-6/qml" \
--add-flags "-I ${pkgs.qt6.qtbase}/lib/qt-6/qml" \
--add-flags "-I ${pkgs.quickshell}/lib/qt-6/qml"
'';
})
];
};
}
