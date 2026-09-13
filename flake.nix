{
description = "Flake de configuração do NixOS";

inputs = {
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

# temporário: versão funcional do MySQL Workbench
nixpkgs-mysql-workbench.url = "github:nixos/nixpkgs/8ce4ef6cb6f871616146b9fe26d2a5ae594e94fe";
};

# temporário: "nixpkgs-mysql-workbench"
outputs = { nixpkgs, nixpkgs-mysql-workbench, ... }@inputs: {
nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
system = "x86_64-linux";

modules = [
./configurations/hardware-configuration.nix
./configurations/configuration.nix

# temporário: Workbench na versão funcional
{
users.users.mateus.packages = [
nixpkgs-mysql-workbench.legacyPackages.x86_64-linux.mysql-workbench
];
}
];
};
};
}
