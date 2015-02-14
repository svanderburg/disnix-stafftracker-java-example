{stdenv, apacheAnt, jdk, axis2}:

stdenv.mkDerivation {
  name = "ZipcodeServiceClient";
  src = ../../../../services/webservices/ZipcodeService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = "ant generate.client.jar";
  installPhase = ''
    mkdir -p $out/share/java
    cp *.jar $out/share/java
  '';
}
