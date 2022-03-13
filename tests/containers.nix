{disnixos, tarball, pkgs, manifest}:

disnixos.disnixTest {
  name = "disnix-stafftracker-java-example-containers-tests";
  inherit tarball manifest;
  networkFile = "deployment/DistributedDeployment/network-bare.nix";
  testScript =
    ''
      socket_file = "/run/mysqld/mysqld.sock"

      test2.wait_for_file(socket_file)
      test2.succeed(
          "echo 'show databases;' | ${pkgs.mariadb}/bin/mysql"
      )

      test1.wait_for_file("/var/tomcat/webapps")
      test1.succeed("sleep 10; curl http://localhost:8080")

      test2.wait_for_file("/var/tomcat/webapps")
      test2.succeed("sleep 10; curl http://localhost:8080")
    '';
}
