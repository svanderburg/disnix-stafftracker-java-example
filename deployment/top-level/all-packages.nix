{system, pkgs}:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = {

### Databases

    rooms = callPackage ../pkgs/databases/rooms { };

    staff = callPackage ../pkgs/databases/staff { };

    zipcodes = callPackage ../pkgs/databases/zipcodes { };

### Web services + Clients

    GeolocationService = callPackage ../pkgs/webservices/GeolocationService { };

    GeolocationServiceClient = callPackage ../pkgs/webservices/GeolocationServiceClient { };

    RoomService = callPackage ../pkgs/webservices/RoomService { };

    RoomServiceWrapper = callPackage ../pkgs/webservices/RoomService/wrapper.nix { };

    RoomServiceClient = callPackage ../pkgs/webservices/RoomServiceClient { };

    StaffService = callPackage ../pkgs/webservices/StaffService { };

    StaffServiceWrapper = callPackage ../pkgs/webservices/StaffService/wrapper.nix { };

    StaffServiceClient = callPackage ../pkgs/webservices/StaffServiceClient { };

    ZipcodeService = callPackage ../pkgs/webservices/ZipcodeService { };

    ZipcodeServiceWrapper = callPackage ../pkgs/webservices/ZipcodeService/wrapper.nix { };

    ZipcodeServiceClient = callPackage ../pkgs/webservices/ZipcodeServiceClient { };

### Web applications

    StaffTracker = callPackage ../pkgs/webapplications/StaffTracker { };

### Containers

    mysql-database = callPackage ../pkgs/containers/mysql-database {
      dysnomia = pkgs.dysnomia.override (origArgs: {
        enableMySQLDatabase = true;
      });
    };

    tomcat-webapplication = callPackage ../pkgs/containers/tomcat-webapplication {
      tomcat = pkgs.tomcat8;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      dysnomia = pkgs.dysnomia.override (origArgs: {
        enableTomcatWebApplication = true;
      });
    };

### Multi-containers

    mysql-production = callPackage ../pkgs/containers/mysql-database {
      dysnomia = pkgs.dysnomia.override (origArgs: {
        enableMySQLDatabase = true;
      });
      name = "mysql-production";
      user = "mysql-production";
      group = "mysql-production";
      dataDir = "/var/db/mysql-production";
      pidDir = "/run/mysqld-production";
      port = 3306;
    };

    mysql-test = callPackage ../pkgs/containers/mysql-database {
      dysnomia = pkgs.dysnomia.override (origArgs: {
        enableMySQLDatabase = true;
      });
      name = "mysql-test";
      user = "mysql-test";
      group = "mysql-test";
      dataDir = "/var/db/mysql-test";
      pidDir = "/run/mysqld-test";
      port = 3307;
    };

    tomcat-production = callPackage ../pkgs/containers/tomcat-webapplication {
      tomcat = pkgs.tomcat8;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      dysnomia = pkgs.dysnomia.override (origArgs: {
        enableTomcatWebApplication = true;
      });
      name = "tomcat-production";
      baseDir = "/var/tomcat-production";
      user = "tomcat-prod";
      group = "tomcat-prod";
      serverPort = 8005;
      httpPort = 8080;
      httpsPort = 8443;
      ajpPort = 8009;
    };

    tomcat-test = callPackage ../pkgs/containers/tomcat-webapplication {
      tomcat = pkgs.tomcat8;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      dysnomia = pkgs.dysnomia.override (origArgs: {
        enableTomcatWebApplication = true;
      });
      name = "tomcat-test";
      baseDir = "/var/tomcat-test";
      user = "tomcat-test";
      group = "tomcat-test";
      serverPort = 8006;
      httpPort = 8081;
      httpsPort = 8444;
      ajpPort = 8010;
    };

  };
in
self
