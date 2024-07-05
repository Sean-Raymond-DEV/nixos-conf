{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      files = {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./nixos-config.nix
          ./files-hardware.nix
        ];
      };
    };
  };
}
