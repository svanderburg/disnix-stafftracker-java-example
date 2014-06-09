{stdenv, apacheAnt, jdk, axis2}:

stdenv.mkDerivation {
  name = "StaffService";
  src = ../../../../services/webservices/StaffService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
