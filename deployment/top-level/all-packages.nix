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
  };
in
self
