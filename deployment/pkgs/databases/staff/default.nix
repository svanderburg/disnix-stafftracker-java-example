{stdenv}:

stdenv.mkDerivation {
  name = "staff";
  src = ../../../../services/databases/staff;
  installPhase = ''
    mkdir -p $out/mysql-databases
    cp *.sql $out/mysql-databases
  '';
}
