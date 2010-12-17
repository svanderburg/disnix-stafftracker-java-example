{ nixpkgs ? /etc/nixos/nixpkgs
, nixos ? /etc/nixos/nixos
, system ? builtins.currentSystem
}:

let
  pkgs = import nixpkgs { inherit system; };
  
  disnixos = import "${pkgs.disnixos}/share/disnixos/testing.nix" {
    inherit nixpkgs nixos system;
  };

  jobs = rec {
    tarball =
      { WebServicesExample ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false}:
    
      disnixos.sourceTarball {
        name = "WebServicesExample";
	version = builtins.readFile ./version;
	src = WebServicesExample;
        inherit officialRelease;
      };
      
    build =
      { tarball ? jobs.tarball {} }:
      
      disnixos.buildManifest {
        name = "WebServices";
	version = builtins.readFile ./version;
	inherit tarball;
	servicesFile = "deployment/DistributedDeployment/services.nix";
	networkFile = "deployment/DistributedDeployment/network.nix";
	distributionFile = "deployment/DistributedDeployment/distribution.nix";
      };
            
    tests = 

      disnixos.disnixTest {
        name = "WebServices";        
        tarball = tarball {};
        manifest = build {};
	networkFile = "deployment/DistributedDeployment/network.nix";
	testScript =
	  ''
	    $test2->waitForFile("/var/tomcat/webapps/StaffTracker/stafftable.jsp");	      
	    $test3->mustSucceed("sleep 30; curl --fail http://test2:8080/StaffTracker/stafftable.jsp >&2");
	      
	    $test3->mustSucceed("firefox http://test2:8080/StaffTracker &");
	    $test3->mustSucceed("sleep 10");
	      
	    $test3->screenshot("screen");
	  '';
      };              
  };
in
jobs
