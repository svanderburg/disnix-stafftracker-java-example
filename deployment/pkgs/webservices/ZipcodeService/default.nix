{stdenv, apacheAnt, axis2}:
{zipcodes}:

let
  contextXML = ''
    <Context>
      <Resource name="jdbc/ZipcodeDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${zipcodes.target.mysqlUsername}" password="${zipcodes.target.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${zipcodes.target.hostname}:${toString (zipcodes.target.mysqlPort)}/${zipcodes.name}?autoReconnect=true" />
    </Context>
  '';
in
stdenv.mkDerivation {
  name = "ZipcodeService";
  src = ../../../../services/webservices/ZipcodeService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    ensureDir $out/conf/Catalina
    cat > $out/conf/Catalina/ZipcodeService.xml <<EOF
    ${contextXML}
    EOF
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
