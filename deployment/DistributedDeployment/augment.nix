{infrastructure, lib}:

lib.mapAttrs (targetName: target:
  target // (if target ? containers && target.containers ? mysql-database then {
    containers = target.containers // {
      mysql-database = target.containers.mysql-database //
        { mysqlUsername = "root";
          mysqlPassword = builtins.readFile ../configurations/mysqlpw;
        };
    };
  } else {})
) infrastructure
