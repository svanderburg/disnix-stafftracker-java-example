{stdenv, ZipcodeService}:
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
  buildCommand = ''
    ensureDir $out/conf/Catalina
    cat > $out/conf/Catalina/ZipcodeService.xml <<EOF
    ${contextXML}
    EOF
    ln -sf ${ZipcodeService}/webapps $out/webapps
  '';
}
