/* Evan Pomeroy, Miyu Nishii, Ty Williams BUS393-02 */

/*Drops tables sales RV and RV service from the database*/
/* Drops views vehicle list, vehicle list for sale, vehicle list sold, vehicle inventory value, vehicle inventory value by make*/
DROP TABLE Sales_RV CASCADE CONSTRAINTS PURGE;
DROP TABLE Service_Vehicle CASCADE CONSTRAINTS PURGE;
DROP VIEW Vehicle_List;
DROP VIEW Vehicle_List_For_Sale;
DROP VIEW Vehicle_List_Sold;
DROP VIEW Vehice_Inv_Value;
DROP VIEW Vehice_Inv_Value_Make;



/* Creates Sales RV table w/ VIN, year, class, make, model, style/body, engine, mileage, condition, status, purchase price, list price attributes according to their data types*/
/* Enforces entity integrity at the table level for primary key of vin which automatically requires it and not null for the rest of the attributes*/
/* Enforces domain integrity at the table level to require rv status to be for sale, trade in, or sold, mileage to be greater than or equal to zero, and sale year to be after 1927*/

CREATE TABLE Sales_RV    (
    VIN             NUMBER(6)       NOT NULL,
    yr              NUMBER(4)       NOT NULL,
    RV_Class        VARCHAR2(15)     NOT NULL,
    RV_Make         VARCHAR2(15)     NOT NULL,
    RV_Model        VARCHAR2(15)     NOT NULL,
    style_body      VARCHAR2(15)     NOT NULL,
    engine          VARCHAR2(15)     NOT NULL,
    Milage          VARCHAR2(7)      NOT NULL,
    RV_Condition    VARCHAR2(15)     NOT NULL,
    RV_Status       VARCHAR2(15)     NOT NULL,
    List_price      VARCHAR2(7)      NOT NULL,
    CONSTRAINT sale_aq_type     CHECK(RV_Status in ('FORSALE','TRADEIN', 'SOLD')),
    CONSTRAINT sale_mile_pos    CHECK(Milage>=0),
    CONSTRAINT sale_yr_poss     CHECK(yr>1927),
    CONSTRAINT sale_vin_pk      PRIMARY KEY(VIN)
);

/* Creates service vehicle table with attributes and its appropriate data types */
/* Enforces table level entity integrity of not null constraints so defined attributes are required, and identifies vin number as the primary key*/
/* Using VIN as pk because mileage will be updated after every service*/
CREATE TABLE Service_Vehicle    (
    VIN             NUMBER(6),
    yr              NUMBER(4)       NOT NULL,
    RV_Make         VARCHAR2(15)    NOT NULL,
    RV_Model        VARCHAR2(15)    NOT NULL,
    Mileage         NUMBER(7),
    CONSTRAINT srv_vin_pk PRIMARY KEY(VIN)
);

/* Creates view statements to test work */
/*4A*/
CREATE VIEW Vehicle_List
 AS SELECT VIN, yr, RV_Make, RV_Model, style_body, engine, Milage, RV_Condition, RV_Status, List_price
 FROM Sales_RV
 ORDER BY RV_Make, RV_Model;

/*4B*/
CREATE VIEW Vehicle_List_For_Sale
 AS SELECT VIN, yr, RV_Make, RV_Model, style_body, engine, Milage, RV_Condition, RV_Status, List_price
 FROM Sales_RV
 WHERE RV_Status = 'FORSALE'
 ORDER BY RV_Make, RV_Model;

/*4C*/
CREATE VIEW Vehicle_List_Sold
 AS SELECT VIN, yr, RV_Make, RV_Model, style_body, engine, Milage, RV_Condition, RV_Status, List_price
 FROM Sales_RV
 WHERE RV_Status = 'SOLD'
 ORDER BY RV_Make, RV_Model;

/*4D*/
CREATE VIEW Vehice_Inv_Value
 AS SELECT SUM(List_price) "Total Value"
 FROM Sales_Rv
 WHERE RV_Status = 'FORSALE' OR RV_Status = 'TRADEIN';

/*4E*/
CREATE VIEW Vehice_Inv_Value_Make
 AS SELECT RV_Make, SUM(List_price) "Total Value"
 FROM Sales_Rv
 WHERE RV_Status = 'FORSALE' OR RV_Status = 'TRADEIN'
 GROUP BY RV_Make
 ORDER BY RV_Make

