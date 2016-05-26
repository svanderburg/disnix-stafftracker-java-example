{distribution, invDistribution, system, pkgs}:

let customPkgs = import ../top-level/all-packages.nix { inherit system pkgs; };
in
rec {
  mysql-database = {
    name = "mysql-database";
    pkg = customPkgs.mysql-database;
    dependsOn = {};
    type = "wrapper";
  };
  
  tomcat-webapplication = {
    name = "tomcat-webapplication";
    pkg = customPkgs.tomcat-webapplication;
    dependsOn = {};
    type = "wrapper";
  };
}
