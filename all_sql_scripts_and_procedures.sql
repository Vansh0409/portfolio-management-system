/*
procedure get_holdings
This procedure takes a single input parameter, userId, which is used in the WHERE clause to filter the results based on the specified user ID. The SELECT statement retrieves the specified columns from the holdings table, joined with the investment_instruments table using the NATURAL JOIN syntax.


procedure update_holding
the input parameters it expects (in_holdingsID, in_userID, in_year, in_month, in_investID, in_quantity, and in_expr), which correspond to the values being updated and the filter condition in the UPDATE statement.
the UPDATE statement is executed with the input parameters used to set the new values and filter the rows to be updated.

procedure insert_holding
the input parameters it expects (in_userID, in_year, in_month, in_investID, and in_quantity), which correspond to the values being inserted into the holdings table.
the INSERT INTO statement is executed with the input parameters used to set the new values for the columns userID, year, month, investID, and quantity.
*/
-- 1.	Create the investments table with columns for investment ID, name, type, and number of shares held.
CREATE TABLE `holdings` (
  `holdingsID` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `year` int NOT NULL,
  `month` int NOT NULL,
  `investID` int NOT NULL,
  `quantity` int DEFAULT '0',
  PRIMARY KEY (`holdingsID`),
  KEY `has_idx` (`userID`),
  KEY `are type of_idx` (`investID`),
  CONSTRAINT `are type of` FOREIGN KEY (`investID`) REFERENCES `investment_instruments` (`investID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `has` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 2.	Create the performance metrics table with columns for investment ID, total return, annualized return, and risk level.
CREATE TABLE `performance_metrics` (
  `holdingsID` int NOT NULL,
  `totalReturns` decimal(10,2) NOT NULL,
  `annualizedReturns` decimal(10,2) NOT NULL,
  `riskLevel` varchar(20) NOT NULL,
  PRIMARY KEY (`holdingsID`),
  CONSTRAINT `have` FOREIGN KEY (`holdingsID`) REFERENCES `holdings` (`holdingsID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 3.	Create the market data table with columns for date, stock prices, exchange rates, and commodity prices.
CREATE TABLE `market_data` (
  `year` int NOT NULL,
  `month` int NOT NULL,
  `investID` int NOT NULL,
  `value` double NOT NULL,
  PRIMARY KEY (`investID`,`year`,`month`),
  CONSTRAINT `constitute market data` FOREIGN KEY (`investID`) REFERENCES `investment_instruments` (`investID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 4.	Create the other financial information table with columns for date, interest rates, inflation rates, and GDP growth rates.
CREATE TABLE `other_financial_info` (
  `month` int NOT NULL,
  `year` int NOT NULL,
  `gdpGrowth` double NOT NULL,
  `inflation` double NOT NULL,
  PRIMARY KEY (`month`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- 5.	Insert a new investment into the investments table.
INSERT INTO `portfolio`.`holdings`
(`holdingsID`,
`userID`,
`year`,
`month`,
`investID`,
`quantity`)
VALUES
(<{holdingsID: }>,
<{userID: }>,
<{year: }>,
<{month: }>,
<{investID: }>,
<{quantity: }>);

-- 6.	Update the number of shares held for an investment in the investments table.
-- We used a procedure for this
-- DELIMITER $$
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `update_holding`(
--     IN in_holdingsID INT,
--     IN in_userID INT,
--     IN in_year INT,
--     IN in_month INT,
--     IN in_investID INT,
--     IN in_quantity INT
-- )
-- BEGIN
--     UPDATE holdings
--     SET
--         userID = in_userID,
--         year = in_year,
--         month = in_month,
--         investID = in_investID,
--         quantity = in_quantity
--     WHERE holdingsID = in_holdingsID;
-- END$$	
-- DELIMITER ;

--example
CALL `portfolio`.`update_holding`(1, 1, 2022, 1, 1, 100);
select * from holdings

-- 7.	Delete an investment from the investments table.
-- DELIMITER $$
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_holding`(IN in_holdingID INT)
-- BEGIN
-- DELETE FROM `portfolio`.`holdings`
-- WHERE holdingsID = in_holdingID;
-- END$$
-- DELIMITER ;
CALL `portfolio`.`delete_holding`(1);
select * from holdings

/*
8. Join the holdings table with the performance metrics table to retrieve the total return for each holding.
*/
SELECT *
FROM holdings
NATURAL JOIN performance_metrics;

/*
9. Join the investments table with the market data table to retrieve the stock prices for a particular date.
*/
SELECT *
FROM holdings
NATURAL JOIN market_data
WHERE year=<year> AND month=<month>;

/*
10. to group the holdings by type and retrieve the average annualized return for each type and the total quantity for each type
This query joins the "holdings", "investment_instruments", and "performance_metrics" tables using the respective foreign keys. It then groups the resulting table by the type of investment instrument and calculates the average annualized return and the total quantity for each group using the AVG and SUM functions, respectively. The result will be a table with three columns: "type", "avg_annualized_return", and "total_quantity".
*/
SELECT ii.type, AVG(pm.annualizedReturns) AS avg_annualized_return, SUM(h.quantity) AS total_quantity
FROM holdings h
JOIN investment_instruments ii ON h.investID = ii.investID
JOIN performance_metrics pm ON h.holdingsID = pm.holdingsID
GROUP BY ii.type;

/*
11.Filter the holdings by risk level and retrieve the top-performing holdings.
This query joins the "holdings", "investment_instruments", and "performance_metrics" tables using the respective foreign keys. It filters the results by the risk level being 'high' using the WHERE clause. It then orders the result by the total returns in descending order using the ORDER BY clause. Finally, it limits the result to the top 10 rows using the LIMIT clause. The result will be a table with three columns: "holdingsID", "name", and "totalReturns".
*/
DELIMITER $$
CREATE PROCEDURE get_top_performing_holdings(IN p_risk_level VARCHAR(20))
BEGIN
  SELECT h.holdingsID, h.year, h.month, investID, ii.name, h.quantity, pm.totalReturns
  FROM holdings h
  JOIN investment_instruments ii ON h.investID = ii.investID
  JOIN performance_metrics pm ON h.holdingsID = pm.holdingsID
  WHERE pm.riskLevel = p_risk_level
  ORDER BY pm.totalReturns DESC
  LIMIT 5;
END $$
DELIMITER ;

/*
12.Calculate the total value of all holdings based on the number of shares held and the current stock prices from the market data table.
This query calculates the total value of all holdings by summing up the quantity held in each holding multiplied by the current price from the market data, without grouping by the name of the investment instrument.
*/
SELECT SUM(h.quantity * value) AS total_value
FROM holdings h
JOIN investment_instruments ii ON h.investID = ii.investID
JOIN (SELECT investID, MAX(year) AS latest_year, MAX(month) AS latest_month
      FROM market_data
      GROUP BY investID) latest_md
ON ii.investID = latest_md.investID
JOIN market_data md
ON latest_md.investID = md.investID
   AND latest_md.latest_year = md.year
   AND latest_md.latest_month = md.month;

/*
13. Calculate the portfolio’s overall annualized return based on the holdings’ individual returns and the number of shares held.
This query joins the holdings table with the performance_metrics table using the holdingsID as the join key. It then calculates the total value of the portfolio's annualized return by summing up the product of each holding's annualized return and its quantity held, and dividing that by the total quantity held across all holdings. This gives the overall annualized return of the portfolio.
*/
SELECT SUM(h.quantity * pm.annualizedReturns) / SUM(h.quantity) AS portfolio_annualized_return
FROM holdings h
JOIN performance_metrics pm ON h.holdingsID = pm.holdingsID;

/*
14. Calculate the correlation between two investments’ performance using the performance metrics table.
In this query, replace <holdingsID_1> and <holdingsID_2> with the holdings IDs of the two investments whose correlation you want to calculate.
The query calculates the correlation between the two holdings' total returns by joining the performance_metrics table to itself on the condition that the holdingsID of the first table is less than that of the second table. This ensures that the query calculates the correlation between each pair of holdings only once, instead of duplicating the calculation.
The query then uses the formula for Pearson's correlation coefficient to calculate the correlation between the two holdings' total returns. This formula calculates the covariance between the two holdings' total returns divided by the product of their standard deviations. The formula uses aggregate functions such as SUM, COUNT, and SQRT to calculate the necessary values.
*/
SELECT
    (SUM(x.totalReturns * y.totalReturns) - SUM(x.totalReturns) * SUM(y.totalReturns) / COUNT(*)) / 
    (SQRT((SUM(x.totalReturns * x.totalReturns) - SUM(x.totalReturns) * SUM(x.totalReturns) / COUNT(*)) *
          (SUM(y.totalReturns * y.totalReturns) - SUM(y.totalReturns) * SUM(y.totalReturns) / COUNT(*))))
AS correlation
FROM
    performance_metrics AS x
INNER JOIN
    performance_metrics AS y ON x.holdingsID < y.holdingsID
WHERE
    x.holdingsID = <holdingsID_1> AND y.holdingsID = <holdingsID_2>;


/*
15. Retrieve the most recent inflation rate from the other financial information table.
This query sorts the rows in other_financial_info in descending order of year and month, and then selects the inflation value from the first row.
*/
SELECT inflation
FROM other_financial_info
ORDER BY year DESC, month DESC
LIMIT 1;

/*
16. Filter the market data table by date range and retrieve the stock prices for a particular holding.
Replace <investID>, <start_year>, <start_month>, <end_year>, and <end_month> with the relevant values. This query retrieves the value column from the market_data table for the specified investID within the specified date range.
*/
SELECT value
FROM market_data
WHERE investID = (SELECT investID FROM holdings WHERE holdingsID=<passed_holdingsID>)
  AND (year > <start_year> OR (year = <start_year> AND month >= <start_month>))
  AND (year < <end_year> OR (year = <end_year> AND month <= <end_month>));

/*
17. Calculate the percentage change in stock prices for a particular investment between two dates.
Make sure to replace <investID>, <start_year>, <start_month>, <end_year>, and <end_month> with the appropriate values. This query will calculate the percentage change in stock prices for the given investment between the start and end dates provided, inclusive.
*/
SELECT ((MAX(value) - MIN(value))/MIN(value))*100 AS percentage_change
FROM market_data
WHERE investID = <investID>
AND (year = <start_year> AND month >= <start_month>)
OR (year = <end_year> AND month <= <end_month>)
OR (year > <start_year> AND year < <end_year>)