{ stdenv, apacheAnt, jdk8, axis2
, GeolocationServiceClient, RoomServiceClient, StaffServiceClient, ZipcodeServiceClient}:
{GeolocationService, RoomService, StaffService, ZipcodeService}:

stdenv.mkDerivation {
  name = "StaffTracker";
  src = ../../../../services/webapplications/StaffTracker;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  GEOLOCATIONSERVICECLIENT_LIB = "${GeolocationServiceClient}/share/java";
  ROOMSERVICECLIENT_LIB = "${RoomServiceClient}/share/java";
  STAFFSERVICECLIENT_LIB = "${StaffServiceClient}/share/java";
  ZIPCODESERVICECLIENT_LIB = "${ZipcodeServiceClient}/share/java";
  buildPhase = ''
    cat > src/org/nixos/disnix/example/webservices/stafftracker.properties <<EOF
    geolocationservice.url=http://${GeolocationService.target.properties.hostname}:${toString (GeolocationService.target.container.tomcatPort)}/${GeolocationService.name}/services/${GeolocationService.name}
    roomservice.url=http://${RoomService.target.properties.hostname}:${toString (RoomService.target.container.tomcatPort)}/${RoomService.name}/services/${RoomService.name}
    staffservice.url=http://${StaffService.target.properties.hostname}:${toString (StaffService.target.container.tomcatPort)}/${StaffService.name}/services/${StaffService.name}
    zipcodeservice.url=http://${ZipcodeService.target.properties.hostname}:${toString (ZipcodeService.target.container.tomcatPort)}/${ZipcodeService.name}/services/${ZipcodeService.name}
    EOF
    ant generate.war
  '';
  installPhase = ''
    mkdir -p $out/webapps
    cp *.war $out/webapps
  '';
}
