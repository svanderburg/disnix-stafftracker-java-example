{stdenv, apacheAnt, axis2}:
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
  name = "RoomService";
  src = ../../../../services/webservices/RoomService;
  buildInputs = [ apacheAnt ];
  AXIS2_LIB = "${axis2}/lib";
  AXIS2_WEBAPP = "${axis2}/webapps/axis2";
  buildPhase = "ant generate.war";
  installPhase = ''
    ensureDir $out/conf/Catalina
    cat > $out/conf/Catalina/RoomService.xml <<EOF
    ${contextXML}
    EOF
    ensureDir $out/webapps
    cp *.war $out/webapps
  '';
}
