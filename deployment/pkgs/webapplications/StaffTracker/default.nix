{ stdenv, apacheAnt, jdk, axis2
, GeolocationServiceClient, RoomServiceClient, StaffServiceClient, ZipcodeServiceClient}:
{GeolocationService, RoomService, StaffService, ZipcodeService}:

stdenv.mkDerivation {
  name = "StaffTracker";
  src = ../../../../services/webapplications/StaffTracker;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  GEOLOCATIONSERVICECLIENT_LIB = "${GeolocationServiceClient}/share/java";
  ROOMSERVICECLIENT_LIB = "${RoomServiceClient}/share/java";
  STAFFSERVICECLIENT_LIB = "${StaffServiceClient}/share/java";
  ZIPCODESERVICECLIENT_LIB = "${ZipcodeServiceClient}/share/java";
  buildPhase = ''
    cat > src/org/nixos/disnix/example/webservices/stafftracker.properties <<EOF
    geolocationservice.url=http://${GeolocationService.target.hostname}:${toString (GeolocationService.target.tomcatPort)}/${GeolocationService.name}/services/${GeolocationService.name}
    roomservice.url=http://${RoomService.target.hostname}:${toString (RoomService.target.tomcatPort)}/${RoomService.name}/services/${RoomService.name}
    staffservice.url=http://${StaffService.target.hostname}:${toString (StaffService.target.tomcatPort)}/${StaffService.name}/services/${StaffService.name}
    zipcodeservice.url=http://${ZipcodeService.target.hostname}:${toString (ZipcodeService.target.tomcatPort)}/${ZipcodeService.name}/services/${ZipcodeService.name}
    EOF
    ant generate.war
  '';
  installPhase = ''
    mkdir -p $out/webapps
    cp *.war $out/webapps
  '';
}
