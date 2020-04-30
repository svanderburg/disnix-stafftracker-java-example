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
in
rec {
  simpleAppservingTomcat-primary = constructors.simpleAppservingTomcat {
    instanceSuffix = "-primary";
    httpPort = 8080;
    httpsPort = 8443;
    serverPort = 8005;
    ajpPort = 8009;
    commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
    type = processType;
  };

  simpleAppservingTomcat-secondary = constructors.simpleAppservingTomcat {
    instanceSuffix = "-secondary";
    httpPort = 8081;
    httpsPort = 8444;
    serverPort = 8006;
    ajpPort = 8010;
    commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
    type = processType;
  };

  mysql-primary = constructors.mysql {
    instanceSuffix = "-primary";
    port = 3306;
    type = processType;
  };

  mysql-secondary = constructors.mysql {
    instanceSuffix = "-secondary";
    port = 3307;
    type = processType;
  };
}
