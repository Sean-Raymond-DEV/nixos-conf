{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        bcachefs-tools
    ];
    boot.supportedFilesystems = [ "bcachefs" ];
}