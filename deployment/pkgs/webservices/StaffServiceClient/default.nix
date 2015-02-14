{stdenv, apacheAnt, jdk, axis2}:

stdenv.mkDerivation {
  name = "StaffServiceClient";
  src = ../../../../services/webservices/StaffService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = "ant generate.client.jar";
  installPhase = ''
    mkdir -p $out/share/java
    cp *.jar $out/share/java
  '';
}
