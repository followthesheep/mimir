BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS `stars` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`stuff`	REAL
);
INSERT INTO `stars` (pk,name,stuff) VALUES (1,'S01',2.5);
INSERT INTO `stars` (pk,name,stuff) VALUES (2,'S02',1.3);
CREATE TABLE IF NOT EXISTS `starkit` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`vlsr`	REAL,
	`vz`	REAL,
	`spectra_pk`	INTEGER,
	FOREIGN KEY(`spectra_pk`) REFERENCES `spectra`(`pk`)
);
INSERT INTO `starkit` (pk,vlsr,vz,spectra_pk) VALUES (1,100.0,4.0,1);
INSERT INTO `starkit` (pk,vlsr,vz,spectra_pk) VALUES (2,30.0,2.0,2);
CREATE TABLE IF NOT EXISTS `spectra` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`filename`	TEXT,
	`mjd`	REAL,
	`stuff`	INTEGER,
	`star_pk`	INTEGER,
	`obs_pk`	INTEGER,
	FOREIGN KEY(`obs_pk`) REFERENCES `observations`(`pk`),
	FOREIGN KEY(`star_pk`) REFERENCES `stars`(`pk`)
);
INSERT INTO `spectra` (pk,filename,mjd,stuff,star_pk,obs_pk) VALUES (1,'spfile1',52378.25,5,1,1);
INSERT INTO `spectra` (pk,filename,mjd,stuff,star_pk,obs_pk) VALUES (2,'spfile2',52378.75,3,1,2);
CREATE TABLE IF NOT EXISTS `points` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`mag`	REAL,
	`x`	INTEGER,
	`y`	INTEGER,
	`image_pk`	INTEGER,
	`star_pk`	INTEGER,
	FOREIGN KEY(`image_pk`) REFERENCES `image`(`pk`),
	FOREIGN KEY(`star_pk`) REFERENCES `stars`(`pk`)
);
INSERT INTO `points` (pk,mag,x,y,image_pk,star_pk) VALUES (1,28.0,1,1,1,1);
INSERT INTO `points` (pk,mag,x,y,image_pk,star_pk) VALUES (2,14.0,2.3,3.2,1,2);
INSERT INTO `points` (pk,mag,x,y,image_pk,star_pk) VALUES (3,26.0,5.4,3.4,1,NULL);
INSERT INTO `points` (pk,mag,x,y,image_pk,star_pk) VALUES (4,15.0,8.2,7.3,1,NULL);
INSERT INTO `points` (pk,mag,x,y,image_pk,star_pk) VALUES (5,22.0,15.1,1.2,2,1);
INSERT INTO `points` (pk,mag,x,y,image_pk,star_pk) VALUES (6,9.0,7.5,1.6,2,2);
CREATE TABLE IF NOT EXISTS `observations` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`date`	DATETIME,
	`vlsr`	REAL,
	`field_pk`	INTEGER,
	FOREIGN KEY(`field_pk`) REFERENCES `field`(`pk`)
);
INSERT INTO `observations` (pk,date,vlsr,field_pk) VALUES (1,'2018-01-12 00:00:00',10.0,1);
INSERT INTO `observations` (pk,date,vlsr,field_pk) VALUES (2,'2018-01-13 00:00:00',4.0,1);
INSERT INTO `observations` (pk,date,vlsr,field_pk) VALUES (3,'2018-01-13 00:00:00',30.0,2);
CREATE TABLE IF NOT EXISTS `image` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`exposure_no`	INTEGER,
	`mjd`	REAL,
	`filename`	TEXT,
	`obs_pk`	INTEGER,
	FOREIGN KEY(`obs_pk`) REFERENCES `observations`(`pk`)
);
INSERT INTO `image` (pk,exposure_no,mjd,filename,obs_pk) VALUES (1,1,52378.25,'image1',1);
INSERT INTO `image` (pk,exposure_no,mjd,filename,obs_pk) VALUES (2,2,52378.5,'image2',1);
INSERT INTO `image` (pk,exposure_no,mjd,filename,obs_pk) VALUES (3,3,52378.75,'image3',1);
CREATE TABLE IF NOT EXISTS `field` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`name`	TEXT,
	`ra`	REAL,
	`dec`	REAL,
	`size_x`	REAL,
	`size_y`	REAL,
	`pa`	REAL
);
INSERT INTO `field` (pk,name,ra,dec,size_x,size_y,pa) VALUES (1,'GC',180.0344,24.345,2.0,NULL,285.0);
INSERT INTO `field` (pk,name,ra,dec,size_x,size_y,pa) VALUES (2,'South',180.0344,-31.23,1.0,NULL,285.0);
CREATE TABLE IF NOT EXISTS `catalog1` (
	`pk`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`id`	TEXT,
	`date`	DATETIME,
	`vlsr`	REAL,
	`vz`	REAL,
	`star_pk`	INTEGER,
	FOREIGN KEY(`star_pk`) REFERENCES `stars`(`pk`)
);
INSERT INTO `catalog1` (pk,id,date,vlsr,vz,star_pk) VALUES (1,'1','2017-03-15 00:00:00',125.0,4.0,1);
INSERT INTO `catalog1` (pk,id,date,vlsr,vz,star_pk) VALUES (2,'2','2017-04-01 00:00:00',500.0,4.0,NULL);
CREATE VIEW star_view as
select s.name, o.date, k.vlsr as kit_vlsr, k.vz as kit_vz, c.vlsr as cat_vlsr, c.vz as cat_vz
from stars as s join spectra as sp on sp.star_pk=s.pk
join observations as o on o.pk=sp.obs_pk
join starkit as k on k.spectra_pk=sp.pk
join catalog1 as c on c.star_pk=s.pk;
COMMIT;
