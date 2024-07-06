{ ... }:
{
    services.samba = {
        enable = true;
        securityType = "user";
        extraConfig = ''
            workgroup = WORKGROUP
            server string = files
            netbios name = files
            hosts allow = 100. 127.0.0.1 192.168.0. localhost
            hosts deny = 0.0.0.0/0
            map to guest = bad user
        '';
        shares = {
            files = {
                path = "/files/";
                browseable = "yes";
                writable = "yes";
                "valid users" = "sean nathaniel";
                public = "yes";
            };
        };
    };

    services.samba-wsdd.enable = true;
}