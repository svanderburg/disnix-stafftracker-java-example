{stdenv, apacheAnt, jdk8, axis2}:

stdenv.mkDerivation {
  name = "ZipcodeServiceClient";
  src = ../../../../services/webservices/ZipcodeService;
  buildInputs = [ apacheAnt jdk8 ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = "ant generate.client.jar";
  installPhase = ''
    mkdir -p $out/share/java
    cp *.jar $out/share/java
  '';
}
