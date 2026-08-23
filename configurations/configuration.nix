{ config, lib, pkgs, ... }:

{
imports = [
../users/mateus/mateus.nix
];

boot = {
loader = {
systemd-boot.enable = true;
systemd-boot.editor = false;
efi.canTouchEfiVariables = true;
timeout = 1;
};
kernelPackages = pkgs.linuxPackages_latest;
kernelParams = [
"nowatchdog"
"nmi_watchdog=0"
"module_blacklist=watchdog"
];
kernel.sysctl = {
"net.ipv4.conf.all.accept_redirects" = 0;
"net.ipv6.conf.all.accept_redirects" = 0;
"net.ipv4.conf.default.accept_redirects" = 0;
"net.ipv6.conf.default.accept_redirects" = 0;
"net.ipv4.conf.all.accept_source_route" = 0;
"net.ipv6.conf.all.accept_source_route" = 0;
"net.ipv4.conf.default.accept_source_route" = 0;
"net.ipv6.conf.default.accept_source_route" = 0;
"net.ipv4.conf.all.send_redirects" = 0;
"net.ipv4.conf.default.send_redirects" = 0;
"net.ipv4.tcp_syncookies" = 1;
"net.ipv4.tcp_rfc1337" = 1;
"net.ipv4.icmp_echo_ignore_all" = 1;
"kernel.dmesg_restrict" = 1;
"kernel.kptr_restrict" = 2;
};
extraModprobeConfig = ''
options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss=y
options rtw89_core disable_ps_mode=y
'';
tmp.cleanOnBoot = true;
};

networking = {
hostName = "pc";
nftables.enable = true;
firewall.enable = true;
networkmanager.enable = true;
modemmanager.enable = false;
};

systemd.services.NetworkManager-wait-online.enable = false;

environment = {
etc."systemd/system-sleep/rfkill".source =
pkgs.writeShellScript "rfkill-sleep" ''
case "$1" in
pre)
${pkgs.util-linux}/bin/rfkill block all
;;
post)
${pkgs.util-linux}/bin/rfkill unblock all
;;
esac
'';
};

console = {
keyMap = "br-abnt2";
};
i18n = {
defaultLocale = "pt_BR.UTF-8";
};
time.timeZone = "America/Recife";

nix = {
settings = {
auto-optimise-store = true;
allowed-users = [
"@wheel"
];
experimental-features = [
"nix-command"
"flakes"
];
};
gc = {
automatic = true;
dates = "weekly";
options = "--delete-older-than 7d";
};
};

hardware = {
bluetooth.enable = true;
};

security = {
rtkit.enable = true;
sudo.execWheelOnly = true;
protectKernelImage = true;
};

services = {
pipewire = {
enable = true;
alsa.enable = true;
alsa.support32Bit = true;
pulse.enable = true;
};
upower = {
enable = true;
percentageLow = 20;
percentageCritical = 15;
percentageAction = 10;
criticalPowerAction = "Suspend";
allowRiskyCriticalPowerAction = true;
};
fstrim = {
enable = true;
interval = "weekly";
};
journald = {
settings = {
Journal = {
SystemMaxUse = "64M";
};
};
};
avahi.enable = false;
};

documentation = {
man.enable = true;
info.enable = false;
doc.enable = false;
nixos.enable = false;
};

my.users.mateus.enable = true;

system.stateVersion = "26.05";
}
