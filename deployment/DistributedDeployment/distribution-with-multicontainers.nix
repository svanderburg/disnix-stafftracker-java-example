{infrastructure}:

{
  # Container providers

  mysql-primary = [ infrastructure.test1 ];
  mysql-secondary = [ infrastructure.test1 ];
  tomcat-primary = [ infrastructure.test2 ];
  tomcat-secondary = [ infrastructure.test2 ];

  # Application components

  GeolocationService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-webapplication-primary"; } ];
  };
  RoomService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-webapplication-secondary"; } ];
  };
  StaffService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-webapplication-primary"; } ];
  };
  StaffTracker = {
    targets = [ { target = infrastructure.test2; container = "tomcat-webapplication-secondary"; } ];
  };
  ZipcodeService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-webapplication-primary"; } ];
  };
  rooms = {
    targets = [ { target = infrastructure.test1; container = "mysql-database-primary"; } ];
  };
  staff = {
    targets = [ { target = infrastructure.test1; container = "mysql-database-secondary"; } ];
  };
  zipcodes = {
    targets = [ { target = infrastructure.test1; container = "mysql-database-primary"; } ];
  };
}
