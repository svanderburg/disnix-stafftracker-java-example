{infrastructure}:

{
  mysql = [ infrastructure.test2 ];
  simpleAppservingTomcat = [ infrastructure.test1 infrastructure.test2 ];
}
