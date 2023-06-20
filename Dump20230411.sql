CREATE DATABASE  IF NOT EXISTS `portfolio` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `portfolio`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: localhost    Database: portfolio
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `holdings`
--

DROP TABLE IF EXISTS `holdings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holdings`
--

LOCK TABLES `holdings` WRITE;
/*!40000 ALTER TABLE `holdings` DISABLE KEYS */;
INSERT INTO `holdings` VALUES (2,1,2022,2,1,8),(3,1,2022,3,1,3),(4,1,2022,4,1,4),(5,1,2022,5,1,1),(6,1,2022,6,1,7),(7,1,2022,7,1,5),(8,1,2022,8,1,4),(9,1,2022,9,1,4),(10,1,2022,10,1,4),(11,1,2022,11,1,7),(13,1,2021,1,1,2),(14,1,2021,2,1,1),(15,1,2021,3,1,8),(16,1,2021,4,1,3),(17,1,2021,5,1,5),(18,1,2021,6,1,6),(19,1,2021,7,1,7),(20,1,2021,8,1,8),(21,1,2021,9,1,9),(22,1,2021,10,1,3),(23,1,2021,11,1,1),(24,1,2021,12,1,7);
/*!40000 ALTER TABLE `holdings` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `insert_performance_metric` AFTER INSERT ON `holdings` FOR EACH ROW BEGIN
  DECLARE ann_returns DECIMAL(10,2);
  DECLARE tot_returns DECIMAL(10,2);
  DECLARE risk_level VARCHAR(20);
  SET tot_returns = calculate_total_returns(NEW.holdingsID);
  SET ann_returns = calculate_ann_returns(NEW.holdingsID);
  SET risk_level = calculate_riskLevel(tot_returns,ann_returns);
  INSERT INTO performance_metrics (holdingsID, totalReturns, annualizedReturns, riskLevel)
  VALUES (NEW.holdingsID, tot_returns, ann_returns, risk_level);
  
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `investment_instruments`
--

DROP TABLE IF EXISTS `investment_instruments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `investment_instruments` (
  `investID` int NOT NULL AUTO_INCREMENT,
  `tickerSymbol` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`investID`),
  UNIQUE KEY `tickerSymbol_UNIQUE` (`tickerSymbol`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `investment_instruments`
--

LOCK TABLES `investment_instruments` WRITE;
/*!40000 ALTER TABLE `investment_instruments` DISABLE KEYS */;
INSERT INTO `investment_instruments` VALUES (1,'TECk','B','SnP Tech Index');
/*!40000 ALTER TABLE `investment_instruments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `market_data`
--

DROP TABLE IF EXISTS `market_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `market_data` (
  `year` int NOT NULL,
  `month` int NOT NULL,
  `investID` int NOT NULL,
  `value` double NOT NULL,
  PRIMARY KEY (`investID`,`year`,`month`),
  CONSTRAINT `constitute market data` FOREIGN KEY (`investID`) REFERENCES `investment_instruments` (`investID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `market_data`
--

LOCK TABLES `market_data` WRITE;
/*!40000 ALTER TABLE `market_data` DISABLE KEYS */;
INSERT INTO `market_data` VALUES (2021,1,1,12964.27),(2021,2,1,15366.54),(2021,3,1,14961.08),(2021,4,1,15339.8),(2021,5,1,14952.38),(2021,6,1,13480.34),(2021,7,1,13229.54),(2021,8,1,12261.64),(2021,9,1,11802.88),(2021,10,1,11919.91),(2021,11,1,11232.82),(2021,12,1,11380.96),(2022,1,1,13413.34),(2022,2,1,14283.64),(2022,3,1,13595.68),(2022,4,1,12834.73),(2022,5,1,13257.08),(2022,6,1,13429.02),(2022,7,1,14903),(2022,8,1,13629.4),(2022,9,1,14339.02),(2022,10,1,16247.8),(2022,11,1,16616.16),(2022,12,1,15478.8);
/*!40000 ALTER TABLE `market_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `other_financial_info`
--

DROP TABLE IF EXISTS `other_financial_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `other_financial_info` (
  `month` int NOT NULL,
  `year` int NOT NULL,
  `gdpGrowth` double NOT NULL,
  `inflation` double NOT NULL,
  PRIMARY KEY (`month`,`year`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `other_financial_info`
--

LOCK TABLES `other_financial_info` WRITE;
/*!40000 ALTER TABLE `other_financial_info` DISABLE KEYS */;
INSERT INTO `other_financial_info` VALUES (3,2023,1,7);
/*!40000 ALTER TABLE `other_financial_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_metrics`
--

DROP TABLE IF EXISTS `performance_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_metrics` (
  `holdingsID` int NOT NULL,
  `totalReturns` decimal(10,2) NOT NULL,
  `annualizedReturns` decimal(10,2) NOT NULL,
  `riskLevel` varchar(20) NOT NULL,
  PRIMARY KEY (`holdingsID`),
  CONSTRAINT `have` FOREIGN KEY (`holdingsID`) REFERENCES `holdings` (`holdingsID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_metrics`
--

LOCK TABLES `performance_metrics` WRITE;
/*!40000 ALTER TABLE `performance_metrics` DISABLE KEYS */;
INSERT INTO `performance_metrics` VALUES (2,8.37,8.42,'Medium'),(3,13.85,13.94,'High'),(4,20.60,20.73,'High'),(5,16.76,16.93,'High'),(6,15.26,15.48,'High'),(7,3.86,4.11,'Low'),(8,13.57,13.91,'High'),(9,7.95,8.36,'Medium'),(10,-4.73,-4.26,'Negative'),(11,-6.84,-6.20,'Negative'),(13,19.40,19.18,'High'),(14,0.73,0.56,'Low'),(15,3.46,3.30,'Low'),(16,0.91,0.76,'Low'),(17,3.52,3.39,'Low'),(18,14.82,14.70,'High'),(19,17.00,16.89,'High'),(20,26.24,26.14,'High'),(21,31.14,31.06,'High'),(22,29.86,29.80,'High'),(23,37.80,37.77,'High'),(24,36.01,36.01,'High');
/*!40000 ALTER TABLE `performance_metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Priyansh','123'),(2,'vansh','123');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'portfolio'
--

--
-- Dumping routines for database 'portfolio'
--
/*!50003 DROP FUNCTION IF EXISTS `calculate_ann_returns` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_ann_returns`(holdings_id INT) RETURNS decimal(10,2)
    READS SQL DATA
BEGIN
  DECLARE purchase_price DOUBLE;
  DECLARE current_price DOUBLE;
  DECLARE total_returns DOUBLE;
  DECLARE ann_returns DECIMAL(10,2);
  DECLARE holding_invest_id INT;
  DECLARE holding_year INT;
  DECLARE holding_month INT;
  DECLARE holding_date DATE;
  DECLARE holding_date_diff INT;
  DECLARE current_year INT;
  DECLARE current_month INT;

  SELECT investID, year, month INTO holding_invest_id, holding_year, holding_month
  FROM holdings
  WHERE holdingsID = holdings_id;

  SELECT value INTO purchase_price
  FROM market_data
  WHERE investID = holding_invest_id
  AND year = holding_year
  AND month = holding_month;

  SELECT value, year, month INTO current_price, current_year, current_month
  FROM market_data
  WHERE investID = holding_invest_id
  ORDER BY year DESC, month DESC
  LIMIT 1;

  SET total_returns = ((current_price - purchase_price) / purchase_price) * 100;

  SELECT CONCAT(year, '-', month, '-01') INTO holding_date
  FROM holdings
  WHERE holdingsID = holdings_id;

  SELECT DATEDIFF(CONCAT(current_year, '-', current_month, '-01'), holding_date) INTO holding_date_diff;

  SET ann_returns = ((1 + (total_returns / 100)) * POWER(365 / holding_date_diff, 1 / 365) - 1) * 100;

  RETURN ann_returns;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_riskLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_riskLevel`(total_returns DECIMAL(10,2), annualized_returns DECIMAL(10,2)) RETURNS varchar(20) CHARSET utf8mb4
    READS SQL DATA
BEGIN
  DECLARE risk_level VARCHAR(20);

  IF annualized_returns >= 10 AND total_returns >= 10 THEN
    SET risk_level = 'High';
  ELSEIF annualized_returns >= 5 AND total_returns >= 5 THEN
    SET risk_level = 'Medium';
  ELSEIF annualized_returns >= 0 AND total_returns >= 0 THEN
    SET risk_level = 'Low';
  ELSE
    SET risk_level = 'Negative';
  END IF;

  RETURN risk_level;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calculate_total_returns` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calculate_total_returns`(holdings_id INT) RETURNS decimal(10,2)
    READS SQL DATA
BEGIN
  DECLARE purchase_price DOUBLE;
  DECLARE current_price DOUBLE;
  DECLARE total_returns DECIMAL(10,2);
  DECLARE holding_invest_id INT;
  DECLARE holding_year INT;
  DECLARE holding_month INT;

  SELECT investID, year, month INTO holding_invest_id, holding_year, holding_month
  FROM holdings
  WHERE holdingsID = holdings_id;

  SELECT value INTO purchase_price
  FROM market_data
  WHERE investID = holding_invest_id
  AND year = holding_year
  AND month = holding_month;

  SELECT value INTO current_price
  FROM market_data
  WHERE investID = holding_invest_id
  ORDER BY year DESC, month DESC
  LIMIT 1;

  SET total_returns = ((current_price - purchase_price) / purchase_price) * 100;

  RETURN total_returns;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_holding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_holding`(IN in_holdingID INT)
BEGIN
DELETE FROM `portfolio`.`holdings`
WHERE holdingsID = in_holdingID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_holdings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_holdings`(IN userId INT)
BEGIN
SELECT holdingsID, year, month, investID, name, quantity
FROM holdings
NATURAL JOIN investment_instruments
WHERE userID = userId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_top_performing_holdings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_top_performing_holdings`(IN p_risk_level VARCHAR(20))
BEGIN
  SELECT h.holdingsID, h.year, h.month, h.investID, ii.name, h.quantity, pm.totalReturns
  FROM holdings h
  JOIN investment_instruments ii ON h.investID = ii.investID
  JOIN performance_metrics pm ON h.holdingsID = pm.holdingsID
  WHERE pm.riskLevel = p_risk_level
  ORDER BY pm.totalReturns DESC
  LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_holding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_holding`(
    IN in_userID INT,
    IN in_year INT,
    IN in_month INT,
    IN in_investID INT,
    IN in_quantity INT
)
BEGIN
    INSERT INTO holdings(userID, year, month, investID, quantity)
    VALUES (in_userID, in_year, in_month, in_investID, in_quantity);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_holding` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_holding`(
    IN in_holdingsID INT,
    IN in_userID INT,
    IN in_year INT,
    IN in_month INT,
    IN in_investID INT,
    IN in_quantity INT
)
BEGIN
    UPDATE holdings
    SET
        userID = in_userID,
        year = in_year,
        month = in_month,
        investID = in_investID,
        quantity = in_quantity
    WHERE holdingsID = in_holdingsID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-04-11 23:56:54
