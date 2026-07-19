{ self, inputs, config, ... }: {

  flake.nixosModules.neko = { lib, config, pkgs, ... }: {

    virtualisation.oci-containers.containers.neko = let
      mainDir = "/home/n0ll/.config/mozilla/firefox"
    in {

      image = "m1k1o/neko";
      pull = "newer";
      ports = [
        "8080" 
        "52000-52100/udp"
      ];

      # TODO dir
      volumes = [
        "${mainDir}:/home/neko/.mozilla/firefox" # redirect config storage
      ];

      environment = {
        NEKO_DESKTOP_SCREEN = "1920x1080@30";
        NEKO_MEMBER_MULTIUSER_USER_PASSWORD = "neko";
        NEKO_MEMBER_MULTIUSER_ADMIN_PASSWORD = "admin";
        NEKO_WEBRTC_EPR = "52000-52100";
        NEKO_WEBRTC_ICELITE = 1;
        NEKO_WEBRTC_NAT1TO1 = "192.168.50.101";
      };

    };

}
