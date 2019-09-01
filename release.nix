{ nixpkgs ? <nixpkgs>
, disnix_stafftracker_java_example ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};

  jobs = rec {
    tarball =
      let
        pkgs = import nixpkgs {};

        disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
          inherit nixpkgs;
        };
      in
      disnixos.sourceTarball {
        name = "disnix-stafftracker-java-example-zip";
        version = builtins.readFile ./version;
        src = disnix_stafftracker_java_example;
        inherit officialRelease;
      };

    build =
      pkgs.lib.genAttrs systems (system:
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
          };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-java-example";
          version = builtins.readFile ./version;
          inherit tarball;
          servicesFile = "deployment/DistributedDeployment/services.nix";
          networkFile = "deployment/DistributedDeployment/network.nix";
          distributionFile = "deployment/DistributedDeployment/distribution.nix";
        });

    tests = {
      services =
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs;
          };
        in
        disnixos.disnixTest {
          name = "disnix-stafftracker-java-example-tests";
          inherit tarball;
          manifest = builtins.getAttr (builtins.currentSystem) build;
          networkFile = "deployment/DistributedDeployment/network.nix";
          testScript =
            ''
              # Wait until the front-end application is deployed
              $test2->waitForFile("/var/tomcat/webapps/StaffTracker/stafftable.jsp");

              # Wait a little longer and capture the output of the entry page
              my $result = $test3->mustSucceed("sleep 30; curl --fail http://test2:8080/StaffTracker/stafftable.jsp");

              # The entry page should contain my name :-)

              if ($result =~ /Sander/) {
                  print "Entry page contains Sander!\n";
              }
              else {
                  die "Entry page should contain Sander!\n";
              }

              # Start Firefox and take a screenshot

              $test3->mustSucceed("firefox http://test2:8080/StaffTracker &");
              $test3->waitForWindow(qr/Firefox/);
              $test3->mustSucceed("sleep 30");
              $test3->screenshot("screen");
            '';
        };

      monolithic =
        with import "${nixpkgs}/nixos/lib/testing.nix" { system = builtins.currentSystem; };

        simpleTest {
          nodes = {
            test1 = import ./deployment/configurations/test-vm-monolithic.nix;
          };
          testScript = 
            ''
              startAll;

              # Wait for the relevant system services to start
              $test1->waitForJob("mysql");
              $test1->waitForJob("tomcat");

              # Deploy the mutable components part of the NixOS configuration
              $test1->mustSucceed("dysnomia-containers --deploy");

              # Wait until the front-end application is deployed
              $test1->waitForFile("/var/tomcat/webapps/StaffTracker/stafftable.jsp");

              # Wait a little longer and capture the output of the entry page
              my $result = $test1->mustSucceed("sleep 30; curl --fail http://localhost:8080/StaffTracker/stafftable.jsp");

              # The entry page should contain my name :-)

              if ($result =~ /Sander/) {
                  print "Entry page contains Sander!\n";
              } else {
                  die "Entry page should contain Sander!\n";
              }
          '';
        };

      containers =
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs;
          };

          manifest = disnixos.buildManifest {
            name = "disnix-stafftracker-java-containers-example";
            version = builtins.readFile ./version;
            inherit tarball;
            servicesFile = "deployment/DistributedDeployment/services-containers.nix";
            networkFile = "deployment/DistributedDeployment/network-bare.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-containers.nix";
          };
        in
        disnixos.disnixTest {
          name = "disnix-stafftracker-java-example-containers-tests";
          inherit tarball manifest;
          networkFile = "deployment/DistributedDeployment/network-bare.nix";
          testScript =
            ''
              $test2->waitForFile("/run/mysqld/mysqld.sock");
              $test2->mustSucceed("echo 'show databases;' | ${pkgs.mariadb}/bin/mysql --user=root --password=secret");

              $test1->waitForFile("/var/tomcat/webapps");
              $test1->mustSucceed("sleep 10; curl http://localhost:8080");

              $test2->waitForFile("/var/tomcat/webapps");
              $test2->mustSucceed("sleep 10; curl http://localhost:8080");
            '';
        };

      multicontainers =
        let
          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs;
          };

          manifest = disnixos.buildManifest {
            name = "disnix-stafftracker-java-multicontainers-example";
            version = builtins.readFile ./version;
            inherit tarball;
            servicesFile = "deployment/DistributedDeployment/services-multicontainers.nix";
            networkFile = "deployment/DistributedDeployment/network-bare.nix";
            distributionFile = "deployment/DistributedDeployment/distribution-multicontainers.nix";
          };
        in
        disnixos.disnixTest {
          name = "disnix-stafftracker-java-example-multicontainers-tests";
          inherit tarball manifest;
          networkFile = "deployment/DistributedDeployment/network-bare.nix";
          testScript =
            ''
              $test2->waitForFile("/var/tomcat-production/webapps");
              $test2->mustSucceed("sleep 10; curl http://localhost:8080");
              $test2->waitForFile("/var/tomcat-test/webapps");
              $test2->mustSucceed("sleep 10; curl http://localhost:8081");

              $test1->waitForFile("/run/mysqld-production/mysqld.sock");
              $test1->mustSucceed("echo 'show databases;' | ${pkgs.mariadb}/bin/mysql --socket=/run/mysqld-production/mysqld.sock --user=root --password=secret");
              $test1->waitForFile("/run/mysqld-test/mysqld.sock");
              $test1->mustSucceed("echo 'show databases;' | ${pkgs.mariadb}/bin/mysql --socket=/run/mysqld-test/mysqld.sock --user=root --password=secret");
            '';
        };
    };
  };
in
jobs
