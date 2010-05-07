{stdenv}:

stdenv.mkDerivation {
  name = "rooms";
  src = ../../../../services/databases/rooms;
  installPhase = ''
    ensureDir $out/mysql-databases
    cp *.sql $out/mysql-databases
  '';
}
