{stdenv, apacheAnt, jdk8, axis2}:

stdenv.mkDerivation {
  name = "StaffService";
  src = ../../../../services/webservices/StaffService;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    mkdir -p $out/webapps
    cp *.war $out/webapps
  '';
}
