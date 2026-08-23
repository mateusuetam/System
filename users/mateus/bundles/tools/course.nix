{ config, lib, pkgs, ... }:

{
options.my.course.enable = lib.mkEnableOption "Bundle para o curso";

config = lib.mkIf config.my.course.enable {

services = {
gnome.gnome-keyring = {
enable = true;
};
mysql = {
enable = true;
package = pkgs.mysql84;
settings.mysqld = {
bind-address = "127.0.0.1";
port = 3306;
mysqlx = 0;
};
};
};

systemd.services.mysql.wantedBy = lib.mkForce [ ];

users.users.mateus.packages = with pkgs; [
jdk
mysql-workbench
nodejs

(symlinkJoin {
name = "netbeans-wrapped";
paths = [ netbeans ];
nativeBuildInputs = [ makeWrapper ];
postBuild = ''
wrapProgram $out/bin/netbeans \
--set _JAVA_AWT_WM_NONREPARENTING 1 \
--set _JAVA_OPTIONS "-Dawt.useSystemAAFontSettings=lcd"
'';
})
];
};
}
