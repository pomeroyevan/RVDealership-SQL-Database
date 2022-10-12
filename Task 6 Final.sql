/* Evan Pomeroy, Miyu Nishii, Ty Williams BUS393-02 */
DROP VIEW Customers_purchased;
DROP VIEW Customer_Cities;
DROP VIEW Customer_no_Service;
DROP VIEW Customer_Roadtek;
DROP VIEW Purchase_no_Tradein;
DROP VIEW Most_Purchases;
DROP VIEW Most_Profit;

DROP VIEW Sold_in_Month;
DROP VIEW Popular_make;
DROP VIEW Total_Profit;
DROP VIEW Highest_Commission;
DROP VIEW Most_Sales;
DROP VIEW Need_Oil;

DROP VIEW Services_Profit;

/*Customer Reports*/

/*List of customers who have purchased an RV from us*/

CREATE VIEW Customers_purchased
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name", cu.phone "Phone Number"
 FROM customer cu
 JOIN sales_inv si
 ON (cu.customer_id = si.customer_id)
 GROUP BY cu.first_name,cu.last_name,cu.phone;

/*Number of customers grouped by city*/

CREATE VIEW Customer_Cities
AS SELECT   City, count(*) "Number of Customers"
 FROM customer
 GROUP BY city;

/*List of customers who have purchased an RV from us but have not had a car serviced with us*/

CREATE VIEW Customer_no_Service
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name", cu.phone "Phone Number"
 FROM customer cu
 JOIN sales_inv si
 ON (cu.customer_id = si.customer_id)
 LEFT JOIN Serv_inv si
 ON (cu.customer_id = si.customer_id)
 WHERE si.vin NOT IN (
    SELECT vin
    FROM Serv_inv)
 GROUP BY cu.first_name,cu.last_name,cu.phone;

/*List of all customers who are interested in a Roadtek*/

CREATE VIEW Customer_Roadtek
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name", cu.phone "Phone Number", p.end_date "End Date"
 FROM preference p
 LEFT JOIN customer cu
 ON (p.customer_id = cu.customer_id)
 WHERE p.rv_make = 'Roadtek' and (p.end_date IS NULL or p.end_date > SYSDATE);

/*List of customers who bought an RV from us and did not bring in a trade in.*/

CREATE VIEW Purchase_no_Tradein
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name"
 FROM sales_inv s
 LEFT JOIN customer cu
 ON (s.customer_id=cu.customer_id)
 WHERE s.VIN_Trade IS NULL
 GROUP BY cu.first_name,cu.last_name;

/*The customer with the highest number of RV’s purchased*/

CREATE VIEW Most_Purchases
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name", count(si.Inv_Num) "RVs Purchased"
 FROM sales_inv si
 JOIN customer cu
 ON (cu.customer_id = si.customer_id)
 GROUP BY cu.first_name,cu.last_name
 ORDER BY count(si.Inv_Num) desc
 FETCH FIRST 1 ROWS WITH TIES;

/* The customer we made the highest toal profit from*/

CREATE VIEW Most_Profit
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name", SUM(si.Sell_Price - si.Sell_Price*NVL(si.Percent_Off,0)) "Total Profit"
 FROM sales_inv si
 JOIN customer cu
 ON (cu.customer_id = si.customer_id)
 GROUP BY cu.first_name,cu.last_name
 ORDER BY SUM(si.Sell_Price - si.Sell_Price*NVL(si.Percent_Off,0)) desc
 FETCH FIRST 1 ROWS WITH TIES;


/*Sales Reports*/

/*List of RVs sold by us in the past 30 days*/

CREATE VIEW Sold_in_Month
AS SELECT   si.VIN "VIN", r.RV_MAKE "Make", r.rv_model "Model", r.list_price "List Price"
 FROM sales_inv si
 LEFT JOIN sales_rv r
 ON (si.vin = r.vin)
 WHERE si.SALES_DATE > SYSDATE-30;

/*Most popular make of RV sold */

CREATE VIEW Popular_make
AS SELECT   r.RV_MAKE "Make", COUNT(si.Inv_Num) "# Purchased"
 FROM sales_inv si
 LEFT JOIN sales_rv r
 ON (si.vin = r.vin)
 GROUP BY r.RV_MAKE
 ORDER BY COUNT(si.Inv_Num) desc;

/*Sum of the total profit from RV sales*/

CREATE VIEW Total_Profit
AS SELECT   SUM((si.Sell_Price - si.Sell_Price*NVL(si.Percent_Off,0)) 
 - NVL(t.TRADE_ALLOW,0) - NVL(p.SALES_AMMOUNT,0)) "Total Profit"
 FROM sales_inv si
 LEFT JOIN Purchase_Order p
 ON (si.vin = p.vin)
 LEFT JOIN sales_inv t
 ON (si.vin = t.VIN_TRADE);

/*Salespeople ranked by total comission*/

CREATE VIEW Highest_Commission
AS SELECT   e.first_name||' '||e.last_name "Employee Name", SUM((e.COMISSION_PCT/100)*
 ((si.Sell_Price - si.Sell_Price*NVL(si.Percent_Off,0)) 
 - NVL(t.TRADE_ALLOW,0) - NVL(p.SALES_AMMOUNT,0))) "Total Commission"
 FROM sales_inv si
 LEFT JOIN employee e
 ON (e.employee_id = si.SALESPERSON)
 LEFT JOIN Purchase_Order p
 ON (si.vin = p.vin)
 LEFT JOIN sales_inv t
 ON (si.vin = t.VIN_TRADE)
 GROUP BY e.first_name,e.last_name;

/*Salespeople ranked number of RVs sold*/

CREATE VIEW Most_Sales
AS SELECT   e.first_name||' '||e.last_name "Employee Name", count(si.Inv_Num) "RVs Sold"
 FROM sales_inv si
 JOIN employee e
 ON (e.employee_id = si.Salesperson)
 GROUP BY e.first_name,e.last_name
 ORDER BY count(si.Inv_Num) desc;


/*Service Report*/

/*Sum of profits by service code*/

CREATE VIEW Services_Profit
AS SELECT   sv.service_code, sv.DESCRIPTIONV, SUM(sv.price-sv.costv) "Profit"
 FROM serv_inv si
 JOIN servicev sv
 ON (sv.service_code=si.service_code)
 GROUP BY sv.service_code, sv.DESCRIPTIONV
 ORDER BY SUM(sv.price-sv.costv) desc;

/*List of vehicles that need an oil change based on date*/

CREATE VIEW Need_Oil
AS SELECT   cu.first_name||' '||cu.last_name "Customer Name", cu.phone "Phone", 
 si.vin "VIN", sv.rv_make "Make"
 FROM serv_inv si
 LEFT JOIN customer cu
 ON (si.customer_id = cu.customer_id)
 LEFT JOIN service_vehicle sv
 ON (si.vin = sv.vin)
 WHERE si.SERVICE_CODE = 'OILCHG' AND si.SERVICE_DATE < SYSDATE-183
 AND si.vin NOT IN (
    SELECT vin
    FROM serv_inv
    WHERE si.SERVICE_CODE = 'OILCHG' 
    AND si.SERVICE_DATE > SYSDATE-183);