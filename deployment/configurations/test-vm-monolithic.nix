{pkgs, config, ...}:

let
  customPkgs = import ../top-level/all-packages.nix {
    inherit pkgs;
    inherit (pkgs.stdenv) system;
  };
in
{
  networking.firewall.allowedTCPPorts = [ 8080 ];
  
  services = {
    openssh.enable = true;
    
    mysql = {
      enable = true;
      package = pkgs.mysql;
      rootPassword = ../configurations/mysqlpw;
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
        rooms = customPkgs.rooms;
        
        staff = customPkgs.staff;
        
        zipcodes = customPkgs.zipcodes;
      };
      
      tomcat-webapplication = {
        GeolocationService = customPkgs.GeolocationService;
        
        RoomService = customPkgs.RoomServiceWrapper {
          rooms = {
            name = "rooms";
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
