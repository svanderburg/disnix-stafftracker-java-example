{ pkgs, system, distribution, invDistribution
, stateDir ? "/var"
, runtimeDir ? "${stateDir}/run"
, logDir ? "${stateDir}/log"
, cacheDir ? "${stateDir}/cache"
, tmpDir ? (if stateDir == "/var" then "/tmp" else "${stateDir}/tmp")
, forceDisableUserChange ? false
, processManager ? "systemd"
, nix-processmgmt ? ../../../nix-processmgmt
}@args:

let
  processType = import "${nix-processmgmt}/nixproc/derive-dysnomia-process-type.nix" {
    inherit processManager;
  };

  constructors = import "${nix-processmgmt}/examples/service-containers-agnostic/constructors.nix" {
    inherit pkgs stateDir runtimeDir logDir cacheDir tmpDir forceDisableUserChange processManager;
  };

  containerServicesForSupervisord = import ./services-containers.nix (args // {
    processManager = "supervisord";
  });

  applicationServices = import ./services.nix {
    inherit pkgs system distribution invDistribution;
  };
in
rec {
  supervisord = constructors.extendableSupervisord {
    type = processType;
  };
}
// containerServicesForSupervisord
// applicationServices
