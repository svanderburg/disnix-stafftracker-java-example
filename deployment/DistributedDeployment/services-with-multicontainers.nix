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
  simple-appserving-tomcat-primary =
    let
      instanceSuffix = "-primary";
    in
    rec {
      name = "simple-appserving-tomcat${instanceSuffix}";

      tomcatPort = 8080;
      catalinaBaseDir = "${stateDir}/tomcat${instanceSuffix}";

      pkg = constructors.simple-appserving-tomcat {
        inherit instanceSuffix;
        httpPort = tomcatPort;
        httpsPort = 8443;
        serverPort = 8005;
        ajpPort = 8009;
        commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      };

      providesContainer = "tomcat-webapplication${instanceSuffix}";
      type = processType;
    };

  simple-appserving-tomcat-secondary =
    let
      instanceSuffix = "-secondary";
    in
    rec {
      name = "simple-appserving-tomcat${instanceSuffix}";

      tomcatPort = 8081;
      catalinaBaseDir = "${stateDir}/tomcat${instanceSuffix}";

      pkg = constructors.simple-appserving-tomcat {
        inherit instanceSuffix;
        httpPort = tomcatPort;
        httpsPort = 8444;
        serverPort = 8006;
        ajpPort = 8010;
        commonLibs = [ "${pkgs.mysql_jdbc}/share/java/mysql-connector-java.jar" ];
      };

      providesContainer = "tomcat-webapplication${instanceSuffix}";
      type = processType;
    };

  mysql-primary =
    let
      instanceSuffix = "-primary";
    in
    rec {
      name = "mysql${instanceSuffix}";
      mysqlPort = 3306;
      mysqlSocket = "${runtimeDir}/mysqld${instanceSuffix}/mysqld${instanceSuffix}.sock";

      pkg = constructors.mysql {
        inherit instanceSuffix;
        port = mysqlPort;
      };

      providesContainer = "mysql-database${instanceSuffix}";
      type = processType;
    };

  mysql-secondary =
    let
      instanceSuffix = "-secondary";
    in
    rec {
      name = "mysql${instanceSuffix}";
      mysqlPort = 3307;
      mysqlSocket = "${runtimeDir}/mysqld${instanceSuffix}/mysqld${instanceSuffix}.sock";

      pkg = constructors.mysql {
        inherit instanceSuffix;
        port = mysqlPort;
      };

      providesContainer = "mysql-database${instanceSuffix}";
      type = processType;
    };
} // applicationServices
