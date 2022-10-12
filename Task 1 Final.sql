/* Evan Pomeroy, Miyu Nishii, Ty Williams BUS393-02 */

DROP TABLE customer CASCADE CONSTRAINTS PURGE;
DROP TABLE preference CASCADE CONSTRAINTS PURGE;
DROP VIEW preferences;
DROP VIEW customers;
DROP VIEW customers_and_preferences;


/* Creating customer table */

CREATE TABLE customer (
    Customer_ID     NUMBER(6),
    First_Name      VARCHAR2(15)    NOT NULL,
    Last_Name       VARCHAR2(15)    NOT NULL,
    Phone           VARCHAR2(12)    NOT NULL,
    Email           VARCHAR2(30)    NOT NULL,
    Street          VARCHAR2(20)    NOT NULL,
    City            VARCHAR2(10)    NOT NULL,
    StateV          CHAR(2)         DEFAULT 'CA'    NOT NULL,
    Zip             CHAR(5)         NOT NULL,
    CONSTRAINT cu_id_pri    PRIMARY KEY(Customer_ID),
    CONSTRAINT cus_ph_uk    UNIQUE(Phone),
    CONSTRAINT cus_ema_uk   UNIQUE(Email)
);


/* 10 customer entries */

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000001, 'Abby', 'Anderson', '1111111111', 'abbyanderson@gmail.com', '111 Andy Drive', 'Albert', 'AL', '11111');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000002, 'Betty', 'Batson', '2222222222', 'bettybatson@gmail.com', '222 Ben Drive', 'Ball', 'TX', '22222');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000003, 'Carly', 'Cameron', '3333333333', 'varlycameron@gmail.com', '333 Cab Drive', 'Cart', 'CT', '33333');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000004, 'Dale', 'Drakeson', '4444444444', 'daledrakeson@gmail.com', '444 Dirt Drive', 'Drop', 'DE', '44444');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, StateV, Zip)
VALUES (000005, 'Erik', 'Evans', '5555555555', 'erikevans@gmail.com', '555 Ebony Drive', 'Elk', 'WA', '55555');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, Zip)
VALUES (000006, 'Frank', 'Fetch', '6666666666', 'frankfetch@gmail.com', '666 Feet Drive', 'Flip', '66666');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, Zip)
VALUES (000007, 'Gerry', 'Great', '7777777777', 'gerrygreat@gmail.com', '777 Goop Drive', 'Grape', '77777');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, Zip)
VALUES (000008, 'Hank', 'Hill', '8888888888', 'hankhill@gmail.com', '888 Horse Drive', 'Hart', '88888');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, Zip)
VALUES (000009, 'Ike', 'Ink', '9999999999', 'ikeink@gmail.com', '999 Int Drive', 'Isle', '99999');

INSERT INTO customer (Customer_ID, First_Name, Last_Name, Phone, Email, Street, City, Zip)
VALUES (000010, 'Jake', 'Jerk', '1010101010', 'jakejerk@gmail.com', '1010 Jack Drive', 'Joke', '10101');


/* Creating preference table */

CREATE TABLE preference (
    Customer_ID     NUMBER(6)       NOT NULL,
    RV_Class        CHAR(1),
    RV_Make         VARCHAR2 (14),
    RV_Model        VARCHAR2 (15),
    Max_Price       INT             NOT NULL,
    Start_Date      DATE            DEFAULT SYSDATE,
    End_Date        DATE,
    CONSTRAINT pre_cus_pk   PRIMARY KEY(Customer_ID, Max_Price),
    CONSTRAINT pre_end_ck   CHECK(End_Date>Start_Date),
    CONSTRAINT pre_cuID_fk  FOREIGN KEY(Customer_ID) REFERENCES customer(Customer_ID),
    CONSTRAINT pre_max_ck   CHECK(Max_Price>0),
    CONSTRAINT pre_class_ck CHECK(RV_Class IN ('A','B','C'))
);


/* Preference entries */

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price)
VALUES (000001, 'B', 'Winnebago', 70000);

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price)
VALUES (000001, 'B', 'Fleetwood', 100000);

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price)
VALUES (000001, 'B', 'Roadtek', 65000);

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price, Start_Date)
VALUES (000002, 'A', 'Airstream', 80000, DATE '2015-12-17');

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price, Start_Date)
VALUES (000002, 'A', 'Roadtek', 85000, DATE '2017-10-01');

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price, Start_Date)
VALUES (000003, 'C', 'Roadtek', 60000, DATE '2022-05-20');

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price, Start_Date)
VALUES (000004, 'C', 'Fleetwood', 75000, DATE '2018-12-11');

INSERT INTO preference (Customer_ID, RV_Class, RV_Make, Max_Price, Start_Date, End_Date)
VALUES (000005, 'C', 'Winnebago', 72000, DATE '2013-03-04', DATE '2019-10-07');



CREATE VIEW customers
 AS SELECT First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email
 FROM customer
 ORDER BY Last_Name;

CREATE VIEW preferences
 AS SELECT customer.First_Name, customer.Last_Name, preference.RV_Make, preference.RV_Model, preference.Max_Price, preference.Start_Date, preference.End_Date
 FROM preference
 LEFT JOIN customer
 ON preference.Customer_ID = customer.Customer_ID;

CREATE VIEW customers_and_preferences
 AS SELECT customer.First_Name, customer.Last_Name, customer.Phone, coalesce(RV_Make, 'No Preference') AS RV_Make, preference.RV_Model, preference.RV_Class, preference.Start_Date, preference.End_Date
 FROM customer
 LEFT JOIN preference
 ON customer.Customer_ID = preference.Customer_ID;