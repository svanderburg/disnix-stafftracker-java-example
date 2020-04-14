{stdenv, RoomService}:
{rooms}:

let
  contextXML = ''
    <Context>
      <Resource name="jdbc/RoomDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${rooms.mysqlUsername}" password="${rooms.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${rooms.target.properties.hostname}:${toString (rooms.target.container.mysqlPort)}/${rooms.name}?autoReconnect=true" />
    </Context>
  '';
in
stdenv.mkDerivation {
  name = "RoomServiceWrapper";
  buildCommand = ''
    mkdir -p $out/conf/Catalina
    cat > $out/conf/Catalina/RoomService.xml <<EOF
    ${contextXML}
    EOF
    ln -sf ${RoomService}/webapps $out/webapps
  '';
}
