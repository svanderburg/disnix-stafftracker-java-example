{tarball, manifest, disnixos}:

disnixos.disnixTest {
  name = "disnix-stafftracker-java-example-tests";
  inherit tarball manifest;
  networkFile = "deployment/DistributedDeployment/network.nix";
  testScript =
    ''
      # Wait until the front-end application is deployed
      test2.wait_for_file("/var/tomcat/webapps/StaffTracker/stafftable.jsp")

      # Wait a little longer and capture the output of the entry page
      result = test3.succeed(
          "sleep 30; curl --fail http://test2:8080/StaffTracker/stafftable.jsp"
      )

      # The entry page should contain my name :-)

      if "Sander" in result:
          print("Entry page contains Sander!")
      else:
          raise Exception("Entry page should contain Sander!")

      # Start Firefox and take a screenshot

      test3.succeed("firefox http://test2:8080/StaffTracker &")
      test3.wait_for_window("Firefox")
      test3.succeed("sleep 30")
      test3.screenshot("screen")
    '';
}
