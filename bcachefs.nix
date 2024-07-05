{ pkgs, ... }:
{
    environment.systemPackaqges = with pkgs; [
        bcachefs-tools
    ];
    boot.supportedFilesystems = [ "bcachefs" ];
}