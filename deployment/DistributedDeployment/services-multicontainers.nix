{distribution, invDistribution, system, pkgs}:

let customPkgs = import ../top-level/all-packages.nix { inherit system pkgs; };
in
rec {
  mysql-production = {
    name = "mysql-production";
    pkg = customPkgs.mysql-production;
    dependsOn = {};
    type = "wrapper";
  };

  mysql-test = {
    name = "mysql-test";
    pkg = customPkgs.mysql-test;
    dependsOn = {};
    type = "wrapper";
  };

  tomcat-production = {
    name = "tomcat-production";
    pkg = customPkgs.tomcat-production;
    dependsOn = {};
    type = "wrapper";
  };

  tomcat-test = {
    name = "tomcat-test";
    pkg = customPkgs.tomcat-test;
    dependsOn = {};
    type = "wrapper";
  };
}
