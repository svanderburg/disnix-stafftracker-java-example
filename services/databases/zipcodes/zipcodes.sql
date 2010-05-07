create table zipcode
( Zipcode    VARCHAR(6)    NOT NULL,
  Street     VARCHAR(255)  NOT NULL,
  City       VARCHAR(255)  NOT NULL,
  PRIMARY KEY(Zipcode)
);

insert into zipcode values ('2628CD', 'Mekelweg', 'Delft');
insert into zipcode values ('2628CN', 'Stevinweg', 'Delft');
insert into zipcode values ('2628CJ', 'Lorentzweg', 'Delft');
insert into zipcode values ('2628CE', 'Landbergstraat', 'Delft');
insert into zipcode values ('2628HS', 'Kluyverweg', 'Delft');
