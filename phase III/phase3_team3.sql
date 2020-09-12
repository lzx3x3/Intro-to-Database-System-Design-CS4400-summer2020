/*
CS4400: Introduction to Database Systems
Summer 2020
Phase III Template

Team 03
Siying Cen (scen9)
Jinyu Huang (jhunag472)
Yiting Sun (ysun492)
Ken Xu (hxu323)

Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

/************** UTIL **************/
/* Feel free to add any utilty procedures you may need here */

-- Number:
-- Author: kachtani3@
-- Name: create_zero_inventory
-- Tested By: kachtani3@
DROP PROCEDURE IF EXISTS create_zero_inventory;
DELIMITER //
CREATE PROCEDURE create_zero_inventory(
	IN i_businessName VARCHAR(100),
    IN i_productId CHAR(5)
)
BEGIN
-- Type solution below
	IF (i_productId NOT IN (
		SELECT product_id FROM InventoryHasProduct WHERE inventory_business = i_businessName))
    THEN INSERT INTO InventoryHasProduct (inventory_business, product_id, count)
		VALUES (i_businessName, i_productId, 0);
	END IF;

-- End of solution
END //
DELIMITER ;


/************** INSERTS **************/

-- Number: I1
-- Author: kachtani3@
-- Name: add_usage_log
DROP PROCEDURE IF EXISTS add_usage_log;
DELIMITER //
CREATE PROCEDURE add_usage_log(
	IN i_usage_log_id CHAR(5),
    IN i_doctor_username VARCHAR(100),
    IN i_timestamp TIMESTAMP
)
BEGIN
-- Type solution below
insert into UsageLog (id, doctor, timestamp) values (i_usage_log_id, i_doctor_username, i_timestamp);
-- End of solution
END //
DELIMITER ;

-- Number: I2
-- Author: ty.zhang@
-- Name: add_usage_log_entry
DROP PROCEDURE IF EXISTS add_usage_log_entry;
DELIMITER //
CREATE PROCEDURE add_usage_log_entry(
	IN i_usage_log_id CHAR(5),
    IN i_product_id CHAR(5),
    IN i_count INT
)
BEGIN
-- Type solution below
if ((i_usage_log_id in (select distinct id from UsageLog))
and (i_product_id not in (select product_id from UsageLogEntry where usage_log_id = i_usage_log_id))
and (i_count <= (select InventoryHasProduct.count
from InventoryHasProduct
where InventoryHasProduct.product_id = i_product_id and inventory_business = (select hospital from Doctor where username = (select doctor from UsageLog where id = i_usage_log_id)))))
then insert into UsageLogEntry (usage_log_id, product_id, count) values (i_usage_log_id, i_product_id, i_count);
update InventoryHasProduct set InventoryHasProduct.count = (InventoryHasProduct.count - i_count) where (InventoryHasProduct.product_id = i_product_id and inventory_business = (select hospital from Doctor where username = (select doctor from UsageLog where id = i_usage_log_id)));
end if;
-- End of solution
END //
DELIMITER ;

-- Number: I3
-- Author: yxie@
-- Name: add_business
DROP PROCEDURE IF EXISTS add_business;
DELIMITER //
CREATE PROCEDURE add_business(
	IN i_name VARCHAR(100),
    IN i_BusinessStreet VARCHAR(100),
    IN i_BusinessCity VARCHAR(100),
    IN i_BusinessState VARCHAR(30),
    IN i_BusinessZip CHAR(5),
    IN i_businessType ENUM('Hospital', 'Manufacturer'),
    IN i_maxDoctors INT,
    IN i_budget FLOAT(2),
    IN i_catalog_capacity INT,
    IN i_InventoryStreet VARCHAR(100),
    IN i_InventoryCity VARCHAR(100),
    IN i_InventoryState VARCHAR(30),
    IN i_InventoryZip CHAR(5)
)
BEGIN
-- Type solution below
INSERT INTO business (name, address_street, address_city, address_state, address_zip) values
(i_name, i_BusinessStreet, i_BusinessCity, i_BusinessState, i_BusinessZip);

IF (i_businessType = 'Hospital' AND (i_maxDoctors is not null) AND (i_budget is not null))
then INSERT INTO hospital (name, max_doctors, budget) values (i_name, i_maxDoctors, i_budget);
end if;

IF (i_businessType = 'Manufacturer' AND (i_catalog_capacity is not null))
then INSERT INTO manufacturer (name, catalog_capacity) values  (i_name, i_catalog_capacity);
end if;

IF (i_InventoryStreet is not null AND i_InventoryCity is not null AND i_InventoryState is not null AND i_InventoryZip is not null)
then INSERT INTO inventory  (owner, address_street, address_city, address_state, address_zip) values (i_name, i_InventoryStreet, i_InventoryCity, i_InventoryState, i_InventoryZip);
end if;
-- End of solution
END //
DELIMITER ;

-- Number: I4
-- Author: kachtani3@
-- Name: add_transaction
DROP PROCEDURE IF EXISTS add_transaction;
DELIMITER //
CREATE PROCEDURE add_transaction(
	IN i_transaction_id CHAR(4),
    IN i_hospital VARCHAR(100),
    IN i_date DATE
)
BEGIN
-- Type solution below

INSERT INTO Transaction(id, hospital, date) VALUES (i_transaction_id, i_hospital, i_date);

-- End of solution
END //
DELIMITER ;

-- Number: I5
-- Author: kachtani3@
-- Name: add_transaction_item
DROP PROCEDURE IF EXISTS add_transaction_item;
DELIMITER //
CREATE PROCEDURE add_transaction_item(
    IN i_transactionId CHAR(4),
    IN i_productId CHAR(5),
    IN i_manufacturerName VARCHAR(100),
    IN i_purchaseCount INT)
BEGIN
-- Type solution below
set @total_cost = i_purchaseCount * (select price from CatalogItem where manufacturer = i_manufacturerName and product_id = i_productId);
set @hospital_name = (select hospital from Transaction where id = i_transactionId);
  if  (
        (i_purchaseCount <= (select count from InventoryHasProduct where inventory_business = i_manufacturerName and product_id = i_productId))
        and
        (@total_cost <= (select budget from (select hospital from Transaction where id = i_transactionId) as a join Hospital as b where a.hospital = b.name))
      )
  then
    insert into TransactionItem (transaction_id, manufacturer, product_id, count)
      VALUES (i_transactionId, i_manufacturerName, i_productId, i_purchaseCount);
    update Hospital set budget = (budget - @total_cost) 
      where name = (select hospital from Transaction where id = i_transactionId);
    update InventoryHasProduct set count = (count - i_purchaseCount) 
      where inventory_business = i_manufacturerName and product_id = i_productId;
    if (@hospital_name, i_productId) not in (select inventory_business, product_id from InventoryHasProduct)
    then
    insert into InventoryHasProduct (inventory_business, product_id, count)
      values (@hospital_name, i_productID, i_purchaseCount);
    else
    update InventoryHasProduct SET count = (count + i_purchaseCount) 
      where inventory_business = @hospital_name and product_id = i_productId;
    end if;
    call delete_zero_inventory();
  end if;
-- End of solution
END //
DELIMITER ;

-- Number: I6
-- Author: yxie@
-- Name: add_user
DROP PROCEDURE IF EXISTS add_user;
DELIMITER //
CREATE PROCEDURE add_user(
	IN i_username VARCHAR(100),
    IN i_email VARCHAR(100),
    IN i_password VARCHAR(100),
    IN i_fname VARCHAR(50),
    IN i_lname VARCHAR(50),
    IN i_userType ENUM('Doctor', 'Admin', 'Doctor-Admin'),
    IN i_managingBusiness VARCHAR(100),
    IN i_workingHospital VARCHAR(100)
)
BEGIN
-- Type solution below
  if (i_username not in (select username from User))
    and
    (i_email not in (select email from User))
  then
      if i_userType = 'Doctor' then
        insert into User(username, email, password, fname, lname) values (i_username, i_email, SHA(i_password), i_fname, i_lname);
        insert into Doctor(username, hospital, manager) values (i_username, i_workingHospital, NULL);
      elseif i_userType = 'Admin' then
        insert into User(username, email, password, fname, lname) values (i_username, i_email, SHA(i_password), i_fname, i_lname);
        insert into Administrator(username, business) values (i_username, i_managingBusiness);
      elseif i_userType = 'Doctor-Admin' then
        insert into User(username, email, password, fname, lname) values (i_username, i_email, SHA(i_password), i_fname, i_lname);
        insert into Doctor(username, hospital, manager) values (i_username, i_workingHospital, NULL);
        insert into Administrator(username, business) values (i_username, i_managingBusiness);
    end if;
  end if;
-- End of solution
END //
DELIMITER ;

-- Number: I7
-- Author: klin83@
-- Name: add_catalog_item
DROP PROCEDURE IF EXISTS add_catalog_item;
DELIMITER //
CREATE PROCEDURE add_catalog_item(
    IN i_manufacturerName VARCHAR(100),
	IN i_product_id CHAR(5),
    IN i_price FLOAT(2)
)
BEGIN
-- Type solution below
	insert into CatalogItem (manufacturer,product_id,price)
    values (i_manufacturerName, i_product_id, i_price);
-- End of solution
END //
DELIMITER ;

-- Number: I8
-- Author: ftsang3@
-- Name: add_product
DROP PROCEDURE IF EXISTS add_product;
DELIMITER //
CREATE PROCEDURE add_product(
	IN i_prod_id CHAR(5),
    IN i_color VARCHAR(30),
    IN i_name VARCHAR(30)
)
BEGIN
-- Type solution below
	insert into Product(id,name_color,name_type)
    values(i_prod_id, i_color, i_name);
-- End of solution
END //
DELIMITER ;


/************** DELETES **************/
-- NOTE: Do not circumvent referential ON DELETE triggers by manually deleting parent rows

-- Number: D1
-- Author: ty.zhang@
-- Name: delete_product
DROP PROCEDURE IF EXISTS delete_product;
DELIMITER //
CREATE PROCEDURE delete_product(
    IN i_product_id CHAR(5)
)
BEGIN
-- Type solution below
	delete from Product
    where id = i_product_id;
-- End of solution
END //
DELIMITER ;

-- Number: D2
-- Author: kachtani3@
-- Name: delete_zero_inventory
DROP PROCEDURE IF EXISTS delete_zero_inventory;
DELIMITER //
CREATE PROCEDURE delete_zero_inventory()
BEGIN
-- Type solution below
  delete from InventoryHasProduct where count = 0;
-- End of solution
END //
DELIMITER ;

-- Number: D3
-- Author: ftsang3@
-- Name: delete_business
DROP PROCEDURE IF EXISTS delete_business;
DELIMITER //
CREATE PROCEDURE delete_business(
    IN i_businessName VARCHAR(100)
)
BEGIN
-- Type solution below
	DELETE FROM Business where name = i_businessName;
-- End of solution
END //
DELIMITER ;

-- Number: D4
-- Author: ftsang3@
-- Name: delete_user
DROP PROCEDURE IF EXISTS delete_user;
DELIMITER //
CREATE PROCEDURE delete_user(
    IN i_username VARCHAR(100)
)
BEGIN
-- Type solution below
delete from User where User.username = i_username;
-- End of solution
END //
DELIMITER ;

-- Number: D5
-- Author: klin83@
-- Name: delete_catalog_item
DROP PROCEDURE IF EXISTS delete_catalog_item;
DELIMITER //
CREATE PROCEDURE delete_catalog_item(
    IN i_manufacturer_name VARCHAR(100),
    IN i_product_id CHAR(5)
)
BEGIN
-- Type solution below
  delete from CatalogItem where manufacturer = i_manufacturer_name and product_id = i_product_id;
-- End of solution
END //
DELIMITER ;


/************** UPDATES **************/

-- Number: U1
-- Author: kachtani3@
-- Name: add_subtract_inventory
DROP PROCEDURE IF EXISTS add_subtract_inventory;
DELIMITER //
CREATE PROCEDURE add_subtract_inventory(
	IN i_prod_id CHAR(5),
    IN i_businessName VARCHAR(100),
    IN i_delta INT
)
BEGIN
-- Type solution below
  if (i_businessName, i_prod_id) not in (select inventory_business, product_id from InventoryHasProduct) then
    if (i_delta > 0) then
      insert into InventoryHasProduct(inventory_business, product_id, count) values (i_businessName, i_prod_id, i_delta);
    end if;
  else
    set @current_count = (select count from InventoryHasProduct where inventory_business = i_businessname and product_id = i_prod_id);
    if (@current_count + i_delta >= 0) then
      update InventoryHasProduct set count = count + i_delta where inventory_business = i_businessname and product_id = i_prod_id;
      call delete_zero_inventory();
    end if;
  end if;
-- End of solution
END //
DELIMITER ;

-- Number: U2
-- Author: kachtani3@
-- Name: move_inventory
DROP PROCEDURE IF EXISTS move_inventory;
DELIMITER //
CREATE PROCEDURE move_inventory(
    IN i_supplierName VARCHAR(100),
    IN i_consumerName VARCHAR(100),
    IN i_productId CHAR(5),
    IN i_count INT)
BEGIN
-- Type solution below
  set @supplier_count = (select count from InventoryHasProduct where inventory_business = i_supplierName and product_id = i_productId);
  if (@supplier_count >= i_count) then
    update InventoryHasProduct set count = count - i_count where inventory_business = i_supplierName and product_id = i_productId;
    if (i_consumerName, i_productId) not in (select inventory_business, product_id from InventoryHasProduct) then
      insert into InventoryHasProduct(inventory_business, product_id, count) values (i_consumerName, i_productId, i_count);
    else
      update InventoryHasProduct set count = count + i_count where inventory_business = i_consumerName and product_id = i_productId;
    end if;
  call delete_zero_inventory();
  end if;
-- End of solution
END //
DELIMITER ;

-- Number: U3
-- Author: ty.zhang@
-- Name: rename_product_id
DROP PROCEDURE IF EXISTS rename_product_id;
DELIMITER //
CREATE PROCEDURE rename_product_id(
    IN i_product_id CHAR(5),
    IN i_new_product_id CHAR(5)
)
BEGIN
-- Type solution below
	update Product
    set id = i_new_product_id
    where id = i_product_id;
-- End of solution
END //
DELIMITER ;

-- Number: U4
-- Author: ty.zhang@
-- Name: update_business_address
DROP PROCEDURE IF EXISTS update_business_address;
DELIMITER //
CREATE PROCEDURE update_business_address(
    IN i_name VARCHAR(100),
    IN i_address_street VARCHAR(100),
    IN i_address_city VARCHAR(100),
    IN i_address_state VARCHAR(30),
    IN i_address_zip CHAR(5)
)
BEGIN
-- Type solution below
update business set address_street = i_address_street, address_city = i_address_city, address_state = i_address_state, address_zip = i_address_zip
where name = i_name;


-- End of solution
END //
DELIMITER ;

-- Number: U5
-- Author: kachtani3@
-- Name: charge_hospital
DROP PROCEDURE IF EXISTS charge_hospital;
DELIMITER //
CREATE PROCEDURE charge_hospital(
    IN i_hospital_name VARCHAR(100),
    IN i_amount FLOAT(2))
BEGIN
-- Type solution below
if (select budget from hospital where name = i_hospital_name) >= i_amount
then update hospital set budget = (budget - i_amount) where name = i_hospital_name;
end if;
-- End of solution
END //
DELIMITER ;

-- Number: U6
-- Author: yxie@
-- Name: update_business_admin
DROP PROCEDURE IF EXISTS update_business_admin;
DELIMITER //
CREATE PROCEDURE update_business_admin(
	IN i_admin_username VARCHAR(100),
	IN i_business_name VARCHAR(100)
)
BEGIN
-- Type solution below
if i_admin_username not in (select username from Administrator) then
  insert into Administrator (username, business) values (i_admin_username, i_business_name);
else
  set @admin_current_business = (select business from Administrator where username = i_admin_username);
  if (select count(*) from Administrator where business = @admin_current_business) > 1 then
    update Administrator set business = i_business_name where username = i_admin_username;
  end if;
end if;
-- End of solution
END //
DELIMITER ;

-- Number: U7
-- Author: ftsang3@
-- Name: update_doctor_manager
DROP PROCEDURE IF EXISTS update_doctor_manager;
DELIMITER //
CREATE PROCEDURE update_doctor_manager(
    IN i_doctor_username VARCHAR(100),
    IN i_manager_username VARCHAR(100)
)
BEGIN
-- Type solution below
IF i_doctor_username <> i_manager_username
    THEN
		UPDATE Doctor SET manager = i_manager_username WHERE username = i_doctor_username;
	END IF;
-- End of solution
END //
DELIMITER ;

-- Number: U8
-- Author: ftsang3@
-- Name: update_user_password
DROP PROCEDURE IF EXISTS update_user_password;
DELIMITER //
CREATE PROCEDURE update_user_password(
    IN i_username VARCHAR(100),
	IN i_new_password VARCHAR(100)
)
BEGIN
-- Type solution below
update User
set password = SHA(i_new_password)
where username = i_username;
-- End of solution
END //
DELIMITER ;

-- Number: U9
-- Author: klin83@
-- Name: batch_update_catalog_item
DROP PROCEDURE IF EXISTS batch_update_catalog_item;
DELIMITER //
CREATE PROCEDURE batch_update_catalog_item(
    IN i_manufacturer_name VARCHAR(100),
    IN i_factor FLOAT(2))
BEGIN
-- Type solution below
	update CatalogItem
    set price = price*i_factor
    where manufacturer = i_manufacturer_name;
-- End of solution
END //
DELIMITER ;

/************** SELECTS **************/
-- NOTE: "SELECT * FROM USER" is just a dummy query
-- to get the script to run. You will need to replace that line
-- with your solution.

-- Number: S1
-- Author: ty.zhang@
-- Name: hospital_transactions_report
DROP PROCEDURE IF EXISTS hospital_transactions_report;
DELIMITER //
CREATE PROCEDURE hospital_transactions_report(
    IN i_hospital VARCHAR(100),
    IN i_sortBy ENUM('', 'id', 'date'),
    IN i_sortDirection ENUM('', 'DESC', 'ASC')
)
BEGIN
    DROP TABLE IF EXISTS hospital_transactions_report_result;
    CREATE TABLE hospital_transactions_report_result(
        id CHAR(4),
        manufacturer VARCHAR(100),
        hospital VARCHAR(100),
        total_price FLOAT,
        date DATE);

    INSERT INTO hospital_transactions_report_result
-- Type solution below
	SELECT T.id,  TI.manufacturer, T.hospital, ROUND(sum(TI.count * C.price), 2) as total_price, T.date
    FROM transaction AS T RIGHT JOIN (transactionitem AS TI JOIN catalogitem AS C ON TI.product_id = C.product_id AND TI.manufacturer = C.manufacturer) ON TI.transaction_id = T.id
    where T.hospital = i_hospital
    group by T.id
    order by 
		CASE WHEN i_sortBy = 'id' AND i_sortDirection = 'DESC' THEN T.id END DESC,
		CASE WHEN i_sortBy = 'id' AND i_sortDirection = 'ASC' THEN T.id END ASC,
        CASE WHEN i_sortBy = 'date' AND i_sortDirection = 'DESC' THEN date END DESC,
		CASE WHEN i_sortBy = 'date' AND i_sortDirection = 'ASC' THEN date END ASC;
-- End of solution
END //
DELIMITER ;

-- Number: S2
-- Author: ty.zhang@
-- Name: num_of_admin_list
DROP PROCEDURE IF EXISTS num_of_admin_list;
DELIMITER //
CREATE PROCEDURE num_of_admin_list()
BEGIN
    DROP TABLE IF EXISTS num_of_admin_list_result;
    CREATE TABLE num_of_admin_list_result(
        businessName VARCHAR(100),
        businessType VARCHAR(100),
        numOfAdmin INT);

    INSERT INTO num_of_admin_list_result
-- Type solution below
    SELECT H.name, 'Hospital', count(*)
    FROM Hospital AS H, Administrator AS A
    WHERE name = business
    GROUP BY H.name
    UNION
    SELECT M.name, 'Manufacturer', count(*)
    FROM Manufacturer AS M, Administrator AS A
    WHERE name = business
    GROUP BY M.name;
-- End of solution
END //
DELIMITER ;

-- Number: S3
-- Author: ty.zhang@
-- Name: product_usage_list
DROP PROCEDURE IF EXISTS product_usage_list;
DELIMITER //
CREATE PROCEDURE product_usage_list()

BEGIN
    DROP TABLE IF EXISTS product_usage_list_result;
    CREATE TABLE product_usage_list_result(
        product_id CHAR(5),
        product_color VARCHAR(30),
        product_type VARCHAR(30),
        num INT);

    INSERT INTO product_usage_list_result
-- Type solution below
    select id, name_color, name_type, ifnull(total,0) as all_use
from Product
left outer join (select product_id, sum(count) as total from UsageLogEntry group by product_id) as a
on product_id = id
order by all_use desc;
-- End of solution
END //
DELIMITER ;

-- Number: S4
-- Author: ty.zhang@
-- Name: hospital_total_expenditure
DROP PROCEDURE IF EXISTS hospital_total_expenditure;
DELIMITER //
CREATE PROCEDURE hospital_total_expenditure()

BEGIN
    DROP TABLE IF EXISTS hospital_total_expenditure_result;
    CREATE TABLE hospital_total_expenditure_result(
        hospitalName VARCHAR(100),
        totalExpenditure FLOAT,
        transaction_count INT,
        avg_cost FLOAT);

    INSERT INTO hospital_total_expenditure_result
-- Type solution below

(SELECT T.hospital AS hospitalName, ROUND(sum(TI.count * C.price), 2) as totalExpenditure, count(distinct id) AS transaction_count, ROUND((sum(TI.count * C.price)/count(distinct id)), 2) AS avg_cost
 FROM transaction AS T RIGHT JOIN (transactionitem AS TI JOIN catalogitem AS C ON TI.product_id = C.product_id AND TI.manufacturer = C.manufacturer) ON TI.transaction_id = T.id
 GROUP by T.hospital);
  
insert into hospital_total_expenditure_result (select t1.name, 0, 0, 0 from Hospital as t1 left join hospital_total_expenditure_result as t2 on t2.hospitalName = t1.name where t2.hospitalName is null);
    
-- End of solution
END //
DELIMITER ;

-- Number: S5
-- Author: kachtani3@
-- Name: manufacturer_catalog_report
DROP PROCEDURE IF EXISTS manufacturer_catalog_report;
DELIMITER //
CREATE PROCEDURE manufacturer_catalog_report(
    IN i_manufacturer VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS manufacturer_catalog_report_result;
    CREATE TABLE manufacturer_catalog_report_result(
        name_color VARCHAR(30),
        name_type VARCHAR(30),
        price FLOAT(2),
        num_sold INT,
        revenue FLOAT(2));
    INSERT INTO manufacturer_catalog_report_result
-- Type solution below
	select name_color,name_type,price, count, round(price*TransactionItem.count,2)
    from (CatalogItem join Product on product_id = id) left join TransactionItem on CatalogItem.manufacturer = TransactionItem.manufacturer and TransactionItem.product_id = id
    where CatalogItem.manufacturer = i_manufacturer
    ORDER BY round(price*TransactionItem.count,2) DESC;
	UPDATE manufacturer_catalog_report_result SET num_sold = 0 WHERE num_sold IS NULL;
	UPDATE manufacturer_catalog_report_result SET revenue = 0 WHERE revenue IS NULL;
-- End of solution
END //
DELIMITER ;

-- Number: S6
-- Author: kachtani3@
-- Name: doctor_subordinate_usage_log_report
DROP PROCEDURE IF EXISTS doctor_subordinate_usage_log_report;
DELIMITER //
CREATE PROCEDURE doctor_subordinate_usage_log_report(
    IN i_drUsername VARCHAR(100))
BEGIN
    DROP TABLE IF EXISTS doctor_subordinate_usage_log_report_result;
    CREATE TABLE doctor_subordinate_usage_log_report_result(
        id CHAR(5),
        doctor VARCHAR(100),
        timestamp TIMESTAMP,
        product_id CHAR(5),
        count INT);

    INSERT INTO doctor_subordinate_usage_log_report_result
-- Type solution below
	(SELECT usage_log_id, doctor, timestamp, product_id, count
    from UsageLogEntry, UsageLog, Doctor
    where usage_log_id = id and doctor = username and manager = i_drUsername)
    union
    (select usage_log_id, doctor, timestamp, product_id, count
    from UsageLogEntry, UsageLog
    where usage_log_id = id and doctor = i_drUsername);
-- End of solution
END //
DELIMITER ;

-- Number: S7
-- Author: klin83@
-- Name: explore_product
DROP PROCEDURE IF EXISTS explore_product;
DELIMITER //
CREATE PROCEDURE explore_product(
    IN i_product_id CHAR(5))
BEGIN
    DROP TABLE IF EXISTS explore_product_result;
    CREATE TABLE explore_product_result(
        manufacturer VARCHAR(100),
        count INT,
        price FLOAT(2));

    INSERT INTO explore_product_result
-- Type solution below
	select inventory_business, InventoryHasProduct.count, price
	from (Manufacturer join InventoryHasProduct on name = inventory_business) join CatalogItem on name = manufacturer and CatalogItem.product_id = InventoryHasProduct.product_id
	where InventoryHasProduct.product_id = i_product_id;
-- End of solution
END //
DELIMITER ;

-- Number: S8
-- Author: klin83@
-- Name: show_product_usage
DROP PROCEDURE IF EXISTS show_product_usage;
DELIMITER //
CREATE PROCEDURE show_product_usage()
BEGIN
    DROP TABLE IF EXISTS show_product_usage_result;
    CREATE TABLE show_product_usage_result(
        product_id CHAR(5),
        num_used INT,
        num_available INT,
        ratio FLOAT);

    INSERT INTO show_product_usage_result
-- Type solution below
	select id, round(used,2), round(sum(count),2),  round(used/sum(count), 2)
	from 
		(select id, sum(count) as used 
		from Product left join UsageLogEntry on Product.id = product_id 
		group by id) as tmp1
		left join 
		(select * 
        from InventoryHasProduct 
        where inventory_business in (select name from Manufacturer)) as tmp2
        on tmp1.id = tmp2.product_id
	group by id;
    UPDATE show_product_usage_result SET num_used = 0 WHERE num_used IS NULL;
	UPDATE show_product_usage_result SET num_available = 0 WHERE num_available IS NULL;
    UPDATE show_product_usage_result SET ratio = 0 WHERE ratio IS NULL;
-- End of solution
END //
DELIMITER ;

-- Number: S9
-- Author: klin83@
-- Name: show_hospital_aggregate_usage
DROP PROCEDURE IF EXISTS show_hospital_aggregate_usage;
DELIMITER //
CREATE PROCEDURE show_hospital_aggregate_usage()
BEGIN
    DROP TABLE IF EXISTS show_hospital_aggregate_usage_result;
    CREATE TABLE show_hospital_aggregate_usage_result(
        hospital VARCHAR(100),
        items_used INT);

    INSERT INTO show_hospital_aggregate_usage_result
-- Type solution below
    (select hospital, sum(sum_count) as hospital_sum_count
    from (select id, doctor, hospital
    from usageLog join Doctor
    where doctor = username) as a
    join
    (select usage_log_id, sum(count) as sum_count
    from UsageLogEntry
    group by usage_log_id) as b
    where a.id = b.usage_log_id
    group by hospital)
    
    union
    
    (select name, 0
    from Hospital
    where name not in
    (select hospital
    from (select id, doctor, hospital
    from usageLog join Doctor
    where doctor = username) as a
    join
    (select usage_log_id, sum(count) as sum_count
    from UsageLogEntry
    group by usage_log_id) as b
    where a.id = b.usage_log_id
    group by hospital));
-- End of solution
END //
DELIMITER ;

-- Number: S10
-- Author: ftsang3
-- Name: business_search
DROP PROCEDURE IF EXISTS business_search;
DELIMITER //
CREATE PROCEDURE business_search (
    IN i_search_parameter ENUM("name","street", "city", "state", "zip"),
    IN i_search_value VARCHAR(100))
BEGIN
	DROP TABLE IF EXISTS business_search_result;
    CREATE TABLE business_search_result(
        name VARCHAR(100),
		address_street VARCHAR(100),
		address_city VARCHAR(100),
		address_state VARCHAR(30),
		address_zip CHAR(5));

-- Type solution below
	IF i_search_parameter = "name" THEN
		INSERT INTO business_search_result
        select *
        from Business
		where name LIKE CONCAT('%',i_search_value,'%');
    ELSEIF i_search_parameter = "street" THEN
		INSERT INTO business_search_result
        select * from Business
		where address_street LIKE CONCAT('%',i_search_value,'%');
    ELSEIF i_search_parameter = "state" THEN
		INSERT INTO business_search_result
        select * from Business
		where address_state LIKE CONCAT('%',i_search_value,'%');
    ELSEIF i_search_parameter = "zip" THEN
		INSERT INTO business_search_result
        select * from Business
		where address_zip LIKE CONCAT('%',i_search_value,'%');
	ELSE 
		INSERT INTO business_search_result
        select * from Business;
	END IF;
-- End of solution
END //
DELIMITER ;

-- Number: S11
-- Author: ftsang3@
-- Name: manufacturer_transaction_report
DROP PROCEDURE IF EXISTS manufacturer_transaction_report;
DELIMITER //
CREATE PROCEDURE manufacturer_transaction_report(
    IN i_manufacturer VARCHAR(100))

BEGIN
    DROP TABLE IF EXISTS manufacturer_transaction_report_result;
    CREATE TABLE manufacturer_transaction_report_result(
        id CHAR(4),
        hospital VARCHAR(100),
        `date` DATE,
        cost FLOAT(2),
        total_count INT);

    INSERT INTO manufacturer_transaction_report_result
-- Type solution below
    SELECT distinct T.id , T.hospital, T.date,  ROUND(sum(TI.count * C.price), 2) as cost, sum(TI.count) AS total_count
	FROM transaction AS T RIGHT JOIN (transactionitem AS TI JOIN catalogitem AS C ON TI.product_id = C.product_id AND TI.manufacturer = C.manufacturer) ON TI.transaction_id = T.id
	WHERE TI.manufacturer = i_manufacturer
	GROUP BY T.id;
-- End of solution
END //
DELIMITER ;

-- Number: S12
-- Author: yxie@
-- Name: get_user_types
-- Tested By: yxie@
DROP PROCEDURE IF EXISTS get_user_types;
DELIMITER //
CREATE PROCEDURE get_user_types()
BEGIN
DROP TABLE IF EXISTS get_user_types_result;
    CREATE TABLE get_user_types_result(
        username VARCHAR(100),
        UserType VARCHAR(50));
	INSERT INTO get_user_types_result
-- Type solution below
  (select username, 'Doctor'
  from Doctor
  where username not in
  (select username
  from Administrator) and username not in
  (select distinct manager
  from Doctor
  where manager is not null))
  union
  (select distinct manager, 'Doctor-Manager'
  from Doctor
  where manager is not null and 
  manager not in 
  (select username
  from Administrator))
  union
  (select username, 'Doctor-Admin'
  from Doctor
  where username in
  (select username
  from Administrator) and username not in
  (select distinct manager
  from Doctor
  where manager is not null))
  union
  (select username, 'Admin'
  from Administrator
  where username not in
  (select username
  from Doctor))
  union
  (select distinct manager, 'Doctor-Admin-Manager'
  from Doctor
  where manager is not null and 
  manager in
  (select username
  from Administrator));
-- End of solution
END //
DELIMITER ;
