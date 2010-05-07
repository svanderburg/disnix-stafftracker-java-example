create table staff
( STAFF_ID    INTEGER      NOT NULL,
  Name        VARCHAR(255) NOT NULL,
  LastName    VARCHAR(255) NOT NULL,
  Room        VARCHAR(10)  NOT NULL,
  ipAddress   VARCHAR(15)  NOT NULL,
  PRIMARY KEY(STAFF_ID)
);

insert into staff values (1, 'Sander', 'van der Burg', 'EWI 01.01', '130.161.1.1');
insert into staff values (2, 'Eelco', 'Dolstra', 'EWI 01.01', '130.161.1.2');
insert into staff values (3, 'Eelco', 'Visser', 'EWI 01.02', '130.161.1.3');
insert into staff values (4, 'Danny', 'Groenewegen', 'EWI 01.03', '130.161.1.4');
insert into staff values (5, 'Zef', 'Hemel', 'EWI 01.03', '130.161.1.5');
insert into staff values (6, 'Sander', 'Vermolen', 'EWI 01.04', '130.161.1.6');
insert into staff values (7, 'Lennart', 'Kats', 'EWI 01.04', '130.161.1.7');
insert into staff values (8, 'Maartje', 'de Jonge', 'EWI 01.04', '130.161.1.8');
