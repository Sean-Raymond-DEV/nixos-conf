{ pkgs, ... }:
let
    defaultGroups = [ "wheel" "video" "power" "networkmanager" "docker" ];
    nateKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKllhPAEJdo9+b8mOv6NUcSyVDjVz9yzXXcdKlN98FV1 nathaniel";
    seanKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNK5Ds6fbRg9E/kJlPgv2CVlW47dbVM9NnOddBjU4oH sean";
    seanWSL = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMQccxq0NDaceHTtdGQghhPJOXve6Qxe+P6h+bqm4AHL5zx5KTo6IG7l3RHk+Mp31CZnoo2zgcTtq+AltQjR1GnYQ4Gb1TJjqk2BytabqFDL4lMKEhkhz+Xgl2ClzTtIAkyP1QxyP0WaOORWFHQVseP/WFacNslqV6VCQfTFTDAvWZiI0WIYmJHlc2kpjI+zo4sDe79PAoBY4lWabIOtVxlE5EUxgzBgLSTlpb2BFkuzOnc7sTsMAVHawSuwN22CiQGFNn/SNvJIOpNHTf5CtjRzLl22Mg31/4U7dgYxWWBmApUI+5HS7nXyIGZHiHnIia3DZ9t1rboJ/wEde+KmKo/Ope9JOGfZmaf5F3SnKeju0FI77sQkJrsFYSFsV9KU1HW4IIKGTSLzJL5JJKinsJIBqVRULD/WGq1YO8fEcaWD3Wn7rPeK9Odaof4xtI76RMqAg0YmWCJXFM48yxqqSvr56nD5PNPr5xQP7oJzJ1g58TNtqm5vRAUu3vBCmgMCc= sean@Main-PC";
in
{
    imports = [
        ./bcachefs.nix
        ./samba.nix
    ];
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
                seanWSL
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
                seanWSL
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