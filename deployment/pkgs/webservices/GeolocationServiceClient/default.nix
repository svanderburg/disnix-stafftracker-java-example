{stdenv, apacheAnt, jdk, axis2, geoipjava}:

stdenv.mkDerivation {
  name = "GeolocationServiceClient";
  src = ../../../../services/webservices/GeolocationService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  GEOIPJAVA_LIB = "${geoipjava}/share/java";
  buildPhase = "ant generate.client.jar";
  installPhase = ''
    ensureDir $out/share/java
    cp *.jar $out/share/java
  '';
}
