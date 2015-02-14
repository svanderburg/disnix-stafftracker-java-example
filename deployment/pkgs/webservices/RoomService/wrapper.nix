{stdenv, RoomService}:
{rooms}:

let
  contextXML = ''
    <Context>
      <Resource name="jdbc/RoomDB" auth="Container" type="javax.sql.DataSource"
                maxActivate="100" maxIdle="30" maxWait="10000"
                username="${rooms.target.mysqlUsername}" password="${rooms.target.mysqlPassword}" driverClassName="com.mysql.jdbc.Driver"
                url="jdbc:mysql://${rooms.target.hostname}:${toString (rooms.target.mysqlPort)}/${rooms.name}?autoReconnect=true" />
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
