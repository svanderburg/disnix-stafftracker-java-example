{stdenv, apacheAnt, jdk8, axis2, geoipjava}:

stdenv.mkDerivation {
  name = "GeolocationServiceClient";
  src = ../../../../services/webservices/GeolocationService;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  GEOIPJAVA_LIB = "${geoipjava}/share/java";
  buildPhase = "ant generate.client.jar";
  installPhase = ''
    mkdir -p $out/share/java
    cp *.jar $out/share/java
  '';
}
