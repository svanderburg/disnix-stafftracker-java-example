{stdenv}:

stdenv.mkDerivation {
  name = "zipcodes";
  src = ../../../../services/databases/zipcodes;
  installPhase = ''
    ensureDir $out/mysql-databases
    cp *.sql $out/mysql-databases
  '';
}
