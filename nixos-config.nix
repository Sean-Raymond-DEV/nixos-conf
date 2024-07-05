{ pkgs, ... }:
let
    defaultGroups = [ "wheel" "video" "power" "networkmanager" "docker" ];
    nateKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKllhPAEJdo9+b8mOv6NUcSyVDjVz9yzXXcdKlN98FV1 nathaniel";
    seanKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNK5Ds6fbRg9E/kJlPgv2CVlW47dbVM9NnOddBjU4oH sean";
in
{
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";
    boot.loader = {
        grub = {
            enable = true;
            efiSupport = true;
            configurationLimit = 20;
            device = "nodev";
        };
        efi.canTouchEfiVariables = true;
        timeout = 5;
    };

    hardware.graphics.enable = true;
    

    networking = {
        hostName = "files";

        networkmanager.enable = true;
        firewall.enable = false;
    };

    users.users = {
        sean = {
            uid = 1000;
            description = "Sean Raymond";
            isNormalUser = true;
            extraGroups = defaultGroups;
            hashedPassword = "$y$j9T$Pb0.439rXbIO76Pca.1T61$ywxJiFJL56TgsSm9zJ2clx0ENOjjXDAsP.qyTNTINx7";
            openssh.authorizedKeys.keys = [
                seanKey
            ];
        };
        nathaniel = {
            uid = 1001;
            description = "Nathaniel Barragan";
            isNormalUser = true;
            extraGroups = defaultGroups;
            hashedPassword = "$y$j9T$CBJCN1YaV0hN5NCUXs50z1$BdIXy1ejWN353eS/8.SJnseYO1Zwwcg3E8Ub3B9EjX9";
            openssh.authorizedKeys.keys = [
                nateKey
            ];
        };
        root = {
            openssh.authorizedKeys.keys = [
                seanKey
                nateKey
            ];
        };
    };

    services = {
        openssh = {
            enable = true;
            settings.X11Forwarding = true;
        };
        tailscale.enable = true;
    };
    

    environment.systemPackages = with pkgs; [
        neovim
        wget
        tailscale
        tmux
        mosh
    ];

    nix = {
        gc = {
            automatic = true;
            dates = "0:00";
        };
        settings = {
            experimental-features = "nix-command flakes";
            trusted-users = [ "root" "@wheel" ];
        };
    };

    system.stateVersion = "24.11";

    nixpkgs.config = {
        allowUnfree = true;
    };
}