{stdenv, apacheAnt, axis2}:
{staff}:

let
  contextXML = ''
    <Context>
      <Resource name="jdbc/StaffDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${staff.target.mysqlUsername}" password="${staff.target.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${staff.target.hostname}:${toString (staff.target.mysqlPort)}/${staff.name}?autoReconnect=true" />
    </Context>
  '';
in
stdenv.mkDerivation {
  name = "StaffService";
  src = ../../../../services/webservices/StaffService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    ensureDir $out/conf/Catalina
    cat > $out/conf/Catalina/StaffService.xml <<EOF
    ${contextXML}
    EOF
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
