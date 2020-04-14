{distribution, invDistribution, system, pkgs}:

let customPkgs = import ../top-level/all-packages.nix { inherit system pkgs; };
in
rec {
### Databases

  rooms = rec {
    name = "rooms";
    mysqlUsername = "rooms";
    mysqlPassword = "rooms";
    pkg = customPkgs.rooms {
      inherit mysqlUsername mysqlPassword;
    };
    dependsOn = {};
    type = "mysql-database";
  };

  staff = rec {
    name = "staff";
    mysqlUsername = "staff";
    mysqlPassword = "staff";
    pkg = customPkgs.staff {
      inherit mysqlUsername mysqlPassword;
    };
    dependsOn = {};
    type = "mysql-database";
  };

  zipcodes = rec {
    name = "zipcodes";
    mysqlUsername = "zipcodes";
    mysqlPassword = "zipcodes";
    pkg = customPkgs.zipcodes {
      inherit mysqlUsername mysqlPassword;
    };
    dependsOn = {};
    type = "mysql-database";
  };

### Web services

  GeolocationService = {
    name = "GeolocationService";
    pkg = customPkgs.GeolocationService;
    dependsOn = {};
    type = "tomcat-webapplication";
  };

  RoomService = {
    name = "RoomService";
    pkg = customPkgs.RoomServiceWrapper;
    dependsOn = {
      inherit rooms;
    };
    type = "tomcat-webapplication";
  };

  StaffService = {
    name = "StaffService";
    pkg = customPkgs.StaffServiceWrapper;
    dependsOn = {
      inherit staff;
    };
    type = "tomcat-webapplication";
  };

  ZipcodeService = {
    name = "ZipcodeService";
    pkg = customPkgs.ZipcodeServiceWrapper;
    dependsOn = {
      inherit zipcodes;
    };
    type = "tomcat-webapplication";
  };

### Web applications

  StaffTracker = {
    name = "StaffTracker";
    pkg = customPkgs.StaffTracker;
    dependsOn = {
      inherit GeolocationService RoomService StaffService ZipcodeService;
    };
    type = "tomcat-webapplication";
  };
}
