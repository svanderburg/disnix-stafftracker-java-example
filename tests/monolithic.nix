{nixpkgs ? <nixpkgs>}:

with import "${nixpkgs}/nixos/lib/testing-python.nix" { system = builtins.currentSystem; };

simpleTest {
  nodes = {
    test1 = import ../deployment/configurations/test-vm-monolithic.nix;
  };
  testScript =
    ''
      start_all()

      # Wait for the relevant system services to start
      test1.wait_for_unit("mysql")
      test1.wait_for_unit("tomcat")

      # Deploy the mutable components part of the NixOS configuration
      test1.succeed("dysnomia-containers --deploy")

      # Wait until the front-end application is deployed
      test1.wait_for_file("/var/tomcat/webapps/StaffTracker/stafftable.jsp")

      # Wait a little longer and capture the output of the entry page
      result = test1.succeed(
          "sleep 30; curl --fail http://localhost:8080/StaffTracker/stafftable.jsp"
      )

      # The entry page should contain my name :-)

      if "Sander" in result:
          print("Entry page contains Sander!")
      else:
          raise Exception("Entry page should contain Sander!")
  '';
}
