{infrastructure}:

{
  GeolocationService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-test"; } ];
  };
  RoomService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-production"; } ];
  };
  StaffService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-test"; } ];
  };
  StaffTracker = {
    targets = [ { target = infrastructure.test2; container = "tomcat-production"; } ];
  };
  ZipcodeService = {
    targets = [ { target = infrastructure.test2; container = "tomcat-test"; } ];
  };
  rooms = {
    targets = [ { target = infrastructure.test1; container = "mysql-production"; } ];
  };
  staff = {
    targets = [ { target = infrastructure.test1; container = "mysql-test"; } ];
  };
  zipcodes = {
    targets = [ { target = infrastructure.test1; container = "mysql-production"; } ];
  };
}
