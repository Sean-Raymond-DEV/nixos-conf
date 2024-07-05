{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      files = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./nixos-config.nix
          ./files-hardware.nix
        ];
      };
    };
    packages.x86_64-linux.update =
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    pkgs.writeShellApplication {
      name = "update";
      runtimeInputs = with pkgs; [ nixos-rebuild nix git ];
      text = ''
        nix flake update --commit-lock-file
        nixos-rebuild switch --flake .#files --target-host root@files
        echo "done"
      '';
    };
    apps.x86_64-linux.update = {
      type = "app";
      program = "${self.packages.x86_64-linux.update}/bin/update";
    };
  };
}
