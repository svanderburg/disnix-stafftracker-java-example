{system ? builtins.currentSystem}:

let pkgs = import (builtins.getEnv "NIXPKGS_ALL") { inherit system; };
in
with pkgs;

rec {
### Databases

  rooms = import ../pkgs/databases/rooms {
    inherit stdenv;
  };
  
  staff = import ../pkgs/databases/staff {
    inherit stdenv;
  };
  
  zipcodes = import ../pkgs/databases/zipcodes {
    inherit stdenv;
  };

### Web services + Clients

  GeolocationService = import ../pkgs/webservices/GeolocationService {
    inherit stdenv apacheAnt axis2 geoipjava;
  };

  GeolocationServiceClient = import ../pkgs/webservices/GeolocationServiceClient {
    inherit stdenv apacheAnt axis2 geoipjava;
  };
  
  RoomService = import ../pkgs/webservices/RoomService {
    inherit stdenv apacheAnt axis2;
  };
  
  RoomServiceClient = import ../pkgs/webservices/RoomServiceClient {
    inherit stdenv apacheAnt axis2;
  };

  StaffService = import ../pkgs/webservices/StaffService {
    inherit stdenv apacheAnt axis2;
  };
  
  StaffServiceClient = import ../pkgs/webservices/StaffServiceClient {
    inherit stdenv apacheAnt axis2;
  };
    
  ZipcodeService = import ../pkgs/webservices/ZipcodeService {
    inherit stdenv apacheAnt axis2;
  };
  
  ZipcodeServiceClient = import ../pkgs/webservices/ZipcodeServiceClient {
    inherit stdenv apacheAnt axis2;
  };

### Web applications

  StaffTracker = import ../pkgs/webapplications/StaffTracker {
    inherit stdenv apacheAnt axis2;
    inherit GeolocationServiceClient RoomServiceClient StaffServiceClient ZipcodeServiceClient;
  };
}
