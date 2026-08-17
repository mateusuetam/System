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
{ device = "/dev/disk/by-uuid/4decb741-d0e9-43d6-939f-a473c86175e2";
fsType = "ext4";
};

fileSystems."/boot" =
{ device = "/dev/disk/by-uuid/349D-419C";
fsType = "vfat";
options = [ "fmask=0077" "dmask=0077" ];
};

swapDevices = [ ];

nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
