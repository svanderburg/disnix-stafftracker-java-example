{pkgs, config, ...}:

let
  customPkgs = import ../top-level/all-packages.nix {
    inherit pkgs;
    inherit (pkgs.stdenv) system;
  };

  mysqlUsername = "root";
  mysqlPassword = "";
in
{
  networking.firewall.allowedTCPPorts = [ 8080 ];

  services = {
    openssh.enable = true;

    mysql = {
      enable = true;
      package = pkgs.mysql;
    };

    tomcat = {
      enable = true;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      catalinaOpts = "-Xms64m -Xmx256m";
    };
  };

  dysnomia = {
    enable = true;
    enableAuthentication = true;

    components = {
      mysql-database = {
        rooms = customPkgs.rooms { inherit mysqlUsername mysqlPassword; };
        staff = customPkgs.staff { inherit mysqlUsername mysqlPassword; };
        zipcodes = customPkgs.zipcodes { inherit mysqlUsername mysqlPassword; };
      };

      tomcat-webapplication = {
        GeolocationService = customPkgs.GeolocationService;

        RoomService = customPkgs.RoomServiceWrapper {
          rooms = {
            name = "rooms";
            inherit mysqlUsername mysqlPassword;
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.mysql-database;
            };
          };
        };

        StaffService = customPkgs.StaffServiceWrapper {
          staff = {
            name = "staff";
            inherit mysqlUsername mysqlPassword;
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.mysql-database;
            };
          };
        };

        ZipcodeService = customPkgs.ZipcodeServiceWrapper {
          zipcodes = {
            name = "zipcodes";
            inherit mysqlUsername mysqlPassword;
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.mysql-database;
            };
          };
        };

        StaffTracker = customPkgs.StaffTracker {
          GeolocationService = {
            name = "GeolocationService";
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.tomcat-webapplication;
            };
          };
          RoomService = {
            name = "RoomService";
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.tomcat-webapplication;
            };
          };
          StaffService = {
            name = "StaffService";
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.tomcat-webapplication;
            };
          };
          ZipcodeService = {
            name = "ZipcodeService";
            target = {
              properties = {
                hostname = "localhost";
              };
              container = config.dysnomia.containers.tomcat-webapplication;
            };
          };
        };
      };
    };
  };
}
