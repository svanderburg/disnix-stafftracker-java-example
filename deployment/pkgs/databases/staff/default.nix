{stdenv}:

stdenv.mkDerivation {
  name = "staff";
  src = ../../../../services/databases/staff;
  installPhase = ''
    ensureDir $out/mysql-databases
    cp *.sql $out/mysql-databases
  '';
}
