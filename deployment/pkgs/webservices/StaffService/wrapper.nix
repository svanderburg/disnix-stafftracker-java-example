{stdenv, StaffService}:
{staff}:

let
  contextXML = ''
    <Context>
      <Resource name="jdbc/StaffDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${staff.mysqlUsername}" password="${staff.mysqlPassword}" driverClassName="com.mysql.cj.jdbc.Driver"
                url="jdbc:mysql://${staff.target.properties.hostname}:${toString (staff.target.container.mysqlPort)}/${staff.name}?autoReconnect=true" />
    </Context>
  '';
in
stdenv.mkDerivation {
  name = "StaffService";
  buildCommand = ''
    mkdir -p $out/conf/Catalina
    cat > $out/conf/Catalina/StaffService.xml <<EOF
    ${contextXML}
    EOF
    ln -sf ${StaffService}/webapps $out/webapps
  '';
}
