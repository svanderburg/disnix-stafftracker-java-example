/*
 * This Nix expression captures all the machines in the network and its properties
 */
{
  test1 = {
    system = "x86_64-linux";
    
    properties = {
      hostname = "10.0.2.2";
      targetEPR = http://10.0.2.2:8080/DisnixWebService/services/DisnixWebService;
      sshTarget = "localhost:2222";
      supportedTypes = [ "tomcat-webapplication" "process" "wrapper" ];
    };
    
    containers = {
      tomcat-webapplication = {
        tomcatPort = 8081;
      };
    };
  };
  
  test2 = {
    system = "x86_64-linux";
    
    properties = {
      hostname = "10.0.2.3";
      targetEPR = http://10.0.2.3:8080/DisnixWebService/services/DisnixWebService;
      sshTarget = "localhost:2223";
      supportedTypes = [ "tomcat-webapplication" "process" "wrapper" "mysql-database" ];
    };
    
    containers = {
      tomcat-webapplication = {
        tomcatPort = 8082;
      };
      
      mysql-database = {
        mysqlPort = 3307;
        mysqlUsername = "root";
        mysqlPassword = builtins.readFile ../configurations/mysqlpw;
      };
    };
  };
}
