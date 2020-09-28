{ nixpkgs ? <nixpkgs>
, disnix_stafftracker_java_example ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, systems ? [ "i686-linux" "x86_64-linux" ]
}:

let
  pkgs = import nixpkgs {};

  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs;
  };

  version = builtins.readFile ./version;

  jobs = rec {
    tarball = disnixos.sourceTarball {
      name = "disnix-stafftracker-java-example-zip";
      src = disnix_stafftracker_java_example;
      inherit officialRelease version;
    };

    build = {
      services = pkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
        };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-java-example";
          inherit tarball version;
          servicesFile = "deployment/DistributedDeployment/services.nix";
          networkFile = "deployment/DistributedDeployment/network.nix";
          distributionFile = "deployment/DistributedDeployment/distribution.nix";
        });

      containers = pkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
        };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-java-containers-example";
          inherit tarball version;
          servicesFile = "deployment/DistributedDeployment/services-containers.nix";
          networkFile = "deployment/DistributedDeployment/network-bare.nix";
          distributionFile = "deployment/DistributedDeployment/distribution-containers.nix";
        });

      multicontainers = pkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs { inherit system; };

          disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
            inherit nixpkgs system;
        };
        in
        disnixos.buildManifest {
          name = "disnix-stafftracker-java-multicontainers-example";
          inherit tarball version;
          servicesFile = "deployment/DistributedDeployment/services-multicontainers.nix";
          networkFile = "deployment/DistributedDeployment/network-bare.nix";
          distributionFile = "deployment/DistributedDeployment/distribution-multicontainers.nix";
        });
    };

    tests = {
      services = import ./tests/services.nix {
        inherit tarball disnixos;
        manifest = builtins.getAttr (builtins.currentSystem) (build.services);
      };

      monolithic = import ./tests/monolithic.nix {
        inherit nixpkgs;
      };

      containers = import ./tests/containers.nix {
        inherit tarball disnixos pkgs;
        manifest = builtins.getAttr (builtins.currentSystem) (build.containers);
      };

      multicontainers = import ./tests/multicontainers.nix {
        inherit tarball disnixos pkgs;
        manifest = builtins.getAttr (builtins.currentSystem) (build.multicontainers);
      };
    };
  };
in
jobs
