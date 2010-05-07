{distribution, system}:

let pkgs = import ../top-level/all-packages.nix { inherit system; };
in
rec {
### Databases
  
  rooms = {
    name = "rooms";
    pkg = pkgs.rooms;
    dependsOn = {};
    type = "mysql-database";
  };
  
  staff = {
    name = "staff";
    pkg = pkgs.staff;
    dependsOn = {};
    type = "mysql-database";
  };
  
  zipcodes = {
    name = "zipcodes";
    pkg = pkgs.zipcodes;
    dependsOn = {};
    type = "mysql-database";
  };

### Web services

  GeolocationService = {
    name = "GeolocationService";
    pkg = pkgs.GeolocationService;
    dependsOn = {};
    type = "tomcat-webapplication";
  };
  
  RoomService = {
    name = "RoomService";
    pkg = pkgs.RoomService;
    dependsOn = {
      inherit rooms;
    };
    type = "tomcat-webapplication";
  };
  
  StaffService = {
    name = "StaffService";
    pkg = pkgs.StaffService;
    dependsOn = {
      inherit staff;
    };
    type = "tomcat-webapplication";
  };

  ZipcodeService = {
    name = "ZipcodeService";
    pkg = pkgs.ZipcodeService;
    dependsOn = {
      inherit zipcodes;
    };
    type = "tomcat-webapplication";
  };

### Web applications

  StaffTracker = {
    name = "StaffTracker";
    pkg = pkgs.StaffTracker;
    dependsOn = {
      inherit GeolocationService RoomService StaffService ZipcodeService;
    };
    type = "tomcat-webapplication";
  };
}
