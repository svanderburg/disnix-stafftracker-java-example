{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "systemd"
}:

let
  processType =
    if processManager == null then "managed-process"
    else if processManager == "sysvinit" then "sysvinit-script"
    else if processManager == "systemd" then "systemd-unit"
    else if processManager == "supervisord" then "supervisord-program"
    else if processManager == "bsdrc" then "bsdrc-script"
    else if processManager == "cygrunsrv" then "cygrunsrv-service"
    else if processManager == "launchd" then "launchd-daemon"
    else throw "Unknown process manager: ${processManager}";

  constructors = import ../../../nix-processmgmt/examples/service-containers-agnostic/constructors.nix {
    inherit pkgs stateDir runtimeDir logDir cacheDir tmpDir forceDisableUserChange processManager;
  };

  applicationServices = import ./services.nix {
    inherit pkgs system distribution invDistribution;
  };
in
rec {
  simple-appserving-tomcat = rec {
    name = "simple-appserving-tomcat";

    tomcatPort = 8080;

    pkg = constructors.simple-appserving-tomcat {
      httpPort = tomcatPort;
      commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
    };

    providesContainer = "tomcat-webapplication";
    type = processType;
  };

  mysql = rec {
    name = "mysql";
    mysqlPort = 3306;

    pkg = constructors.mysql {
      port = mysqlPort;
    };

    providesContainer = "mysql-database";
    type = processType;
  };
} // applicationServices
