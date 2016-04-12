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
    
    dysnomia = {
      enable = true;
      
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
              target = config.services.dysnomia.containers.mysql-database // {
                hostname = "localhost";
              };
            };
          };
          
          StaffService = customPkgs.StaffServiceWrapper {
            staff = {
              name = "staff";
              target = config.services.dysnomia.containers.mysql-database // {
                hostname = "localhost";
              };
            };
          };
          
          ZipcodeService = customPkgs.ZipcodeServiceWrapper {
            zipcodes = {
              name = "zipcodes";
              target = config.services.dysnomia.containers.mysql-database // {
                hostname = "localhost";
              };
            };
          };
          
          StaffTracker = customPkgs.StaffTracker {
            GeolocationService = {
              name = "GeolocationService";
              target = config.services.dysnomia.containers.tomcat-webapplication // {
                hostname = "localhost";
              };
            };
            RoomService = {
              name = "RoomService";
              target = config.services.dysnomia.containers.tomcat-webapplication // {
                hostname = "localhost";
              };
            };
            StaffService = {
              name = "StaffService";
              target = config.services.dysnomia.containers.tomcat-webapplication // {
                hostname = "localhost";
              };
            };
            ZipcodeService = {
              name = "ZipcodeService";
              target = config.services.dysnomia.containers.tomcat-webapplication // {
                hostname = "localhost";
              };
            };
          };
        };
      };
    };
  };
}
