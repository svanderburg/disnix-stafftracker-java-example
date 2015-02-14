{stdenv}:

stdenv.mkDerivation {
  name = "rooms";
  src = ../../../../services/databases/rooms;
  installPhase = ''
    mkdir -p $out/mysql-databases
    cp *.sql $out/mysql-databases
  '';
}
