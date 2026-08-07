#!/usr/bin/env bash
sair=" Sair"
bloquear=" Bloquear"
suspender=" Suspender"
reiniciar=" Reiniciar"
desligar=" Desligar"
options="$sair\n$bloquear\n$suspender\n$reiniciar\n$desligar"
chosen=$(echo -e "$options" | rofi -dmenu -i -theme $HOME/.config/rofi/powermenu.rasi)
case $chosen in
$sair)
swaymsg exit ;;
$bloquear)
swaylock ;;
$suspender)
systemctl suspend ;;
$reiniciar)
reboot ;;
$desligar)
shutdown -h 0 ;;
esac
