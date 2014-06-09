{stdenv, apacheAnt, jdk, axis2, geoipjava}:

stdenv.mkDerivation {
  name = "GeolocationService";
  src = ../../../../services/webservices/GeolocationService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  GEOIPJAVA_LIB = "${geoipjava}/share/java";
  buildPhase = "ant generate.war";
  installPhase = ''
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
