{stdenv}:

stdenv.mkDerivation {
  name = "zipcodes";
  src = ../../../../services/databases/zipcodes;
  installPhase = ''
    mkdir -p $out/mysql-databases
    cp *.sql $out/mysql-databases
  '';
}
