{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, spoolDir ? "${stateDir}/spool"
, libDir ? "${stateDir}/lib"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "systemd"
, nix-processmgmt ? ../../../nix-processmgmt
, nix-processmgmt-services ? ../../../nix-processmgmt-services
}@args:

let
  containerServices = import ./services-containers.nix args;

  applicationServices = import ./services.nix {
    inherit pkgs system distribution invDistribution;
  };
in
containerServices // applicationServices
