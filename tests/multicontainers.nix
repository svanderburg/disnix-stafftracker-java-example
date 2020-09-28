{disnixos, tarball, pkgs, manifest}:

disnixos.disnixTest {
  name = "disnix-stafftracker-java-example-multicontainers-tests";
  inherit tarball manifest;
  networkFile = "deployment/DistributedDeployment/network-bare.nix";
  testScript =
    ''
      test2.wait_for_file("/var/tomcat-production/webapps")
      test2.succeed("sleep 10; curl http://localhost:8080")
      test2.wait_for_file("/var/tomcat-test/webapps")
      test2.succeed("sleep 10; curl http://localhost:8081")

      test1.wait_for_file("/run/mysqld-production/mysqld.sock")
      test1.succeed(
          "echo 'show databases;' | ${pkgs.mysql}/bin/mysql --socket=/run/mysqld-production/mysqld.sock --user=root --password=secret"
      )
      test1.wait_for_file("/run/mysqld-test/mysqld.sock")
      test1.mustSucceed(
          "echo 'show databases;' | ${pkgs.mysql}/bin/mysql --socket=/run/mysqld-test/mysqld.sock --user=root --password=secret"
      )
    '';
}
