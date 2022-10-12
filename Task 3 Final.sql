/* Evan Pomeroy, Miyu Nishii, Ty Williams BUS393-02 */

/*Dropping Tables*/
DROP TABLE serviceV CASCADE CONSTRAINTS PURGE;
DROP TABLE part CASCADE CONSTRAINTS PURGE;
DROP VIEW Service_List;
DROP VIEW Part_List;

/*Creating table for services*/
CREATE TABLE serviceV (
    Service_code    VARCHAR2(20),
    DescriptionV    VARCHAR2(30)   NOT NULL,
    CostV           NUMBER(6,2)    NOT NULL,
    Price           NUMBER(6,2)    NOT NULL,
    MonthsV         NUMBER(2),
    Mileage         NUMBER(6),
    CONSTRAINT ser_co_pk PRIMARY KEY(Service_code)
);


/*Inserting instances into the service table*/

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('OILCHG', 'Oil Change', 30.95, 99.95, 6, 6000);

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('TIREROTATE', 'Tire Rotation', 9.95, 36.95, 12, 12000);

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('FLUIDS', 'Fluid Replacement', 29.96, 59.95, 30, 30000);

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('TUNEUPBASIC', 'Basic engine tune up', 109.95, 169.95, 18, 18000);

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('MULTIPOINTINSP', 'Multi-Point Inspection', 79.95, 129.95, 6, 6000);

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('SMGCHCK', 'Sog Check', 2.94, 49.95, 1, 90000);

INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('WNDWTNT', 'Window Tint', 40.22, 149.95, 5, 50500);
  
INSERT INTO serviceV (Service_code, DescriptionV, CostV, Price, MonthsV, Mileage) 
VALUES ('DNTRMV', 'Dent Remove', 5.34, 49.95, 2, 54000);


/*Creating table for parts*/
CREATE TABLE part (
    Part_code       VARCHAR2(30),
    DescriptionV    VARCHAR2(30)   NOT NULL,
    CostV           NUMBER(6,2)    NOT NULL,
    Price           NUMBER(6,2)    NOT NULL,
    CONSTRAINT par_co_pk PRIMARY KEY(Part_code)
);

/*Inserting instances into the parts table*/
INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('OIL10W30', 'Oil 10W30', 2.79, 5.95);

INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('OILFILTER', 'Oil Filter', 6.95, 21.95);

INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('WINSHIELDFLUID', 'Windshield fluid', 2.96, 4.95);

INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('SPARKPLUG4', 'Spark Plug Set(8)', 29.95, 49.95);

INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('AIRFILTER', 'Air Filter', 13.95, 28.95);
   
INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('RERVIEW1', 'Interior Rear View Mirror', 10.93, 19.95);

INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('RERVIEWL', 'Left Rear View Mirror', 10.95, 22.95);

INSERT INTO part (Part_code, DescriptionV, CostV, Price)
VALUES ('RERVIEWR', 'Right Rear View Mirror', 10.95, 22.95);


/*Creating View Statements to test work*/

CREATE VIEW Service_list
 AS SELECT Service_code, DescriptionV, CostV, Price, MonthsV, Mileage
 FROM serviceV
 ORDER BY Service_code;

CREATE VIEW Part_List
 AS SELECT Part_code, DescriptionV, CostV, Price
 FROM part
 ORDER BY Part_code;

