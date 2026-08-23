{ config, lib, pkgs, modulesPath, ... }:

{
imports =
[ (modulesPath + "/installer/scan/not-detected.nix")
];

boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" ];
boot.initrd.kernelModules = [ ];
boot.kernelModules = [ ];
boot.extraModulePackages = [ ];

fileSystems."/" =
{ device = "/dev/disk/by-uuid/69d99671-6f40-4fb2-bb0b-eb685f2dfb9c";
fsType = "ext4";
};

fileSystems."/boot" =
{ device = "/dev/disk/by-uuid/9D3B-F0CB";
fsType = "vfat";
options = [ "fmask=0077" "dmask=0077" ];
};

swapDevices = [ ];

nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
