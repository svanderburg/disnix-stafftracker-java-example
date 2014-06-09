{system, pkgs}:

rec {
### Databases

  rooms = import ../pkgs/databases/rooms {
    inherit (pkgs) stdenv;
  };
  
  staff = import ../pkgs/databases/staff {
    inherit (pkgs) stdenv;
  };
  
  zipcodes = import ../pkgs/databases/zipcodes {
    inherit (pkgs) stdenv;
  };

### Web services + Clients

  GeolocationService = import ../pkgs/webservices/GeolocationService {
    inherit (pkgs) stdenv apacheAnt jdk axis2 geoipjava;
  };

  GeolocationServiceClient = import ../pkgs/webservices/GeolocationServiceClient {
    inherit (pkgs) stdenv apacheAnt jdk axis2 geoipjava;
  };
  
  RoomService = import ../pkgs/webservices/RoomService {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
  };
  
  RoomServiceWrapper = import ../pkgs/webservices/RoomService/wrapper.nix {
    inherit (pkgs) stdenv;
    inherit RoomService;
  };
  
  RoomServiceClient = import ../pkgs/webservices/RoomServiceClient {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
  };

  StaffService = import ../pkgs/webservices/StaffService {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
  };
  
  StaffServiceWrapper = import ../pkgs/webservices/StaffService/wrapper.nix {
    inherit (pkgs) stdenv;
    inherit StaffService;
  };
  
  StaffServiceClient = import ../pkgs/webservices/StaffServiceClient {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
  };
    
  ZipcodeService = import ../pkgs/webservices/ZipcodeService {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
  };
  
  ZipcodeServiceWrapper = import ../pkgs/webservices/ZipcodeService/wrapper.nix {
    inherit (pkgs) stdenv;
    inherit ZipcodeService;
  };
  
  ZipcodeServiceClient = import ../pkgs/webservices/ZipcodeServiceClient {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
  };

### Web applications

  StaffTracker = import ../pkgs/webapplications/StaffTracker {
    inherit (pkgs) stdenv apacheAnt jdk axis2;
    inherit GeolocationServiceClient RoomServiceClient StaffServiceClient ZipcodeServiceClient;
  };
}
