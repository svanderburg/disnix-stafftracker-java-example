{stdenv, apacheAnt, jdk, axis2}:

stdenv.mkDerivation {
  name = "RoomServiceClient";
  src = ../../../../services/webservices/RoomService;
  buildInputs = [ apacheAnt jdk ];
  AXIS2_LIB = "${axis2}/lib";
  buildPhase = "ant generate.client.jar";
  installPhase = ''
    ensureDir $out/share/java
    cp *.jar $out/share/java
  '';
}
