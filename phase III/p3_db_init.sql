DROP SCHEMA IF EXISTS ga_ppe;
CREATE SCHEMA ga_ppe;
USE ga_ppe;

CREATE TABLE User(
	username VARCHAR(100) PRIMARY KEY,
	email VARCHAR(100) NOT NULL UNIQUE,
	password VARCHAR(100) NOT NULL,
	fname VARCHAR(50) NOT NULL,
	lname VARCHAR(50) NOT NULL
);
CREATE TABLE Business(
	name VARCHAR(100) PRIMARY KEY,
	address_street VARCHAR(100) NOT NULL,
	address_city VARCHAR(100) NOT NULL,
	address_state VARCHAR(30) NOT NULL,
	address_zip CHAR(5) NOT NULL,
	UNIQUE (address_street, address_city, address_state, address_zip)
);
CREATE TABLE Product(
	id CHAR(5) PRIMARY KEY,
	name_color VARCHAR(30) NOT NULL,
	name_type VARCHAR(30) NOT NULL,
	UNIQUE (name_color, name_type)
);
CREATE TABLE Hospital(
	name VARCHAR(100) PRIMARY KEY,
	max_doctors INT NOT NULL,
	budget FLOAT(2) NOT NULL,
	FOREIGN KEY (name) REFERENCES Business (name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE Manufacturer(
	name VARCHAR(100) PRIMARY KEY,
	catalog_capacity INT NOT NULL,
	FOREIGN KEY (name) REFERENCES Business (name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE Inventory(
	owner VARCHAR(100) PRIMARY KEY,
	address_street VARCHAR(100) NOT NULL,
	address_city VARCHAR(100) NOT NULL,
	address_state VARCHAR(30) NOT NULL,
	address_zip CHAR(5) NOT NULL,
	FOREIGN KEY (owner) REFERENCES Business (name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE Doctor(
	username VARCHAR(100) PRIMARY KEY,
	hospital VARCHAR(100) NOT NULL,
	manager VARCHAR(100),
	FOREIGN KEY (username) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (hospital) REFERENCES Hospital (name) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (manager) REFERENCES Doctor (username) ON UPDATE CASCADE ON DELETE SET NULL
);
CREATE TABLE Administrator(
	username VARCHAR(100) PRIMARY KEY,
	business VARCHAR(100) NOT NULL,
	FOREIGN KEY (username) REFERENCES User (username) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (business) REFERENCES Business (name) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE CatalogItem(
	manufacturer VARCHAR(100),
	product_id CHAR(5),
	price FLOAT(2) NOT NULL,
	PRIMARY KEY(manufacturer, product_id),
	FOREIGN KEY (manufacturer) REFERENCES Manufacturer (name) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE Transaction(
	id CHAR(4) PRIMARY KEY,
	hospital VARCHAR(100) NOT NULL,
	date DATE NOT NULL,
	FOREIGN KEY (hospital) REFERENCES Hospital (name) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE TransactionItem(
	transaction_id CHAR(4),
	manufacturer VARCHAR(100),
	product_id CHAR(5),
	count INT NOT NULL,
	PRIMARY KEY(transaction_id, manufacturer, product_id),
	FOREIGN KEY (transaction_id) REFERENCES Transaction (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (manufacturer, product_id) REFERENCES CatalogItem (manufacturer, product_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE UsageLog(
	id CHAR(5) PRIMARY KEY,
	doctor VARCHAR(100) NOT NULL,
	timestamp TIMESTAMP NOT NULL,
	FOREIGN KEY (doctor) REFERENCES Doctor (username) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE UsageLogEntry(
	usage_log_id CHAR(5),
	product_id CHAR(5),
	count INT NOT NULL,
	PRIMARY KEY(usage_log_id, product_id),
	FOREIGN KEY (usage_log_id) REFERENCES UsageLog (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE InventoryHasProduct(
	inventory_business VARCHAR(100),
	product_id CHAR(5),
	count INT NOT NULL,
	PRIMARY KEY(inventory_business, product_id),
	FOREIGN KEY (inventory_business) REFERENCES Inventory (owner) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (product_id) REFERENCES Product (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

USE ga_ppe;

INSERT INTO User(username,email,password,fname,lname) VALUES ("drCS4400","cs4400@gatech.edu",SHA("30003000"),"Computer","Science"),("doctor_moss","mmoss7@gatech.edu",SHA("12341234"),"Mark","Moss"),("drmcdaniel","mcdaniel@cc.gatech.edu",SHA("12345678"),"Melinda","McDaniel"),("musaev_doc","aibek.musaev@gatech.edu",SHA("87654321"),"Aibek","Musaev"),("doctor1","doctor1@gatech.edu",SHA("10001000"),"Doctor","One"),("doctor2","doctor2@gatech.edu",SHA("20002000"),"Doctor","Two"),("fantastic","ninth_doctor@gatech.edu",SHA("99999999"),"Chris","Eccleston"),("allons_y","tenth_doctor@gatech.edu",SHA("10101010"),"David","Tennant"),("bow_ties _are_cool","eleventh_doctor@gatech.edu",SHA("11111111"),"Matt","Smith"),("sonic_shades","twelfth_doctor@gatech.edu",SHA("12121212"),"Peter","Capaldi"),("mcdreamy","dr_shepard@gatech.edu",SHA("13311332"),"Derek","Shepard"),("grey_jr","dr_grey@gatech.edu",SHA("87878787"),"Meredith","Shepard"),("young_doc","howser@gatech.edu",SHA("80088008"),"Doogie","Howser"),("dr_dolittle","dog_doc@gatech.edu",SHA("37377373"),"John","Dolittle"),("bones","doctor_mccoy@gatech.edu",SHA("11223344"),"Leonard","McCoy"),("doc_in_da_house","tv_doctor@gatech.edu",SHA("30854124"),"Gregory","House"),("jekyll_not_hyde","jekyll1886@gatech.edu",SHA("56775213"),"Henry","Jekyll"),("drake_remoray","f_r_i_e_n_d_s@gatech.edu",SHA("24598543"),"Joey","Tribbiani"),("Jones01","jones01@gatech.edu",SHA("52935481"),"Johnes","Boys"),("hannah_hills","managerEHH@gatech.edu",SHA("13485102"),"Hannah","Hills"),("henryjk","HenryJK@gatech.edu",SHA("54238912"),"Henry","Kims"),("aziz_01","ehh01@gatech.edu",SHA("90821348"),"Amit","Aziz"),("dr_mory","JackMM@gatech.edu",SHA("12093015"),"Jack","Mory"),("ppee_admin","ppee_admin@gatech.edu",SHA("27536292"),"Admin","One"),("bppe_admin","bppe_admin@gatech.edu",SHA("35045790"),"Admin","Two"),("hsa_admin","hsa_admin@gatech.edu",SHA("75733271"),"Jennifer","Tree"),("gtpl_admin","gtpl_admin@gatech.edu",SHA("14506524"),"Shaundra","Apple"),("mmpc_admin","mmpc_admin@gatech.edu",SHA("22193897"),"Nicholas","Cage"),("sjc_admin","sjc_admin@gatech.edu",SHA("74454118"),"Trey","Germs"),("choa_admin","choa_admin@gatech.edu",SHA("62469488"),"Addison","Ambulance"),("piedmont_admin","piedmont_admin@gatech.edu",SHA("36846830"),"Rohan","Right"),("northside_admin","northside_admin@gatech.edu",SHA("38613312"),"Johnathan","Smith"),("emory_admin","emory_admin@gatech.edu",SHA("33202257"),"Elizabeth","Tucker"),("grady_admin","grady_admin@gatech.edu",SHA("67181125"),"Taylor","Booker"),("Burdell","GeorgeBurdell@gatech.edu",SHA("12345678"),"George","Burdell"),("Buzz","THWG@gatech.edu",SHA("98765432"),"Buzz","Tech");
INSERT INTO Business(name,address_street,address_city,address_state,address_zip) VALUES ("Children's Healthcare of Atlanta","Clifton Rd NE","Atlanta","Georgia","30332"),("Piedmont Hospital","Peachtree Rd NW","Atlanta","Georgia","30309"),("Northside Hospital","Johnson Ferry Road NE","Sandy Springs","Georgia","30342"),("Emory Midtown","Peachtree St NE","Atlanta","Georgia","30308"),("Grady Hospital","Jesse Hill Jr Dr SE","Atlanta","Georgia","30303"),("PPE Empire","Ponce De Leon Ave","Atlanta","Georgia","30308"),("Buy Personal Protective Equipment, Inc","Spring St","Atlanta","Georgia","30313"),("Healthcare Supplies of Atlanta","Peachstree St","Atlanta","Georgia","30308"),("Georgia Tech Protection Lab","North Ave NW","Atlanta","Georgia","30332"),("Marietta Mask Production Company","Appletree Way","Marietta","Georgia","30061"),("S&J Corporation","Juniper St","Atlanta","Georgia","30339");
INSERT INTO Product(id,name_color,name_type) VALUES ("WHMSK","white","mask"),("BLMSK","blue","mask"),("RDMSK","red","mask"),("GRMSK","green","mask"),("WHRES","white","respirator"),("YLRES","yellow","respirator"),("ORRES","orange","repirator"),("CLSHD","clear","shield"),("GRGOG","green","goggles"),("ORGOG","orange","goggles"),("WHGOG","white","goggles"),("BKGOG","black","goggles"),("BLSHC","blue","shoe cover"),("BLHOD","blue","hood"),("BLGWN","blue","gown"),("GRSHC","green","shoe cover"),("GRHOD","green","hood"),("GRGWN","green","gown"),("GYSHC","grey","shoe cover"),("GYHOD","grey","hood"),("GYGWN","grey","gown"),("WHSHC","white","shoe cover"),("WHHOD","white","hood"),("WHGWN","white","gown"),("BKSTE","black","stethoscope"),("WHSTE","white","stethoscope"),("SISTE","silver","stethoscope"),("BKGLO","black","gloves"),("WHGLO","white","gloves"),("GRGLO","green","gloves");
INSERT INTO Hospital(name,max_doctors,budget) VALUES ("Children's Healthcare of Atlanta",6,80000.00),("Piedmont Hospital",7,95000.00),("Northside Hospital",9,72000.00),("Emory Midtown",13,120000.00),("Grady Hospital",10,81000.00);
INSERT INTO Manufacturer(name,catalog_capacity) VALUES ("PPE Empire",20),("Buy Personal Protective Equipment, Inc",25),("Healthcare Supplies of Atlanta",20),("Georgia Tech Protection Lab",27),("Marietta Mask Production Company",15),("S&J Corporation",22);
INSERT INTO Inventory(owner,address_street,address_city,address_state,address_zip) VALUES ("Children's Healthcare of Atlanta","Storage St","Atlanta","Georgia","30309"),("Piedmont Hospital","Warehouse Way","Atlanta","Georgia","30332"),("Northside Hospital","Depot Dr","Dunwoody","Georgia","30338"),("Emory Midtown","Inventory Ct","Atlanta","Georgia","30308"),("Grady Hospital","Storehouse Pkwy","Atlanta","Georgia","30313"),("PPE Empire","Cache Ct","Lawrenceville","Georgia","30043"),("Buy Personal Protective Equipment, Inc","Stockpile St","Decatur","Georgia","30030"),("Healthcare Supplies of Atlanta","Depository Dr","Atlanta","Georgia","30303"),("Georgia Tech Protection Lab","Storehouse St","Atlanta","Georgia","30332"),("Marietta Mask Production Company","Repository Way","Marietta","Georgia","30008"),("S&J Corporation","Stash St","Suwanee","Georgia","30024");
INSERT INTO Doctor(username,hospital,manager) VALUES ("drCS4400","Children's Healthcare of Atlanta",NULL),("doctor_moss","Piedmont Hospital",NULL),("drmcdaniel","Northside Hospital",NULL),("musaev_doc","Emory Midtown",NULL),("doctor1","Grady Hospital",NULL),("doctor2","Children's Healthcare of Atlanta","drCS4400"),("fantastic","Piedmont Hospital","doctor_moss"),("allons_y","Northside Hospital","drmcdaniel"),("bow_ties _are_cool","Emory Midtown","musaev_doc"),("sonic_shades","Grady Hospital","doctor1"),("mcdreamy","Children's Healthcare of Atlanta","drCS4400"),("grey_jr","Piedmont Hospital","doctor_moss"),("young_doc","Northside Hospital","drmcdaniel"),("dr_dolittle","Emory Midtown","musaev_doc"),("bones","Grady Hospital","doctor1"),("doc_in_da_house","Children's Healthcare of Atlanta","drCS4400"),("jekyll_not_hyde","Piedmont Hospital","doctor_moss"),("drake_remoray","Northside Hospital","drmcdaniel"),("Jones01","Emory Midtown","musaev_doc"),("hannah_hills","Grady Hospital","doctor1"),("henryjk","Children's Healthcare of Atlanta","drCS4400"),("aziz_01","Piedmont Hospital","doctor_moss"),("dr_mory","Northside Hospital","drmcdaniel"),("Burdell","Northside Hospital","drmcdaniel"),("Buzz","Piedmont Hospital","doctor_moss");
INSERT INTO Administrator(username,business) VALUES ("ppee_admin","PPE Empire"),("bppe_admin","Buy Personal Protective Equipment, Inc"),("hsa_admin","Healthcare Supplies of Atlanta"),("gtpl_admin","Georgia Tech Protection Lab"),("mmpc_admin","Marietta Mask Production Company"),("sjc_admin","S&J Corporation"),("choa_admin","Children's Healthcare of Atlanta"),("piedmont_admin","Piedmont Hospital"),("northside_admin","Northside Hospital"),("emory_admin","Emory Midtown"),("grady_admin","Grady Hospital"),("Burdell","Northside Hospital"),("Buzz","Piedmont Hospital");
INSERT INTO CatalogItem(manufacturer,product_id,price) VALUES ("PPE Empire","WHMSK",1.25),("PPE Empire","BLMSK",1.35),("PPE Empire","RDMSK",1.30),("PPE Empire","GRMSK",1.45),("PPE Empire","WHRES",4.80),("PPE Empire","YLRES",5.10),("PPE Empire","ORRES",4.50),("Buy Personal Protective Equipment, Inc","BLSHC",0.90),("Buy Personal Protective Equipment, Inc","BLHOD",2.10),("Buy Personal Protective Equipment, Inc","BLGWN",3.15),("Buy Personal Protective Equipment, Inc","GRSHC",0.90),("Buy Personal Protective Equipment, Inc","GRHOD",2.10),("Buy Personal Protective Equipment, Inc","GRGWN",3.15),("Buy Personal Protective Equipment, Inc","GYSHC",0.90),("Buy Personal Protective Equipment, Inc","GYHOD",2.10),("Buy Personal Protective Equipment, Inc","GYGWN",3.15),("Buy Personal Protective Equipment, Inc","WHSHC",0.90),("Buy Personal Protective Equipment, Inc","WHHOD",2.10),("Buy Personal Protective Equipment, Inc","WHGWN",3.15),("Healthcare Supplies of Atlanta","ORGOG",3.00),("Healthcare Supplies of Atlanta","RDMSK",1.45),("Healthcare Supplies of Atlanta","CLSHD",6.05),("Healthcare Supplies of Atlanta","BLSHC",1.00),("Healthcare Supplies of Atlanta","BLHOD",2.00),("Healthcare Supplies of Atlanta","BLGWN",3.00),("Healthcare Supplies of Atlanta","YLRES",5.50),("Healthcare Supplies of Atlanta","WHMSK",1.10),("Healthcare Supplies of Atlanta","BLMSK",1.05),("Georgia Tech Protection Lab","CLSHD",5.95),("Georgia Tech Protection Lab","ORGOG",3.20),("Georgia Tech Protection Lab","WHGOG",3.20),("Georgia Tech Protection Lab","BKGOG",3.20),("Georgia Tech Protection Lab","GYSHC",0.75),("Georgia Tech Protection Lab","GYHOD",1.80),("Georgia Tech Protection Lab","GYGWN",3.25),("Marietta Mask Production Company","GRSHC",0.80),("Marietta Mask Production Company","GRHOD",1.65),("Marietta Mask Production Company","GRGWN",2.95),("Marietta Mask Production Company","GRMSK",1.25),("Marietta Mask Production Company","GRGOG",3.25),("S&J Corporation","BKSTE",5.20),("S&J Corporation","WHSTE",5.00),("S&J Corporation","SISTE",5.10),("S&J Corporation","BKGLO",0.30),("S&J Corporation","WHGLO",0.30),("S&J Corporation","GRGLO",0.30);
INSERT INTO Transaction(id,hospital,date) VALUES ("0001","Children's Healthcare of Atlanta","2020-03-10"),("0002","Children's Healthcare of Atlanta","2020-03-10"),("0003","Emory Midtown","2020-03-10"),("0004","Grady Hospital","2020-03-10"),("0005","Northside Hospital","2020-03-10"),("0006","Children's Healthcare of Atlanta","2020-03-10"),("0007","Piedmont Hospital","2020-03-10"),("0008","Northside Hospital","2020-05-01"),("0009","Children's Healthcare of Atlanta","2020-05-01"),("0010","Northside Hospital","2020-05-01"),("0011","Northside Hospital","2020-05-01"),("0012","Emory Midtown","2020-05-25"),("0013","Children's Healthcare of Atlanta","2020-05-25"),("0014","Emory Midtown","2020-05-25"),("0015","Emory Midtown","2020-05-25"),("0016","Northside Hospital","2020-05-25"),("0017","Grady Hospital","2020-06-03"),("0018","Grady Hospital","2020-06-03"),("0019","Grady Hospital","2020-06-03"),("0020","Piedmont Hospital","2020-06-03"),("0021","Piedmont Hospital","2020-06-04");
INSERT INTO TransactionItem(transaction_id,product_id,count,manufacturer) VALUES ("0001","WHMSK",500,"PPE Empire"),("0001","BLMSK",500,"PPE Empire"),("0002","BLSHC",300,"Buy Personal Protective Equipment, Inc"),("0003","BLMSK",500,"Healthcare Supplies of Atlanta"),("0004","ORGOG",150,"Healthcare Supplies of Atlanta"),("0004","RDMSK",150,"Healthcare Supplies of Atlanta"),("0004","CLSHD",200,"Healthcare Supplies of Atlanta"),("0004","BLSHC",100,"Healthcare Supplies of Atlanta"),("0005","WHMSK",300,"Healthcare Supplies of Atlanta"),("0006","BLSHC",400,"Buy Personal Protective Equipment, Inc"),("0007","GRMSK",100,"Marietta Mask Production Company"),("0007","GRGOG",300,"Marietta Mask Production Company"),("0008","ORGOG",200,"Georgia Tech Protection Lab"),("0008","WHGOG",200,"Georgia Tech Protection Lab"),("0009","GRSHC",500,"Marietta Mask Production Company"),("0009","GRHOD",500,"Marietta Mask Production Company"),("0010","WHGLO",500,"S&J Corporation"),("0011","WHHOD",200,"Buy Personal Protective Equipment, Inc"),("0011","WHGWN",200,"Buy Personal Protective Equipment, Inc"),("0012","BLSHC",50,"Buy Personal Protective Equipment, Inc"),("0013","BLHOD",100,"Healthcare Supplies of Atlanta"),("0013","BLGWN",100,"Healthcare Supplies of Atlanta"),("0014","WHRES",300,"PPE Empire"),("0014","YLRES",200,"PPE Empire"),("0014","ORRES",300,"PPE Empire"),("0015","GYGWN",50,"Buy Personal Protective Equipment, Inc"),("0016","CLSHD",20,"Healthcare Supplies of Atlanta"),("0016","ORGOG",300,"Healthcare Supplies of Atlanta"),("0016","BLHOD",100,"Healthcare Supplies of Atlanta"),("0017","RDMSK",200,"Healthcare Supplies of Atlanta"),("0017","CLSHD",180,"Healthcare Supplies of Atlanta"),("0018","WHHOD",500,"Buy Personal Protective Equipment, Inc"),("0019","GYGWN",300,"Buy Personal Protective Equipment, Inc"),("0020","BKSTE",50,"S&J Corporation"),("0020","WHSTE",50,"S&J Corporation"),("0021","CLSHD",100,"Georgia Tech Protection Lab"),("0021","ORGOG",200,"Georgia Tech Protection Lab");
INSERT INTO UsageLog(id,doctor,timestamp) VALUES ("10000","fantastic","2020-06-11 16:30:00"),("10001","jekyll_not_hyde","2020-06-11 17:00:00"),("10002","young_doc","2020-06-11 17:03:00"),("10003","fantastic","2020-06-12 08:23:00"),("10004","hannah_hills","2020-06-12 08:42:00"),("10005","mcdreamy","2020-06-12 09:00:00"),("10006","fantastic","2020-06-12 09:43:00"),("10007","doctor1","2020-06-12 10:11:00"),("10008","Jones01","2020-06-12 10:12:00"),("10009","henryjk","2020-06-12 10:23:00"),("10010","bones","2020-06-12 10:32:00"),("10011","dr_dolittle","2020-06-12 11:00:00"),("10012","drake_remoray","2020-06-12 11:14:00"),("10013","allons_y","2020-06-12 12:11:00"),("10014","dr_mory","2020-06-12 13:23:00"),("10015","Jones01","2020-06-12 13:52:00");
INSERT INTO UsageLogEntry(usage_log_id,product_id,count) VALUES ("10000","GRMSK",3),("10000","GRGOG",3),("10000","WHSTE",1),("10001","GRMSK",5),("10001","BKSTE",1),("10002","WHMSK",4),("10003","CLSHD",2),("10003","ORGOG",1),("10003","GRMSK",2),("10003","GRGOG",1),("10003","BKSTE",1),("10004","ORGOG",2),("10004","RDMSK",4),("10004","CLSHD",2),("10004","BLSHC",4),("10005","WHMSK",4),("10005","BLMSK",4),("10005","BLSHC",8),("10006","GRMSK",2),("10007","RDMSK",3),("10007","CLSHD",3),("10008","BLMSK",5),("10009","GRSHC",4),("10009","GRHOD",4),("10009","WHMSK",4),("10010","RDMSK",3),("10010","BLSHC",3),("10011","BLMSK",8),("10012","ORGOG",1),("10012","WHGOG",1),("10012","WHGLO",2),("10013","WHHOD",2),("10014","WHGOG",2),("10014","WHGWN",2),("10015","BLMSK",4);
INSERT INTO InventoryHasProduct(inventory_business,product_id,count) VALUES ("Children's Healthcare of Atlanta","WHMSK",5),("Children's Healthcare of Atlanta","BLMSK",220),("Children's Healthcare of Atlanta","WHRES",280),("Children's Healthcare of Atlanta","CLSHD",100),("Children's Healthcare of Atlanta","GRGOG",780),("Children's Healthcare of Atlanta","ORGOG",100),("Children's Healthcare of Atlanta","BLSHC",460),("Children's Healthcare of Atlanta","BLHOD",100),("Children's Healthcare of Atlanta","BLGWN",80),("Children's Healthcare of Atlanta","GRSHC",5),("Children's Healthcare of Atlanta","WHSTE",330),("Children's Healthcare of Atlanta","BKGLO",410),("Piedmont Hospital","BLSHC",3000),("Piedmont Hospital","BLHOD",3000),("Piedmont Hospital","BLGWN",420),("Piedmont Hospital","GRSHC",740),("Piedmont Hospital","GRHOD",560),("Piedmont Hospital","GRGWN",840),("Piedmont Hospital","SISTE",460),("Piedmont Hospital","BKGLO",4210),("Northside Hospital","WHRES",110),("Northside Hospital","YLRES",170),("Northside Hospital","ORRES",350),("Northside Hospital","CLSHD",410),("Northside Hospital","GRGOG",1),("Northside Hospital","ORGOG",100),("Emory Midtown","WHMSK",80),("Emory Midtown","BLMSK",210),("Emory Midtown","RDMSK",320),("Emory Midtown","GRMSK",40),("Emory Midtown","WHRES",760),("Emory Midtown","YLRES",140),("Emory Midtown","ORRES",20),("Emory Midtown","CLSHD",50),("Emory Midtown","GRGOG",70),("Emory Midtown","ORGOG",320),("Emory Midtown","WHGOG",140),("Emory Midtown","BKGOG",210),("Emory Midtown","BLSHC",630),("Grady Hospital","BLHOD",970),("Grady Hospital","BLGWN",310),("Grady Hospital","GRSHC",340),("Grady Hospital","GRHOD",570),("Grady Hospital","GRGWN",10),("Grady Hospital","GYSHC",20),("Grady Hospital","GYHOD",280),("Grady Hospital","GYGWN",240),("Grady Hospital","WHSHC",180),("Grady Hospital","WHHOD",140),("Grady Hospital","WHGWN",150),("Grady Hospital","BKSTE",210),("Grady Hospital","WHSTE",170),("Grady Hospital","SISTE",180),("Grady Hospital","BKGLO",70),("Grady Hospital","WHGLO",140),("Grady Hospital","GRGLO",80),("PPE Empire","WHMSK",850),("PPE Empire","BLMSK",1320),("PPE Empire","RDMSK",540),("PPE Empire","GRMSK",870),("PPE Empire","WHRES",500),("PPE Empire","ORRES",320),("Buy Personal Protective Equipment, Inc","BLSHC",900),("Buy Personal Protective Equipment, Inc","BLGWN",820),("Buy Personal Protective Equipment, Inc","GRSHC",700),("Buy Personal Protective Equipment, Inc","GRHOD",770),("Buy Personal Protective Equipment, Inc","GYSHC",250),("Buy Personal Protective Equipment, Inc","GYHOD",350),("Buy Personal Protective Equipment, Inc","GYGWN",850),("Buy Personal Protective Equipment, Inc","WHSHC",860),("Buy Personal Protective Equipment, Inc","WHHOD",700),("Buy Personal Protective Equipment, Inc","WHGWN",500),("Healthcare Supplies of Atlanta","ORGOG",860),("Healthcare Supplies of Atlanta","RDMSK",370),("Healthcare Supplies of Atlanta","CLSHD",990),("Healthcare Supplies of Atlanta","BLSHC",1370),("Healthcare Supplies of Atlanta","BLHOD",210),("Healthcare Supplies of Atlanta","BLGWN",680),("Healthcare Supplies of Atlanta","YLRES",890),("Healthcare Supplies of Atlanta","WHMSK",980),("Healthcare Supplies of Atlanta","BLMSK",5000),("Georgia Tech Protection Lab","CLSHD",620),("Georgia Tech Protection Lab","ORGOG",970),("Georgia Tech Protection Lab","WHGOG",940),("Georgia Tech Protection Lab","BKGOG",840),("Georgia Tech Protection Lab","GYSHC",610),("Georgia Tech Protection Lab","GYHOD",940),("Georgia Tech Protection Lab","GYGWN",700),("Marietta Mask Production Company","GRSHC",970),("Marietta Mask Production Company","GRHOD",750),("Marietta Mask Production Company","GRMSK",750),("Marietta Mask Production Company","GRGOG",320),("S&J Corporation","BKSTE",200),("S&J Corporation","WHSTE",860),("S&J Corporation","WHGLO",500),("S&J Corporation","GRGLO",420),("S&J Corporation","BKGLO",740);

