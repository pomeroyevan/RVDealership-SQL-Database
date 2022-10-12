/* Evan Pomeroy, Miyu Nishii, Ty Williams BUS393-02 */

/* Drops vendor, purchase order, sales invoice, service invoice, service veichle tables from the database*/
/* Drops vendor list, RV sales list, RV purchase list, and service invoice list view */
DROP TABLE Vendor CASCADE CONSTRAINTS PURGE;
DROP TABLE Purchase_Order CASCADE CONSTRAINTS PURGE;
DROP TABLE Sales_Inv CASCADE CONSTRAINTS PURGE;
DROP TABLE Serv_Inv CASCADE CONSTRAINTS PURGE;
DROP VIEW Vendor_List;
DROP VIEW RV_SALES_LIST;
DROP VIEW RV_PURCHASE_LIST;
DROP VIEW Service_Invoice_List;

/* Creates vendor table with attributes: company name, contact name, street, city, state, zip, phone, fax and its appropriate data types*/
/* Enforces entity integrity at the table level of reasonable not null constraints, and primary key constraint of company name */

CREATE TABLE Vendor (
    Company_Name        VARCHAR2(20)     NOT NULL,
    Contact_Name        VARCHAR2(30)     NOT NULL,
    Contacte_email      VARCHAR2(40)     NOT NULL,
    Street              VARCHAR2(30),
    City                VARCHAR2(30),
    Statev              CHAR(2),
    Zip                 VARCHAR2(6),
    Phone               VARCHAR2(11)     NOT NULL,
    Fax                 VARCHAR2(15),
    CONSTRAINT ven_coN_pk PRIMARY KEY(Company_Name)
);

/*Inserts into vendor table 5 vendors created, with attributes indicated into the above create vendor table statement*/
INSERT INTO Vendor
    VALUES ('Andys RV', 'Andy Allen', 'andyallen@gmail.com','111 Alberta Drive', 'Ander Valley', 'AL',111111,18001111111,18001111112);


INSERT INTO Vendor
    VALUES ('Betty RV', 'Betty Blue', 'bettyblue@gmail.com','222 Bear Drive', 'Basin', 'CA',222222,18002222222,18002222221);

    
INSERT INTO Vendor
    VALUES ('Clint RV', 'Clint Calver', 'clintcalver@gmail.com','333 Carrey Drive', 'Carter', 'CA',333333,18003333333,18003333332);

    
INSERT INTO Vendor
    VALUES ('Doug RV', 'Doug Dimmadome', 'dougdimmadome@gmail.com','Drippy Drive', 'Dickson', 'DE',444444,18004444444,18004444443);


INSERT INTO Vendor
    VALUES ('Edward RV', 'Eddie Elton', 'eddieelton@gmail.com','Elephant Drive', 'Elkridge', 'CA',555555,1800555555,18005555554);



/* Creates purchase order table (assuming shipping is same for all orders) with attributes determined by reviewing the business document  */
/* Enforces table level entity integrity of unique constraint for VIN attribute so no VIN numbers are identical, appropriate not null constraints so defined attributes are required, and identifies invoice number as the primary key*/
/* Enforces table level referential integrity for appropriate foreign key constraints for purchase from, vin, and approved attributes from other tables.*/
/* Enforces table level domain integrity for sales date. If no date is entered, current date is entered */
CREATE TABLE Purchase_Order (
    Inv_Num         NUMBER(4),
    Sales_Date      DATE            DEFAULT SYSDATE,
    Terms           VARCHAR2(10)    NOT NULL,
    Approved        NUMBER(4),
    VIN             NUMBER(6)       NOT NULL,
    Purchase_From   VARCHAR2(20)    NOT NULL,
    Sales_Ammount   NUMBER(7)       NOT NULL,
    Shipping        NUMBER(6),
    CONSTRAINT po_vin_uk    UNIQUE(VIN),
    CONSTRAINT po_vpf_fk    FOREIGN KEY(Purchase_From) REFERENCES Vendor(Company_Name),
    CONSTRAINT po_vin_fk    FOREIGN KEY(VIN) REFERENCES sales_rv(VIN),
    CONSTRAINT po_pb_fk     FOREIGN KEY(Approved) REFERENCES employee(EMPLOYEE_ID),
    CONSTRAINT po_inv_pk    PRIMARY KEY(Inv_Num)
);


/* Buying RV with purchase order*/

/* Adds 5 new RV to Sales RV Table with status FORSALE */
/* Adds 5 new PO that reflects purchasing the RV just added from one of the vendors */
/* Updates 5 PO with the manager who approves the purchase */
INSERT INTO Sales_RV
VALUES(111111,1999,'A','Fleetwood','Mac','Motorhome','V8 Super Diesel', 80000, 'Decent', 'FORSALE',150000);

INSERT INTO Purchase_Order (Inv_Num,Sales_Date,Terms,VIN,Purchase_From,Sales_Ammount)
VALUES(1111, DATE '2021-07-31','Credit',111111,'Andys RV',90000);

UPDATE Purchase_Order
SET Approved = 1000
wHERE Inv_Num = 1111;



INSERT INTO Sales_RV
VALUES(222222,2021,'A','Winnebago','Horn','Motorhome','V8 Diesel', 0, 'New', 'FORSALE',150000);

INSERT INTO Purchase_Order (Inv_Num,Sales_Date,Terms,VIN,Purchase_From,Sales_Ammount)
VALUES(1112, DATE '2022-06-04','Credit',222222,'Andys RV',150000);

UPDATE Purchase_Order
SET Approved = 1000
wHERE Inv_Num = 1112;


INSERT INTO Sales_RV
VALUES(333333,2021,'A','SuperRv','Hero-1','Motorhome','V8 Ravager', 0, 'New', 'FORSALE',200000);

INSERT INTO Purchase_Order (Inv_Num,Sales_Date,Terms,VIN,Purchase_From,Sales_Ammount)
VALUES(1113, DATE '2022-06-03','Credit',333333,'Doug RV',200000);

UPDATE Purchase_Order
SET Approved = 1000
wHERE Inv_Num = 1113;


INSERT INTO Sales_RV
VALUES(444444,2006,'B','SuperRv','Hero Special','Motorhome','V8 Undertaker', 50000, 'Excelent', 'FORSALE',150000);

INSERT INTO Purchase_Order (Inv_Num,Sales_Date,Terms,VIN,Purchase_From,Sales_Ammount)
VALUES(1114, DATE '2022-05-23','Credit',444444,'Doug RV',100000);

UPDATE Purchase_Order
SET Approved = 1000
wHERE Inv_Num = 1114;


INSERT INTO Sales_RV
VALUES(555555,2010,'B','Winnebago','Treck-1','Motorhome','V8 SuperBeast', 40000, 'Excelent', 'FORSALE',20000);

INSERT INTO Purchase_Order (Inv_Num,Sales_Date,Terms,VIN,Purchase_From,Sales_Ammount)
VALUES(1115, DATE '2022-05-23','Credit',555555,'Doug RV',120000);

UPDATE Purchase_Order
SET Approved = 1008
wHERE Inv_Num = 1115;

/* Selling RVs*/

/* Creates sales invoice table with attributes and its appropriate data types */
/* Enforces table level entity integrity of not null constraints so defined attributes are required, and identifies invoice number as the primary key*/
/* Enforces table level referential integrity for appropriate foreign key constraints for vin, vin trade, customer id, salesperson, and approved attributes from other tables.*/
/* Enforces table level domain integrity to require sell price to be greater than trade allow, for both approved and approve date to be required or for both approved and approve date to not be required, for both vin trade and trade allow to be required or for both vin trade and trade allow to not be required, and default constraint for sales date. If no date is entered, current date is entered */

CREATE TABLE Sales_Inv (
    Inv_Num         NUMBER(4),
    Sales_Date      DATE            DEFAULT SYSDATE,
    Terms           VARCHAR2(10)    NOT NULL,
    Salesperson     NUMBER(4)       NOT NULL,
    Approved        NUMBER(4),
    Approve_Date    DATE,
    customer_id     NUMBER(4)       NOT NULL,
    VIN             NUMBER(6)       NOT NULL,
    VIN_Trade       NUMBER(6),
    Sell_Price      NUMBER(7)       NOT NULL,
    Misc_Cost       NUMBER(6),
    Percent_Off     NUMBER(2,2),
    Trade_Allow     NUMBER(7),
    CONSTRAINT sali_tcap_ck CHECK(Sell_price>Trade_Allow),
    CONSTRAINT sali_ap_ck   CHECK((Approved IS NOT NULL AND Approve_Date IS NOT NULL) OR (Approved IS NULL AND Approve_Date IS NULL)),
    CONSTRAINT sali_ta_ck   CHECK((VIN_Trade IS NOT NULL AND Trade_Allow IS NOT NULL) OR (VIN_Trade IS NULL AND Trade_Allow IS NULL)),
    CONSTRAINT sali_vin_fk  FOREIGN KEY(VIN) REFERENCES sales_rv(VIN),
    CONSTRAINT sali_vint_fk FOREIGN KEY(VIN_Trade) REFERENCES sales_rv(VIN),
    CONSTRAINT sali_cus_fk  FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    CONSTRAINT sali_sp_fk   FOREIGN KEY(Salesperson) REFERENCES employee(EMPLOYEE_ID),
    CONSTRAINT sali_pb_fk   FOREIGN KEY(Approved) REFERENCES employee(EMPLOYEE_ID),
    CONSTRAINT sali_inv_pk  PRIMARY KEY(Inv_Num)
);

/* SELLING RV with trade in (3)*/
/* Creates new rv for tradein*/
/* Creates Sales Invoice*/
/* Updates sales invoice for approval by Larry */
/* Updates status of vehicle sold to go from FORSALE to SOLD. */
/* Updates status of vehicle traded in from TRADEIN to FORSALE. */ 

INSERT INTO Sales_RV
VALUES(111112,2005,'C','SuperRv','Hero-2','Motorhome','superV', 75000, 'Mid', 'TRADEIN',130000);

INSERT INTO Sales_Inv (Inv_Num, Sales_Date, Terms, Salesperson, customer_id,VIN,VIN_Trade,Sell_Price,Trade_Allow)
VALUES(1111,DATE '2021-01-12', 'Credit',1009, 1,111111,111112,100000,70000 );

UPDATE Sales_Inv
SET Approved = 1000, Approve_Date = DATE '2021-01-13'
WHERE Inv_Num = 1111;

UPDATE Sales_Rv
SET RV_Status = 'SOLD'
WHERE VIN = 111111;

UPDATE Sales_Rv
SET RV_Status = 'FORSALE'
WHERE VIN = 111112;


INSERT INTO Sales_RV
VALUES(222223,2000,'B','RVMate','Buddy-2','Motorhome','v8 CHILL', 20000, 'Excelent', 'TRADEIN',100000);

INSERT INTO Sales_Inv (Inv_Num, Sales_Date, Terms, Salesperson, customer_id,VIN,VIN_Trade,Sell_Price,Trade_Allow)
VALUES(1112,DATE '2021-07-12', 'Credit',1009, 2,222222,222223,175000,50000 );

UPDATE Sales_Inv
SET Approved = 1000, Approve_Date = DATE '2021-07-13'
wHERE Inv_Num = 1112;

UPDATE Sales_Rv
SET RV_Status = 'SOLD'
WHERE VIN = 222222;

UPDATE Sales_Rv
SET RV_Status = 'FORSALE'
WHERE VIN = 222223;


INSERT INTO Sales_RV
VALUES(333334,2007,'B','BIGRV','TANK 3','Motorhome','V12 mega', 150000, 'OK', 'TRADEIN',150000);

INSERT INTO Sales_Inv (Inv_Num, Sales_Date, Terms, Salesperson, customer_id,VIN,VIN_Trade,Sell_Price,Trade_Allow)
VALUES(1113,DATE '2022-02-10', 'Credit',1009, 3,333333,333334,250000,100000 );

UPDATE Sales_Inv
SET Approved = 1000, Approve_Date = DATE '2022-02-12'
wHERE Inv_Num = 1113;

UPDATE Sales_Rv
SET RV_Status = 'SOLD'
WHERE VIN = 333333;

UPDATE Sales_Rv
SET RV_Status = 'FORSALE'
WHERE VIN = 333334;


/* RV SALE no Trade in (2)*/
/* Creates Sales Invoice*/
/* Updates sales invoice for approval by Larry */
/* Updates status of vehicle sold to go from FORSALE to SOLD. */

INSERT INTO Sales_Inv (Inv_Num, Sales_Date, Terms, Salesperson, customer_id,VIN,Sell_Price)
VALUES(1114,DATE '2022-4-04', 'Credit',1009, 4,444444,125000);

UPDATE Sales_Inv
SET Approved = 1000, Approve_Date = DATE '2022-04-07'
wHERE Inv_Num = 1114;

UPDATE Sales_Rv
SET RV_Status = 'SOLD'
WHERE VIN = 444444;


INSERT INTO Sales_Inv (Inv_Num, Sales_Date, Terms, Salesperson, customer_id,VIN,Sell_Price)
VALUES(1115,DATE '2022-05-05', 'Credit',1010, 5,555555,150000);

UPDATE Sales_Inv
SET Approved = 1008, Approve_Date = DATE '2022-04-07'
wHERE Inv_Num = 1115;

UPDATE Sales_Rv
SET RV_Status = 'SOLD'
WHERE VIN = 555555;

/* Inserting a customer buying one of the vehicles that was traded in */
/* Creates Sales Invoice*/
/* Updates sales invoice for approval by Larry */
/* Updates status of vehicle sold to go from FORSALE to SOLD. */


INSERT INTO Sales_Inv (Inv_Num, Sales_Date, Terms, Salesperson, customer_id,VIN,Sell_Price)
VALUES(1116,DATE '2022-06-05', 'Credit',1010, 1,111112,130000);

UPDATE Sales_Inv
SET Approved = 1008, Approve_Date = DATE '2022-06-05'
wHERE Inv_Num = 1116;

UPDATE Sales_Rv
SET RV_Status = 'SOLD'
WHERE VIN = 111112;

/* Creates service invoice table (assuming one part per service as per 'Service Invoice Video2.mp4') with attributes and its appropriate data types */
/* Enforces table level entity integrity of not null constraints so defined attributes are required, and identifies invoice number as the primary key*/
/* Enforces table level referential integrity for appropriate foreign key constraints for part, service code, service person, VIN, customer id attributes from other tables.*/
/* Enforces table level domain integrity to require either service code or part, and default constraint for service date. If no date is entered, current date is entered */

CREATE TABLE Serv_inv (
    Inv_Num         NUMBER(4),
    Service_Date    DATE            DEFAULT SYSDATE,
    Terms           VARCHAR2(10)    NOT NULL,
    customer_id     NUMBER(4)       NOT NULL,
    VIN             NUMBER(6)       NOT NULL,
    Service_person  NUMBER(4)       NOT NULL,
    Mileage         NUMBER(7)       NOT NULL,
    Service_code    VARCHAR2(20),
    Part            VARCHAr2(30),
    Misc_Charge     NUMBER(3),
    CONSTRAINT seri_ps_chk   CHECK(Service_code IS NOT NULL OR Part IS NOT NULL),
    CONSTRAINT seri_pt_fk    FOREIGN KEY(part) REFERENCES part(part_code),    
    CONSTRAINT seri_ser_fk   FOREIGN KEY(service_code) REFERENCES servicev(SERVICE_CODE),
    CONSTRAINT seri_per_fk   FOREIGN KEY(Service_person) REFERENCES employee(employee_id),
    CONSTRAINT seri_vin_fk   FOREIGN KEY(VIN) REFERENCES Service_Vehicle(VIN),
    CONSTRAINT seri_cus_fk   FOREIGN KEY(customer_id) REFERENCES customer(customer_id),
    CONSTRAINT seri_inv_pk   PRIMARY KEY(Inv_Num)
);

/* Servicing Cars*/


/*returning service 1*/
/*New customer inserted*/
/*New vehicle inserted*/
/*New service invoice created*/

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000011, 'Andy', 'Alberts', '1101101101', 'aalberts@gmail.com', '110 Andy Drive', 'Alter', 'CA', '11011');

INSERT INTO Service_Vehicle
VALUES (110110,'2015','Winnebago','Bubble',60000);

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code)
VALUES (1111, DATE '2021-09-22', 'Credit', 000011, 110110, 1005,60000, 'TIREROTATE');

/* second tirerotate service after 6000 miles*/

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code)
VALUES (1112, DATE '2022-05-12', 'Credit', 000011, 110110, 1005,90000, 'TIREROTATE');

/*Updating mileage because vehicle was serviced twice*/

UPDATE Service_Vehicle
SET Mileage = 90000
WHERE VIN = 110110;


/*returning service 2*/
/*New customer inserted*/
/*New vehicle inserted*/
/*New service invoice created*/

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000012, 'Bert', 'Bats', '1201201201', 'bber@gmail.com', '120 BBB Drive', 'Brace', 'CA', '12012');

INSERT INTO Service_Vehicle
VALUES (120120,'2015','Winnebago','Frontier',70000);

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code)
VALUES (1113, DATE '2021-08-21', 'Credit', 000012, 120120, 1005,70000, 'TIREROTATE');

/* second tirerotate service after 6000 miles*/

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code,part)
VALUES (1114, DATE '2022-04-12', 'Credit', 000012, 120120, 1005,85000, 'TIREROTATE', 'AIRFILTER');

/*Updating mileage because vehicle was serviced twice*/

UPDATE Service_Vehicle
SET Mileage = 85000
WHERE VIN = 120120;

/* oil change*/
/*New customer inserted*/
/*New vehicle inserted*/
/*New service invoice created*/

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000013, 'Callie', 'Carts', '1301301301', 'ccaer@gmail.com', '130 CCC Drive', 'Crate', 'CA', '13013');

INSERT INTO Service_Vehicle
VALUES (130130,'2015','Winnebago','Galloper',25000);

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code, part)
VALUES (1115, DATE '2021-10-03', 'Credit', 000013, 130130, 1006,25000, 'OILCHG', 'OILFILTER');

/* oil change 2 (Start of cars sold by us)*/
/*Sold Vehicle added to service vehicles*/
/*New service invoice created*/

INSERT INTO Service_Vehicle
SELECT VIN, yr, RV_Make, RV_Model, Milage
FROM Sales_rv
WHERE VIN = 111111;

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code, part)
VALUES (1116, DATE '2021-10-03', 'Credit', 000001, 111111, 1006,95000, 'OILCHG', 'OILFILTER');

/*Sold Vehicle added to service vehicles*/
/*New service invoice created*/

INSERT INTO Service_Vehicle
SELECT VIN, yr, RV_Make, RV_Model, Milage

FROM Sales_rv
WHERE VIN = 222222;

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, part)
VALUES (1117, DATE '2021-07-23', 'Credit', 000002, 222222, 1006,160000, 'SPARKPLUG4');

/*Sold Vehicle added to service vehicles*/
/*New service invoice created*/

INSERT INTO Service_Vehicle
SELECT VIN, yr, RV_Make, RV_Model, Milage
FROM Sales_rv
WHERE VIN = 333333;

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, part)
VALUES (1118, DATE '2021-08-20', 'Credit', 000003, 333333, 1005,10000, 'WINSHIELDFLUID');

/*Sold Vehicle added to service vehicles*/
/*New service invoice created*/

INSERT INTO Service_Vehicle
SELECT VIN, yr, RV_Make, RV_Model, Milage
FROM Sales_rv
WHERE VIN = 444444;

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code, part)
VALUES (1119, DATE '2022-02-03', 'Credit', 000004, 444444, 1005,75000, 'SMGCHCK', 'WINSHIELDFLUID');

/*Sold Vehicle added to service vehicles*/
/*New service invoice created*/

INSERT INTO Service_Vehicle
SELECT VIN, yr, RV_Make, RV_Model, Milage
FROM Sales_rv
WHERE VIN = 555555;

INSERT INTO Serv_inv (Inv_Num, Service_Date, Terms, Customer_id, VIN, service_person,Mileage, service_code, part)
VALUES (1120, DATE '2022-01-03', 'Credit', 000005, 555555, 1005,70000, 'SMGCHCK', 'SPARKPLUG4');


/*Creating Views*/

/*Vendor List*/

CREATE VIEW Vendor_List
 AS  SELECT Company_Name,Contact_Name,Street,City,Statev,Zip,Phone,Fax
 FROM  Vendor
 ORDER BY company_name asc;

/*RV Sales List*/

CREATE VIEW RV_SALES_LIST
AS  SELECT  s.Inv_Num "Invoice Number", e.first_name||' '||e.last_name "Salesperson", m.first_name||' '||m.last_name "Approving Manager",
 s.vin "VIN", r.rv_make "Make", r.rv_model "Model", r.rv_class "Class", s.VIN_Trade "Trade-in VIN", t.rv_make "Trade-in Make", 
 t.rv_model "Trade-in Model", s.Sell_Price "Selling Price",s.Percent_Off "Discount", s.Trade_Allow "Trade-in Value",
 s.Misc_Cost "Misc Costs", 
 s.Sell_Price - s.Sell_Price*NVL(s.Percent_Off,0) + NVL(s.Misc_Cost,0) - NVL(s.Trade_Allow,0) "Subtotal",
 (s.Sell_Price - s.Sell_Price*NVL(s.Percent_Off,0) + NVL(s.Misc_Cost,0) - NVL(s.Trade_Allow,0))*0.0825 "Tax",
 s.Sell_Price - s.Sell_Price*NVL(s.Percent_Off,0) + NVL(s.Misc_Cost,0) - NVL(s.Trade_Allow,0) + 
 (s.Sell_Price - s.Sell_Price*NVL(s.Percent_Off,0) + NVL(s.Misc_Cost,0) - NVL(s.Trade_Allow,0))*0.0825 "Total Selling Price"
 FROM Sales_Inv s
 LEFT JOIN employee e
 ON (s.Salesperson = e.employee_id)
 LEFT JOIN sales_rv r
 ON (s.vin = r.vin)
 LEFT JOIN employee m
 ON (s.Approved = m.employee_id)
 LEFT JOIN sales_rv t
 ON (s.VIN_Trade = t.vin)
 ORDER BY s.Inv_Num;

/*RV Purchase List*/

CREATE VIEW RV_PURCHASE_LIST
AS SELECT   p.Inv_Num "Purchase Order Number", p.Purchase_From "Company Name", v.Contact_Name "Contact Name", 
 p.VIN, r.rv_make "Make", r.rv_model "Model", r.rv_class "Class", m.first_name||' '||m.last_name "Manager",
 p.Sales_Ammount "Sale Ammount", p.Shipping, p.Sales_Ammount+NVL(p.Shipping,0) "Subtotal",
 (p.Sales_Ammount+NVL(p.Shipping,0))*0.0825 "Taxes",
 (p.Sales_Ammount+NVL(p.Shipping,0))*0.0825 +p.Sales_Ammount+NVL(p.Shipping,0) "Total Price"
 FROM Purchase_Order p
 LEFT JOIN vendor v
 ON (p.Purchase_From = v.Company_Name)
 LEFT JOIN sales_rv r
 ON (p.vin = r.vin)
 LEFT JOIN employee m
 ON (p.Approved = m.employee_id)
 ORDER BY p.Inv_Num;

/*Service Invoice List*/

CREATE VIEW Service_Invoice_List
AS SELECT   si.Inv_Num "Invoice Number", cu.first_name||' '||cu.last_name "Customer Name", si.VIN "VIN", 
 sv.RV_Make "Make", sv.RV_Model "Model", si.Mileage "Mileage", sv.price "Total Service Charge", 
 pt.price "Total Parts Charge", si.Misc_Charge "Misc Charge",
 NVL(pt.price,0)+NVL(sv.price,0)+NVL(si.Misc_Charge,0) "Subtotal",
 (NVL(pt.price,0)+NVL(sv.price,0)+NVL(si.Misc_Charge,0))*0.0825 "Tax",
 NVL(pt.price,0)+NVL(sv.price,0)+NVL(si.Misc_Charge,0) + 
 (NVL(pt.price,0)+NVL(sv.price,0)+NVL(si.Misc_Charge,0))*0.0825 "Total Charges"
 FROM Serv_inv si
 LEFT JOIN Service_Vehicle sv
 ON (si.vin = sv.vin)
 LEFT JOIN customer cu
 ON (si.customer_id = cu.customer_id)
 LEFT JOIN servicev sv
 ON (si.Service_code = sv.Service_code)
 LEFT JOIN part pt
 ON (si.Part = pt.part_code)
 ORDER BY si.Inv_Num;
