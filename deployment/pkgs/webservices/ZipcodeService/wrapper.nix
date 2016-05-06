{stdenv, ZipcodeService}:
{zipcodes}:

let
  contextXML = ''
    <Context>
      <Resource name="jdbc/ZipcodeDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${zipcodes.target.container.mysqlUsername}" password="${zipcodes.target.container.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${zipcodes.target.properties.hostname}:${toString (zipcodes.target.container.mysqlPort)}/${zipcodes.name}?autoReconnect=true" />
    </Context>
  '';
in
stdenv.mkDerivation {
  name = "ZipcodeService";
  buildCommand = ''
    mkdir -p $out/conf/Catalina
    cat > $out/conf/Catalina/ZipcodeService.xml <<EOF
    ${contextXML}
    EOF
    ln -sf ${ZipcodeService}/webapps $out/webapps
  '';
}
