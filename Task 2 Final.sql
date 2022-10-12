/* Evan Pomeroy, Miyu Nishii, Ty Williams BUS393-02 */


/* Dropping New elements */
DROP TABLE employee CASCADE CONSTRAINTS PURGE;
DROP VIEW EMP_CONTACT_LIST;
DROP VIEW EMP_REPORT_LIST;
DROP VIEW EMP_REPORT_LIST_SIMPLE;

/* Creating employee table including attributes with domain integrity */
CREATE TABLE employee (
    Employee_ID     NUMBER(4),
    First_Name      VARCHAR2(15)    NOT NULL,
    Last_Name       VARCHAR2(15)    NOT NULL,
    Street          VARCHAR2(20)    NOT NULL,
    City            VARCHAR2(20)    NOT NULL,
    StateV          CHAR(2)         DEFAULT 'CA'    NOT NULL,
    Zip             CHAR(5)         NOT NULL,
    Phone           VARCHAR2(12)    NOT NULL,
    Email           VARCHAR2(30)    NOT NULL,
    Hire_date       DATE            NOT NULL,
    Title           VARCHAR2(30)    NOT NULL,
    Salary          VARCHAR2(8),
    Comission_pct   VARCHAR2(2),
    Supervisor_ID   NUMBER(4),
    CONSTRAINT emp_id_pk            PRIMARY KEY(Employee_ID),
    CONSTRAINT emp_salecommis_chk   CHECK((Title LIKE '%Sales%' AND Comission_pct IS NOT NULL) OR (Title NOT LIKE '%Sales%' AND Comission_pct IS NULL)),
    CONSTRAINT emp_sal_check        CHECK(Salary IS NOT NULL OR Title LIKE '%Intern%'),
    CONSTRAINT emp_comis_range      CHECK((Comission_pct IS NULL) OR (Comission_pct<=30 and Comission_pct>=20)),
    CONSTRAINT emp_sid_fk           FOREIGN KEY (Supervisor_ID) REFERENCES employee(Employee_ID),
    CONSTRAINT emp_sup_notself      CHECK (Employee_ID <> Supervisor_ID),
    CONSTRAINT emp_phone_uk         UNIQUE(Phone),
    CONSTRAINT emp_email_uk         UNIQUE(Email)
);

/* Inserting data into tables*/
INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1000, 'Larry', 'Daly', '111 Abe Drive', 'Pismo Beach', DEFAULT, '93448', '1212121212', 'larydaly@gmail.com', DATE '2015-03-04', 'Owner', '150000', NULL, NULL);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1001, 'George', 'Cruise', '222 Bane Drive', 'Arroyo Grande', 'CA', '93420', '1212121213', 'georgecruise@gmail.com', DATE '2017-05-03', 'CPA', '120000', NULL, 1000);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1002, 'ALex', 'McManus', '333 Cal Drive', 'Morro Bay', 'CA', '93442', '1212121214', 'alexmcmanus@gmail.com', DATE '2019-07-16',  'Maintenance', '40000', NULL, 1001);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1003, 'Kathy', 'Smith', '444 Dawn Drive', 'Pismo Beach', DEFAULT, '93448', '1212121215', 'kathysmith@gmail.com', DATE '2019-08-11',  'AR/AP Clerk', '35000', NULL, 1001);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1004, 'Alex', 'Roosdale', '555 Eagle Drive', 'Arroyo Grande', DEFAULT, '93420', '1212121216', 'alexroosdale@gmail.com', DATE '2015-03-22', 'Parts and Service Manager', '100000', NULL, 1000);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1005, 'Alan', 'Alfred', '666 Fall Drive', 'Pismo Beach', 'CA', '93448', '1212121217', 'alanalfred@gmail.com', DATE '2020-11-29', 'Mechanic', '60000', NULL, 1004);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1006, 'Juan', 'Garcia', '777 Great Drive', 'Morro Bay', 'CA', '93442', '1212121218', 'juangarcia@gmail.com', DATE '2021-06-10', 'Mechanic', '52000', NULL, 1004);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1007, 'Sharon', 'Jones', '888 Higuera Drive', 'San Luis Obispo', DEFAULT, '93401', '1212121219', 'sharonjones@gmail.com', DATE '2022-01-24', 'Cal Poly Intern', NULL, NULL, 1006);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1008, 'Mary', 'McMaster', '999 Ice Drive', 'Pismo Beach', 'CA', '93448', '1212121222', 'marymcmaster@gmail.com', DATE '2018-09-17', 'Sales Manager', '110000', '25', 1000);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1009, 'Allen', 'Foster', '1010 Jane Drive', 'Arroyo Grande', DEFAULT, '93420', '1212121223', 'allenfoster@gmail.com', DATE '2019-08-17', 'Sales Associate', '90000', '21', 1008);

INSERT INTO employee (Employee_ID, First_Name, Last_Name, Street, City, StateV, Zip, Phone, Email, Hire_date, Title, Salary, Comission_pct, Supervisor_ID)
VALUES (1010, 'Brenda', 'St. James', '1212 King Drive', 'San Luis Obispo', 'CA', '93401', '1212121224', 'brendastjames@gmail.com', DATE '2020-01-01', 'Sales Associate', '85000', '23', 1008);


/* Tests work */

/* VIEWS*/

CREATE VIEW EMP_CONTACT_LIST
 AS SELECT First_Name, Last_Name, Phone, Email
 FROM employee;
 
SELECT * 
FROM EMP_CONTACT_LIST
ORDER BY Last_name;


CREATE VIEW EMP_REPORT_LIST
 AS SELECT m.First_Name||' '||m.Last_name "Manager", m.title "Manager Title",
    e.First_name||' '||e.Last_name "Reportee", e.title "Title Reportee"
 FROM employee m
 JOIN employee e
 ON (e.Supervisor_ID = m.employee_id)
 ORDER BY m.last_name, e.last_name;

SELECT * 
FROM EMP_REPORT_LIST;


/*Easier to read basic employee reporting list*/

CREATE VIEW EMP_REPORT_LIST_SIMPLE
 AS SELECT m.First_Name||' '||m.Last_name "Manager", 
    LISTAGG(e.First_name||' '||e.Last_name, ', ') "Employee"
 FROM employee m
 JOIN employee e
 ON (e.Supervisor_ID = m.employee_id)
 GROUP BY m.first_name||' '||m.Last_name;
