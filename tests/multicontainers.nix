{disnixos, tarball, pkgs, manifest}:

disnixos.disnixTest {
  name = "disnix-stafftracker-java-example-multicontainers-tests";
  inherit tarball manifest;
  networkFile = "deployment/DistributedDeployment/network-bare.nix";
  testScript =
    ''
      test2.wait_for_file("/var/tomcat-primary/webapps")
      test2.succeed("sleep 10; curl http://localhost:8080")
      test2.wait_for_file("/var/tomcat-secondary/webapps")
      test2.succeed("sleep 10; curl http://localhost:8081")

      socket_primary = "/run/mysqld-primary/mysqld.sock"
      test1.wait_for_file(socket_primary)
      test1.succeed(
          "echo 'show databases;' | ${pkgs.mariadb}/bin/mysql --socket={}".format(
              socket_primary
          )
      )

      socket_secondary = "/run/mysqld-secondary/mysqld.sock"
      test1.wait_for_file(socket_secondary)
      test1.succeed(
          "echo 'show databases;' | ${pkgs.mariadb}/bin/mysql --socket={}".format(
              socket_secondary
          )
      )
    '';
}
