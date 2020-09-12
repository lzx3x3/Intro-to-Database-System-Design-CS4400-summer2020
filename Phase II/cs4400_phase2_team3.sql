-- CS4400: Introduction to Database Systems
-- Summer 2020
-- Phase II Create Table and Insert Statements

-- Team 3
-- Siying Cen (scen9)
-- Jinyu Huang (jhunag472)
-- Yiting Sun (ysun492)
-- Ken Xu (hxu323)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission


-- CREATE DATABASE STATEMENTS BELOW

DROP DATABASE IF EXISTS gpm;
CREATE DATABASE IF NOT EXISTS gpm;
USE gpm;

-- CREATE TABLE STATEMENTS BELOW

DROP table if exists business;
CREATE TABLE business (
  name varchar(40) not null,
  type varchar(20) not null,
  street varchar(40) not null,
  city varchar(20) not null,
  state varchar(20) not null,
  zip decimal(5,0) not null,
  primary key (name),
  UNIQUE KEY (street, city, state, zip)
) ENGINE=InnoDB;

DROP table if exists hospital;
CREATE TABLE hospital (
  name varchar(40) not null,
  maxDoctors integer NOT NULL,
  budget decimal(10,2) NOT NULL,
  primary key (name),
  Constraint  Hospital_ibfk_1 foreign key (name) references business(name)
) ENGINE=InnoDB;
  
DROP TABLE IF EXISTS manufacturer;
CREATE TABLE manufacturer (
  name varchar(40) NOT NULL,
  catalogCapacity decimal(10,0) NOT NULL,
  PRIMARY KEY (name),
  Constraint  manufacturer_ibfk_1 foreign key (name) references business(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS product;
CREATE TABLE product (
  productID char(5) NOT NULL,
  color varchar(10) NOT NULL,
  type varchar(30) NOT NULL,
  PRIMARY KEY (productID),
  UNIQUE KEY (type, color)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS catalog_item;
CREATE TABLE catalog_item (
  manufacturerName varchar(40) NOT NULL,
  productID char(5) NOT NULL,
  price decimal(5,2) NOT NULL,
  PRIMARY KEY (productID, manufacturerName),
  CONSTRAINT catalog_item_ibfk_1 FOREIGN KEY (productID) REFERENCES product (productID),
  CONSTRAINT catalog_item_ibfk_2 FOREIGN KEY (manufacturerName) REFERENCES manufacturer (name)
) ENGINE=InnoDB;

DROP table if exists transaction;
CREATE TABLE transaction (
  transID char(4) not null,
  date date NOT NULL,
  hospitalName varchar(40) not null,
  primary key (transID),
  key hospitalName (hospitalName),
  Constraint trans_hosp foreign key (hospitalName) references hospital (name)
) ENGINE=InnoDB;

DROP table if exists trans_catalog;
CREATE TABLE trans_catalog (
  transID char(4) not null,
  manufacturer varchar(40) not null,
  productID char(5) not null,	
  count integer not null,
  primary key (transID, productID, manufacturer),
  Constraint trans_manu foreign key (manufacturer) references catalog_item (manufacturerName),
  Constraint product foreign key (productID) references catalog_item (productID),
  Constraint trans foreign key (transID) references transaction (transID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS user;
CREATE TABLE user (
  userName varchar(30) NOT NULL,
  fname varchar(30) NOT NULL,
  lname varchar(30) NOT NULL,
  email varchar(50) NOT NULL,
  password decimal(8,0) NOT NULL,
  PRIMARY KEY (userName)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS doctor;
CREATE TABLE doctor (
  docName varchar(30) NOT NULL,
  hospitalName  varchar(40) NOT NULL,
  managerName varchar(30) DEFAULT NULL,
  PRIMARY KEY (docName),
  KEY (hospitalName),
  KEY (managerName),
  CONSTRAINT doctor_ibfk_1 FOREIGN KEY (docName) REFERENCES user (userName),
  CONSTRAINT doctor_ibfk_2 FOREIGN KEY (hospitalName) REFERENCES hospital (name),
  CONSTRAINT doctor_ibfk_3 FOREIGN KEY (managerName) REFERENCES doctor (docName)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS administrator;
CREATE TABLE administrator (
  adminName varchar(30) NOT NULL,
  businessName varchar(40) NOT NULL,
  PRIMARY KEY (adminName),
  CONSTRAINT administrator_ibfk_1 FOREIGN KEY (adminName) REFERENCES user (userName),
  CONSTRAINT administrator_ibfk_2 FOREIGN KEY (businessName) REFERENCES business (name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS usage_log;
CREATE TABLE usage_log (
  ULID decimal(5,0) NOT NULL,
  timestamp varchar(15) NOT NULL,
  dName varchar(30) NOT NULL,
  PRIMARY KEY (ULID),
  KEY (dName),
  CONSTRAINT usage_log_ibfk_1 FOREIGN KEY (dName) REFERENCES doctor (docName)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS used_product;
CREATE TABLE used_product (
  logID decimal(5,0) NOT NULL,
  productID char(5) NOT NULL,
  count integer NOT NULL,
  PRIMARY KEY (logID, productID),
  CONSTRAINT used_product_ibfk_1 FOREIGN KEY (logID) REFERENCES usage_log (ULID),
  CONSTRAINT used_product_ibfk_2 FOREIGN KEY (productID) REFERENCES product (productID)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory (
  ownerName varchar(40) NOT NULL,
  street varchar(40) NOT NULL,
  city varchar(20) NOT NULL,
  state varchar(20) NOT NULL,
  zip decimal(5,0) NOT NULL,
  PRIMARY KEY (ownerName),
  CONSTRAINT  inventory_ibfk_1 FOREIGN KEY (ownerName) REFERENCES business(name)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS inventory_catalog;
CREATE TABLE inventory_catalog (
  ownerName varchar(50) NOT NULL,
  productID char(5) NOT NULL,
  count integer NOT NULL,
  PRIMARY KEY (ownerName, productID),
  CONSTRAINT ic_ibfk_1 FOREIGN KEY (ownerName) REFERENCES inventory(ownerName),
  CONSTRAINT ic_ibfk_2 FOREIGN KEY (productID) REFERENCES product(productID)
) ENGINE=InnoDB;

-- INSERT STATEMENTS BELOW

INSERT INTO business
  (name,type,street,city,state,zip)
VALUES
  ('Children''s Healthcare of Atlanta','Hospital','Clifton Rd NE','Atlanta','Georgia',30332),
  ('Piedmont Hospital','Hospital','Peachtree Rd NW','Atlanta','Georgia',30309),
  ('Northside Hospital','Hospital','Johnson Ferry Road NE','Sandy Springs','Georgia',30342),
  ('Emory Midtown','Hospital','Peachtree St NE','Atlanta','Georgia',30308),
  ('Grady Hospital','Hospital','Jesse Hill Jr Dr SE','Atlanta','Georgia',30303),
  ('PPE Empire','Manufacturer','Ponce De Leon Ave','Atlanta','Georgia',30308),
  ('Buy Personal Protective Equipment, Inc','Manufacturer','Spring St','Atlanta','Georgia',30313),
  ('Healthcare Supplies of Atlanta','Manufacturer','Peachstree St','Atlanta','Georgia',30308),
  ('Georgia Tech Protection Lab','Manufacturer','North Ave NW','Atlanta','Georgia',30332),
  ('Marietta Mask Production Company','Manufacturer','Appletree Way','Marietta','Georgia',30061),
  ('S&J Corporation','Manufacturer','Juniper St','Atlanta','Georgia',30339);

INSERT INTO hospital
  (name,maxDoctors,budget)
VALUES
  ('Children''s Healthcare of Atlanta',6,80000),
  ('Piedmont Hospital',7,95000),
  ('Northside Hospital',9,72000),
  ('Emory Midtown',13,120000),
  ('Grady Hospital',10,81000);

INSERT INTO manufacturer
  (name,catalogCapacity)
VALUES
  ('PPE Empire',20),
  ('Buy Personal Protective Equipment, Inc',25),
  ('Healthcare Supplies of Atlanta',20),
  ('Georgia Tech Protection Lab',27),
  ('Marietta Mask Production Company',15),
  ('S&J Corporation',22);
  
INSERT INTO product
  (productID,color,type)
VALUES
  ('WHMSK','white','mask'),
  ('BLMSK','blue','mask'),
  ('RDMSK','red','mask'),
  ('GRMSK','green','mask'),
  ('WHRES','white','respirator'),
  ('YLRES','yellow','respirator'),
  ('ORRES','orange','repirator'),
  ('CLSHD','clear','shield'),
  ('GRGOG','green','goggles'),
  ('ORGOG','orange','goggles'),
  ('WHGOG','white','goggles'),
  ('BKGOG','black','goggles'),
  ('BLSHC','blue','shoe cover'),
  ('BLHOD','blue','hood'),
  ('BLGWN','blue','gown'),
  ('GRSHC','green','shoe cover'),
  ('GRHOD','green','hood'),
  ('GRGWN','green','gown'),
  ('GYSHC','grey','shoe cover'),
  ('GYHOD','grey','hood'),
  ('GYGWN','grey','gown'),
  ('WHSHC','white','shoe cover'),
  ('WHHOD','white','hood'),
  ('WHGWN','white','gown'),
  ('BKSTE','black','stethoscope'),
  ('WHSTE','white','stethoscope'),
  ('SISTE','silver','stethoscope'),
  ('BKGLO','black','gloves'),
  ('WHGLO','white','gloves'),
  ('GRGLO','green','gloves');

INSERT INTO catalog_item
  (manufacturerName,productID,price)
VALUES
  ('PPE Empire','WHMSK',1.25),
  ('PPE Empire','BLMSK',1.35),
  ('PPE Empire','RDMSK',1.30),
  ('PPE Empire','GRMSK',1.45),
  ('PPE Empire','WHRES',4.80),
  ('PPE Empire','YLRES',5.10),
  ('PPE Empire','ORRES',4.50),
  ('Buy Personal Protective Equipment, Inc','BLSHC',0.90),
  ('Buy Personal Protective Equipment, Inc','BLHOD',2.10),
  ('Buy Personal Protective Equipment, Inc','BLGWN',3.15),
  ('Buy Personal Protective Equipment, Inc','GRSHC',0.90),
  ('Buy Personal Protective Equipment, Inc','GRHOD',2.10),
  ('Buy Personal Protective Equipment, Inc','GRGWN',3.15),
  ('Buy Personal Protective Equipment, Inc','GYSHC',0.90),
  ('Buy Personal Protective Equipment, Inc','GYHOD',2.10),
  ('Buy Personal Protective Equipment, Inc','GYGWN',3.15),
  ('Buy Personal Protective Equipment, Inc','WHSHC',0.90),
  ('Buy Personal Protective Equipment, Inc','WHHOD',2.10),
  ('Buy Personal Protective Equipment, Inc','WHGWN',3.15),
  ('Healthcare Supplies of Atlanta','ORGOG',3.00),
  ('Healthcare Supplies of Atlanta','RDMSK',1.45),
  ('Healthcare Supplies of Atlanta','CLSHD',6.05),
  ('Healthcare Supplies of Atlanta','BLSHC',1.00),
  ('Healthcare Supplies of Atlanta','BLHOD',2.00),
  ('Healthcare Supplies of Atlanta','BLGWN',3.00),
  ('Healthcare Supplies of Atlanta','YLRES',5.50),
  ('Healthcare Supplies of Atlanta','WHMSK',1.10),
  ('Healthcare Supplies of Atlanta','BLMSK',1.05),
  ('Georgia Tech Protection Lab','CLSHD',5.95),
  ('Georgia Tech Protection Lab','ORGOG',3.20),
  ('Georgia Tech Protection Lab','WHGOG',3.20),
  ('Georgia Tech Protection Lab','BKGOG',3.20),
  ('Georgia Tech Protection Lab','GYSHC',0.75),
  ('Georgia Tech Protection Lab','GYHOD',1.80),
  ('Georgia Tech Protection Lab','GYGWN',3.25),
  ('Marietta Mask Production Company','GRSHC',0.80),
  ('Marietta Mask Production Company','GRHOD',1.65),
  ('Marietta Mask Production Company','GRGWN',2.95),
  ('Marietta Mask Production Company','GRMSK',1.25),
  ('Marietta Mask Production Company','GRGOG',3.25),
  ('S&J Corporation','BKSTE',5.20),
  ('S&J Corporation','WHSTE',5.00),
  ('S&J Corporation','SISTE',5.10),
  ('S&J Corporation','BKGLO',0.30),
  ('S&J Corporation','WHGLO',0.30),
  ('S&J Corporation','GRGLO',0.30);

INSERT INTO transaction
  (transID, date, hospitalName)
VALUES
  ('0001','2020-03-10','Children''s Healthcare of Atlanta'),
  ('0002','2020-03-10','Children''s Healthcare of Atlanta'),
  ('0003','2020-03-10','Emory Midtown'),
  ('0004','2020-03-10','Grady Hospital'),
  ('0005','2020-03-10','Northside Hospital'),
  ('0006','2020-03-10','Children''s Healthcare of Atlanta'),
  ('0007','2020-03-10','Piedmont Hospital'),
  ('0008','2020-05-01','Northside Hospital'),
  ('0009','2020-05-01','Children''s Healthcare of Atlanta'),
  ('0010','2020-05-01','Northside Hospital'),
  ('0011','2020-05-01','Northside Hospital'),
  ('0012','2020-05-25','Emory Midtown'),
  ('0013','2020-05-25','Children''s Healthcare of Atlanta'),
  ('0014','2020-05-25','Emory Midtown'),
  ('0015','2020-05-25','Emory Midtown'),
  ('0016','2020-05-25','Northside Hospital'),
  ('0017','2020-06-03','Grady Hospital'),
  ('0018','2020-06-03','Grady Hospital'),
  ('0019','2020-06-03','Grady Hospital'),
  ('0020','2020-06-03','Piedmont Hospital'),
  ('0021','2020-06-04','Piedmont Hospital');

INSERT INTO trans_catalog
  (transID, manufacturer, productID, count)
VALUES
  ('0001','PPE Empire','WHMSK',500),
  ('0001','PPE Empire','BLMSK',500),
  ('0002','Buy Personal Protective Equipment, Inc','BLSHC',300),
  ('0003','Healthcare Supplies of Atlanta','BLMSK',500),
  ('0004','Healthcare Supplies of Atlanta','ORGOG',150),
  ('0004','Healthcare Supplies of Atlanta','RDMSK',150),
  ('0004','Healthcare Supplies of Atlanta','CLSHD',200),
  ('0004','Healthcare Supplies of Atlanta','BLSHC',100),
  ('0005','Healthcare Supplies of Atlanta','WHMSK',300),
  ('0006','Buy Personal Protective Equipment, Inc','BLSHC',400),
  ('0007','Marietta Mask Production Company','GRMSK',100),
  ('0007','Marietta Mask Production Company','GRGOG',300),
  ('0008','Georgia Tech Protection Lab','ORGOG',200),
  ('0008','Georgia Tech Protection Lab','WHGOG',200),
  ('0009','Marietta Mask Production Company','GRSHC',500),
  ('0009','Marietta Mask Production Company','GRHOD',500),
  ('0010','S&J Corporation','WHGLO',500),
  ('0011','Buy Personal Protective Equipment, Inc','WHHOD',200),
  ('0011','Buy Personal Protective Equipment, Inc','WHGWN',200),
  ('0012','Buy Personal Protective Equipment, Inc','BLSHC',50),
  ('0013','Healthcare Supplies of Atlanta','BLHOD',100),
  ('0013','Healthcare Supplies of Atlanta','BLGWN',100),
  ('0014','PPE Empire','WHRES',300),
  ('0014','PPE Empire','YLRES',200),
  ('0014','PPE Empire','ORRES',300),
  ('0015','Buy Personal Protective Equipment, Inc','GYGWN',50),
  ('0016','Healthcare Supplies of Atlanta','CLSHD',20),
  ('0016','Healthcare Supplies of Atlanta','ORGOG',300),
  ('0016','Healthcare Supplies of Atlanta','BLHOD',100),
  ('0017','Healthcare Supplies of Atlanta','RDMSK',200),
  ('0017','Healthcare Supplies of Atlanta','CLSHD',180),
  ('0018','Buy Personal Protective Equipment, Inc','WHHOD',500),
  ('0019','Buy Personal Protective Equipment, Inc','GYGWN',300),
  ('0020','S&J Corporation','BKSTE',50),
  ('0020','S&J Corporation','WHSTE',50),
  ('0021','Georgia Tech Protection Lab','CLSHD',100),
  ('0021','Georgia Tech Protection Lab','ORGOG',200);
  
INSERT INTO user
  (userName, fname,lname,email,password)
VALUES
  ('drCS4400','Computer','Science','cs4400@gatech.edu',30003000),
  ('doctor_moss','Mark','Moss','mmoss7@gatech.edu',12341234),
  ('drmcdaniel','Melinda','McDaniel','mcdaniel@cc.gatech.edu',12345678),
  ('musaev_doc','Aibek','Musaev','aibek.musaev@gatech.edu',87654321),
  ('doctor1','Doctor','One','doctor1@gatech.edu',10001000),
  ('doctor2','Doctor','Two','doctor2@gatech.edu',20002000),
  ('fantastic','Chris','Eccleston','ninth_doctor@gatech.edu',99999999),
  ('allons_y','David','Tennant','tenth_doctor@gatech.edu',10101010),
  ('bow_ties _are_cool','Matt','Smith','eleventh_doctor@gatech.edu',11111111),
  ('sonic_shades','Peter','Capaldi','twelfth_doctor@gatech.edu',12121212),
  ('mcdreamy','Derek','Shepard','dr_shepard@gatech.edu',13311332),
  ('grey_jr','Meredith','Shepard','dr_grey@gatech.edu',87878787),
  ('young_doc','Doogie','Howser','howser@gatech.edu',80088008),
  ('dr_dolittle','John','Dolittle','dog_doc@gatech.edu',37377373),
  ('bones','Leonard','McCoy','doctor_mccoy@gatech.edu',11223344),
  ('doc_in_da_house','Gregory','House','tv_doctor@gatech.edu',30854124),
  ('jekyll_not_hyde','Henry','Jekyll','jekyll1886@gatech.edu',56775213),
  ('drake_remoray ','Joey','Tribbiani','f_r_i_e_n_d_s@gatech.edu',24598543),
  ('Jones01','Johnes','Boys','jones01@gatech.edu',52935481),
  ('hannah_hills','Hannah','Hills','managerEHH@gatech.edu',13485102),
  ('henryjk','Henry','Kims','HenryJK@gatech.edu',54238912),
  ('aziz_01','Amit','Aziz','ehh01@gatech.edu',90821348),
  ('dr_mory','Jack','Mory','JackMM@gatech.edu',12093015),
  ('ppee_admin','Admin','One','ppee_admin@gatech.edu',27536292),
  ('bppe_admin','Admin','Two','bppe_admin@gatech.edu',35045790),
  ('hsa_admin','Jennifer','Tree','hsa_admin@gatech.edu',75733271),
  ('gtpl_admin','Shaundra','Apple','gtpl_admin@gatech.edu',14506524),
  ('mmpc_admin','Nicholas','Cage','mmpc_admin@gatech.edu',22193897),
  ('sjc_admin','Trey','Germs','sjc_admin@gatech.edu',74454118),
  ('choa_admin','Addison','Ambulance','choa_admin@gatech.edu',62469488),
  ('piedmont_admin','Rohan','Right','piedmont_admin@gatech.edu',36846830),
  ('northside_admin','Johnathan','Smith','northside_admin@gatech.edu',38613312),
  ('emory_admin','Elizabeth','Tucker','emory_admin@gatech.edu',33202257),
  ('grady_admin','Taylor','Booker','grady_admin@gatech.edu',67181125),
  ('Burdell','George','Burdell','GeorgeBurdell@gatech.edu',12345678),
  ('Buzz','Buzz','Tech','THWG@gatech.edu',98765432);
  
INSERT INTO doctor
  (docName, hospitalName, managerName)
VALUES 
  ('drCS4400','Children''s Healthcare of Atlanta',NULL),
  ('doctor_moss','Piedmont Hospital',NULL),
  ('drmcdaniel','Northside Hospital',NULL),
  ('musaev_doc','Emory Midtown',NULL),
  ('doctor1','Grady Hospital',NULL),
  ('doctor2','Children''s Healthcare of Atlanta','drCS4400'),
  ('fantastic','Piedmont Hospital','doctor_moss'),
  ('allons_y','Northside Hospital','drmcdaniel'),
  ('bow_ties _are_cool','Emory Midtown','musaev_doc'),
  ('sonic_shades','Grady Hospital','doctor1'),
  ('mcdreamy','Children''s Healthcare of Atlanta','drCS4400'),
  ('grey_jr','Piedmont Hospital','doctor_moss'),
  ('young_doc','Northside Hospital','drmcdaniel'),
  ('dr_dolittle','Emory Midtown','musaev_doc'),
  ('bones','Grady Hospital','doctor1'),
  ('doc_in_da_house','Children''s Healthcare of Atlanta','drCS4400'),
  ('jekyll_not_hyde','Piedmont Hospital','doctor_moss'),
  ('drake_remoray ','Northside Hospital','drmcdaniel'),
  ('Jones01','Emory Midtown','musaev_doc'),
  ('hannah_hills','Grady Hospital','doctor1'),
  ('henryjk','Children''s Healthcare of Atlanta','drCS4400'),
  ('aziz_01','Piedmont Hospital','doctor_moss'),
  ('dr_mory','Northside Hospital','drmcdaniel'),
  ('Burdell','Northside Hospital','drmcdaniel'),
  ('Buzz','Piedmont Hospital','doctor_moss');
  
INSERT INTO administrator
  (adminName, businessName)
VALUES
  ('ppee_admin','PPE Empire'),
  ('bppe_admin','Buy Personal Protective Equipment, Inc'),
  ('hsa_admin','Healthcare Supplies of Atlanta'),
  ('gtpl_admin','Georgia Tech Protection Lab'),
  ('mmpc_admin','Marietta Mask Production Company'),
  ('sjc_admin','S&J Corporation'),
  ('choa_admin','Children''s Healthcare of Atlanta'),
  ('piedmont_admin','Piedmont Hospital'),
  ('northside_admin','Northside Hospital'),
  ('emory_admin','Emory Midtown'),
  ('grady_admin','Grady Hospital'),
  ('Burdell','Northside Hospital'),
  ('Buzz','Piedmont Hospital');
  
INSERT INTO usage_log
  (ULID, timestamp, dName)
VALUES
  (10000,'6/11/20 16:30','fantastic'),
  (10001,'6/11/20 17:00','jekyll_not_hyde'),
  (10002,'6/11/20 17:03','young_doc'),
  (10003,'6/12/20 8:23','fantastic'),
  (10004,'6/12/20 8:42','hannah_hills'),
  (10005,'6/12/20 9:00','mcdreamy'),
  (10006,'6/12/20 9:43','fantastic'),
  (10007,'6/12/20 10:11','doctor1'),
  (10008,'6/12/20 10:12','Jones01'),
  (10009,'6/12/20 10:23','henryjk'),
  (10010,'6/12/20 10:32','bones'),
  (10011,'6/12/20 11:00','dr_dolittle'),
  (10012,'6/12/20 11:14','drake_remoray '),
  (10013,'6/12/20 12:11','allons_y'),
  (10014,'6/12/20 13:23','dr_mory'),
  (10015,'6/12/20 13:52','Jones01');

INSERT INTO used_product
  (logID, productID, count)
VALUES
  (10000,'GRMSK',3),
  (10000,'GRGOG',3),
  (10000,'WHSTE',1),
  (10001,'GRMSK',5),
  (10001,'BKSTE',1),
  (10002,'WHMSK',4),
  (10003,'CLSHD',2),
  (10003,'ORGOG',1),
  (10003,'GRMSK',2),
  (10003,'GRGOG',1),
  (10003,'BKSTE',1),
  (10004,'ORGOG',2),
  (10004,'RDMSK',4),
  (10004,'CLSHD',2),
  (10004,'BLSHC',4),
  (10005,'WHMSK',4),
  (10005,'BLMSK',4),
  (10005,'BLSHC',8),
  (10006,'GRMSK',2),
  (10007,'RDMSK',3),
  (10007,'CLSHD',3),
  (10008,'BLMSK',5),
  (10009,'GRSHC',4),
  (10009,'GRHOD',4),
  (10009,'WHMSK',4),
  (10010,'RDMSK',3),
  (10010,'BLSHC',3),
  (10011,'BLMSK',8),
  (10012,'ORGOG',1),
  (10012,'WHGOG',1),
  (10012,'WHGLO',2),
  (10013,'WHHOD',2),
  (10014,'WHGOG',2),
  (10014,'WHGWN',2),
  (10015,'BLMSK',4);
  
INSERT INTO inventory
  (ownerName,street,city,state,zip)
VALUES
  ('Children''s Healthcare of Atlanta','Storage St','Atlanta','Georgia',30309),
  ('Piedmont Hospital','Warehouse Way','Atlanta','Georgia',30332),
  ('Northside Hospital','Depot Dr','Dunwoody','Georgia',30338),
  ('Emory Midtown','Inventory Ct','Atlanta','Georgia',30308),
  ('Grady Hospital','Storehouse Pkwy','Atlanta','Georgia',30313),
  ('PPE Empire','Cache Ct','Lawrenceville','Georgia',30043),
  ('Buy Personal Protective Equipment, Inc','Stockpile St','Decatur','Georgia',30030),
  ('Healthcare Supplies of Atlanta','Depository Dr','Atlanta','Georgia',30303),
  ('Georgia Tech Protection Lab','Storehouse St','Atlanta','Georgia',30332),
  ('Marietta Mask Production Company','Repository Way','Marietta','Georgia',30008),
  ('S&J Corporation','Stash St','Suwanee','Georgia',30024);

INSERT INTO inventory_catalog
  (ownerName,productID, count)
VALUES
  ('Children''s Healthcare of Atlanta','WHMSK','5'),
  ('Children''s Healthcare of Atlanta','BLMSK','220'),
  ('Children''s Healthcare of Atlanta','WHRES','280'),
  ('Children''s Healthcare of Atlanta','CLSHD','100'),
  ('Children''s Healthcare of Atlanta','GRGOG','780'),
  ('Children''s Healthcare of Atlanta','ORGOG','100'),
  ('Children''s Healthcare of Atlanta','BLSHC','460'),
  ('Children''s Healthcare of Atlanta','BLHOD','100'),
  ('Children''s Healthcare of Atlanta','BLGWN','80'),
  ('Children''s Healthcare of Atlanta','GRSHC','5'),
  ('Children''s Healthcare of Atlanta','WHSTE','330'),
  ('Children''s Healthcare of Atlanta','BKGLO','410'),
  ('Piedmont Hospital','BLSHC','3000'),
  ('Piedmont Hospital','BLHOD','3000'),
  ('Piedmont Hospital','BLGWN','420'),
  ('Piedmont Hospital','GRSHC','740'),
  ('Piedmont Hospital','GRHOD','560'),
  ('Piedmont Hospital','GRGWN','840'),
  ('Piedmont Hospital','SISTE','460'),
  ('Piedmont Hospital','BKGLO','4210'),
  ('Northside Hospital','WHRES','110'),
  ('Northside Hospital','YLRES','170'),
  ('Northside Hospital','ORRES','350'),
  ('Northside Hospital','CLSHD','410'),
  ('Northside Hospital','GRGOG','1'),
  ('Northside Hospital','ORGOG','100'),
  ('Emory Midtown','WHMSK','80'),
  ('Emory Midtown','BLMSK','210'),
  ('Emory Midtown','RDMSK','320'),
  ('Emory Midtown','GRMSK','40'),
  ('Emory Midtown','WHRES','760'),
  ('Emory Midtown','YLRES','140'),
  ('Emory Midtown','ORRES','20'),
  ('Emory Midtown','CLSHD','50'),
  ('Emory Midtown','GRGOG','70'),
  ('Emory Midtown','ORGOG','320'),
  ('Emory Midtown','WHGOG','140'),
  ('Emory Midtown','BKGOG','210'),
  ('Emory Midtown','BLSHC','630'),
  ('Grady Hospital','BLHOD','970'),
  ('Grady Hospital','BLGWN','310'),
  ('Grady Hospital','GRSHC','340'),
  ('Grady Hospital','GRHOD','570'),
  ('Grady Hospital','GRGWN','10'),
  ('Grady Hospital','GYSHC','20'),
  ('Grady Hospital','GYHOD','280'),
  ('Grady Hospital','GYGWN','240'),
  ('Grady Hospital','WHSHC','180'),
  ('Grady Hospital','WHHOD','140'),
  ('Grady Hospital','WHGWN','150'),
  ('Grady Hospital','BKSTE','210'),
  ('Grady Hospital','WHSTE','170'),
  ('Grady Hospital','SISTE','180'),
  ('Grady Hospital','BKGLO','70'),
  ('Grady Hospital','WHGLO','140'),
  ('Grady Hospital','GRGLO','80'),
  ('PPE Empire','WHMSK','850'),
  ('PPE Empire','BLMSK','1320'),
  ('PPE Empire','RDMSK','540'),
  ('PPE Empire','GRMSK','870'),
  ('PPE Empire','WHRES','500'),
  ('PPE Empire','ORRES','320'),
  ('Buy Personal Protective Equipment, Inc','BLSHC','900'),
  ('Buy Personal Protective Equipment, Inc','BLGWN','820'),
  ('Buy Personal Protective Equipment, Inc','GRSHC','700'),
  ('Buy Personal Protective Equipment, Inc','GRHOD','770'),
  ('Buy Personal Protective Equipment, Inc','GYSHC','250'),
  ('Buy Personal Protective Equipment, Inc','GYHOD','350'),
  ('Buy Personal Protective Equipment, Inc','GYGWN','850'),
  ('Buy Personal Protective Equipment, Inc','WHSHC','860'),
  ('Buy Personal Protective Equipment, Inc','WHHOD','700'),
  ('Buy Personal Protective Equipment, Inc','WHGWN','500'),
  ('Healthcare Supplies of Atlanta','ORGOG','860'),
  ('Healthcare Supplies of Atlanta','RDMSK','370'),
  ('Healthcare Supplies of Atlanta','CLSHD','990'),
  ('Healthcare Supplies of Atlanta','BLSHC','1370'),
  ('Healthcare Supplies of Atlanta','BLHOD','210'),
  ('Healthcare Supplies of Atlanta','BLGWN','680'),
  ('Healthcare Supplies of Atlanta','YLRES','890'),
  ('Healthcare Supplies of Atlanta','WHMSK','980'),
  ('Healthcare Supplies of Atlanta','BLMSK','5000'),
  ('Georgia Tech Protection Lab','CLSHD','620'),
  ('Georgia Tech Protection Lab','ORGOG','970'),
  ('Georgia Tech Protection Lab','WHGOG','940'),
  ('Georgia Tech Protection Lab','BKGOG','840'),
  ('Georgia Tech Protection Lab','GYSHC','610'),
  ('Georgia Tech Protection Lab','GYHOD','940'),
  ('Georgia Tech Protection Lab','GYGWN','700'),
  ('Marietta Mask Production Company','GRSHC','970'),
  ('Marietta Mask Production Company','GRHOD','750'),
  ('Marietta Mask Production Company','GRMSK','750'),
  ('Marietta Mask Production Company','GRGOG','320'),
  ('S&J Corporation','BKSTE','200'),
  ('S&J Corporation','WHSTE','860'),
  ('S&J Corporation','WHGLO','500'),
  ('S&J Corporation','GRGLO','420'),
  ('S&J Corporation','BKGLO','740');
