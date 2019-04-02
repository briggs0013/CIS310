--1
SELECT	ItemID, DESCRIPTION, LISTPRICE
FROM	PET..Merchandise
WHERE	LISTPRICE > (SELECT AVG(LISTPRICE) FROM PET..Merchandise)

--2
SELECT	O.ITEMID, AVG(S.SALEPRICE) as [AVG SALE], AVG(O.COST) as [AVG COST]
FROM	PET..ORDERITEM O INNER JOIN PET..SALEITEM S ON O.ITEMID = S.ITEMID	
GROUP BY O.ITEMID
HAVING AVG(O.COST)*1.5 < AVG(S.SALEPRICE)
ORDER BY ITEMID




--3
SELECT	E.EMPLOYEEID,E.LASTNAME, SUM(SI.SALEPRICE*SI.QUANTITY) AS [TOTAL SALES], SUM(SI.SALEPRICE*SI.QUANTITY)/(SELECT SUM(QUANTITY*SALEPRICE) FROM PET..SALEITEM)*100 AS [% of TOTAL SALES] 
FROM	PET..EMPLOYEE E INNER JOIN PET..SALE S ON E.EMPLOYEEID = S.EMPLOYEEID
		INNER JOIN PET..SALEITEM SI ON S.SALEID = SI.SALEID
GROUP BY E.EMPLOYEEID, E.LASTNAME
ORDER BY E.EMPLOYEEID


--4  
SELECT  S.SUPPLIERID, S.NAME, AVG(MO.SHIPPINGCOST) AS [AVG], SUM(QUANTITY*COST) AS TOTAL, (AVG(MO.SHIPPINGCOST)/SUM(QUANTITY*COST)*100) AS PctShipCost
FROM	PET..SUPPLIER S INNER JOIN PET..MERCHANDISEORDER MO ON S.SUPPLIERID = MO.SUPPLIERID
		INNER JOIN PET..ORDERITEM O ON MO.PONUMBER = O.PONUMBER
GROUP BY S.SUPPLIERID, S.NAME
HAVING (AVG(MO.SHIPPINGCOST)/SUM(QUANTITY*COST)*100) = (SELECT TOP 1 (AVG(MO.SHIPPINGCOST)/SUM(QUANTITY*COST)*100) AS QShipCost
														FROM	PET..SUPPLIER S INNER JOIN PET..MERCHANDISEORDER MO ON S.SUPPLIERID = MO.SUPPLIERID
																		   INNER JOIN PET..ORDERITEM O ON MO.PONUMBER = O.PONUMBER
														GROUP BY S.SUPPLIERID
														ORDER BY QShipCost DESC)




--5
Create View TotalMerchandise As
Select 	C.CUSTOMERID, SUM(SI.SALEPRICE*SI.QUANTITY) AS totalMerchandise
FROM	PET..CUSTOMER C INNER JOIN PET..SALE S ON C.CUSTOMERID = S.CUSTOMERID
		INNER JOIN PET..SALEITEM SI ON S.SALEID = SI.SALEID
Group By C.CUSTOMERID, C.FIRSTNAME, C.LASTNAME

Create View TotalAnimal As
Select 	C.CUSTOMERID, SUM(SA.SALEPRICE) AS totalAnimal
FROM	PET..CUSTOMER C INNER JOIN PET..SALE S ON C.CUSTOMERID = S.CUSTOMERID
		INNER JOIN PET..SALEANIMAL SA ON S.SALEID = SA.SALEID
Group By C.CUSTOMERID, C.FIRSTNAME, C.LASTNAME


Select C.CUSTOMERID, C.FIRSTNAME, C.LASTNAME, TOTALANIMAL, TOTALMERCHANDISE, ToTalMerchandise+TOTALANIMAL AS [GRANDTOTAL]
FROM	PET..Customer C INNER JOIN TOTALANIMAL TA ON C.CUSTOMERID = TA.CUSTOMERID
	    INNER JOIN TOTALMERCHANDISE TM ON TA.CUSTOMERID = TM.CUSTOMERID
WHERE  TOTALMERCHANDISE+TOTALANIMAL = (Select TOP 1 ToTalMerchandise+TOTALANIMAL AS [GRANDTOTAL]
									   FROM	PET..Customer C INNER JOIN TOTALANIMAL TA ON C.CUSTOMERID = TA.CUSTOMERID
															INNER JOIN TOTALMERCHANDISE TM ON TA.CUSTOMERID = TM.CUSTOMERID
									   ORDER BY GRANDTOTAL DESC)
--6
SELECT  C.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, S.SALEDATE, SUM(SI.QUANTITY*SI.SALEPRICE) AS [MAY TOTAL]
FROM	PET..CUSTOMER C INNER JOIN PET..SALE S ON C.CUSTOMERID = S.CUSTOMERID
				        INNER JOIN PET..SALEITEM SI ON S.SALEID = SI.SALEID
WHERE C.CUSTOMERID IN (SELECT C.CUSTOMERID
					   FROM PET..CUSTOMER C INNER JOIN PET..SALE S ON C.CUSTOMERID = S.CUSTOMERID
									        INNER JOIN PET..SALEITEM SI ON S.SALEID = SI.SALEID
					   GROUP BY C.CUSTOMERID, S.SALEDATE
					   HAVING (MONTH(S.SALEDATE) = 10) AND (SUM(SI.QUANTITY*SI.SALEPRICE) > 50))
GROUP BY C.CUSTOMERID, C.LASTNAME, C.FIRSTNAME, S.SALEDATE
HAVING	(MONTH(S.SALEDATE) = 5) AND (SUM(SI.QUANTITY*SI.SALEPRICE) > 100)
ORDER BY S.SALEDATE




--7 

SELECT M.DESCRIPTION, M.ITEMID,SUM(OI.QUANTITY) AS Purchased, (SELECT SUM(SI.QUANTITY) 
															   FROM PET..SALEITEM SI INNER JOIN PET..SALE S ON S.SALEID = SI.SALEID 
															   WHERE ITEMID IN (SELECT ITEMID
																			    FROM PET..MERCHANDISE
																			    WHERE DESCRIPTION = 'DOG FOOD-CAN-PREMIUM' 
															   AND S.SALEDATE between '2004-1-1' AND '2004-7-1')) AS SOLD, SUM(OI.QUANTITY) - (SELECT SUM(SI.QUANTITY) 
																																			   FROM PET..SALEITEM SI INNER JOIN PET..SALE S ON S.SALEID = SI.SALEID 
																																			   WHERE ITEMID IN (SELECT ITEMID
																																									    FROM PET..MERCHANDISE
																																									    WHERE DESCRIPTION = 'DOG FOOD-CAN-PREMIUM' 
																																					   AND S.SALEDATE between '2004-1-1' AND '2004-7-1')) AS NetIncrease
FROM	PET..MERCHANDISE M INNER JOIN PET..ORDERITEM OI ON M.ITEMID = OI.ITEMID
		INNER JOIN PET..MERCHANDISEORDER MO ON OI.PONUMBER = MO.PONUMBER
WHERE   DESCRIPTION = 'DOG FOOD-CAN-PREMIUM' AND RECEIVEDATE between '2004-1-1' AND '2004-7-1'
GROUP BY M.DESCRIPTION, M.ITEMID

--8
SELECT	M.ITEMID, M.DESCRIPTION, M.LISTPRICE 
FROM	PET..MERCHANDISE M INNER JOIN PET..SALEITEM SI ON M.ITEMID = SI.ITEMID
		INNER JOIN PET..SALE S ON SI.SALEID = S.SALEID
WHERE	M.ITEMID IN (SELECT SI.ITEMID
					 FROM PET..SALEITEM SI INNER JOIN PET..SALE S ON SI.SALEID = S.SALEID
					 WHERE MONTH(S.SALEDATE) <> 7 AND M.LISTPRICE > 50)
GROUP BY M.ITEMID, M.DESCRIPTION, M.LISTPRICE
--alternate 8
SELECT	M.ITEMID, M.DESCRIPTION, M.LISTPRICE 
FROM	PET..MERCHANDISE M INNER JOIN PET..SALEITEM SI ON M.ITEMID = SI.ITEMID
		INNER JOIN PET..SALE S ON SI.SALEID = S.SALEID
WHERE	MONTH(S.SALEDATE) <> 7 AND M.LISTPRICE > 50
GROUP BY M.ITEMID, M.DESCRIPTION, M.LISTPRICE

--9
SELECT	M.ITEMID, M.DESCRIPTION, M.QUANTITYONHAND, OI.ITEMID
FROM	PET..MERCHANDISE M LEFT OUTER JOIN PET..ORDERITEM OI ON M.ITEMID = OI.ITEMID
		LEFT OUTER JOIN PET..MERCHANDISEORDER MO ON OI.PONUMBER = MO.PONUMBER
WHERE	M.QUANTITYONHAND > 100 AND MO.ORDERDATE IS NULL

--10 
SELECT	M.ITEMID, M.DESCRIPTION, M.QUANTITYONHAND
FROM	PET..MERCHANDISE M
WHERE	QUANTITYONHAND > 100 AND M.ITEMID NOT IN (SELECT OI.ITEMID
												  FROM PET..ORDERITEM OI INNER JOIN PET..MERCHANDISEORDER MO ON MO.PONUMBER = OI.PONUMBER
												  WHERE YEAR(MO.ORDERDATE) = 2004)

--10 test
SELECT	M.ITEMID, M.DESCRIPTION, M.QUANTITYONHAND
FROM	PET..MERCHANDISE M
WHERE	QUANTITYONHAND > 100 AND M.ITEMID NOT IN (SELECT OI.ITEMID
												  FROM PET..ORDERITEM OI)


--10 test
SELECT	M.ITEMID, M.DESCRIPTION, M.QUANTITYONHAND, OI.ITEMID
FROM	PET..MERCHANDISE M LEFT OUTER JOIN PET..ORDERITEM OI ON M.ITEMID = OI.ITEMID
		LEFT OUTER JOIN PET..MERCHANDISEORDER MO ON OI.PONUMBER = MO.PONUMBER
WHERE	M.ITEMID IN    (SELECT	M.ITEMID
						FROM	PET..MERCHANDISE M LEFT OUTER JOIN PET..ORDERITEM OI ON M.ITEMID = OI.ITEMID
											  LEFT OUTER JOIN PET..MERCHANDISEORDER MO ON OI.PONUMBER = MO.PONUMBER
						WHERE	M.QUANTITYONHAND > 100 AND MO.ORDERDATE IS NULL) 
   


						 	
--11
--query created from exercise 5 
CREATE VIEW TOTALMONEYSPENT AS
Select C.CUSTOMERID, C.FIRSTNAME, C.LASTNAME, TOTALMERCHANDISE+TOTALANIMAL AS [GRANDTOTAL]
FROM	PET..Customer C INNER JOIN TOTALANIMAL TA ON C.CUSTOMERID = TA.CUSTOMERID
	    INNER JOIN TOTALMERCHANDISE TM ON TA.CUSTOMERID = TM.CUSTOMERID
--create table category
CREATE TABLE CATEGORY
(
	CATEGORY VARCHAR(10),
	LOW	INT,
	HIGH INT
)
INSERT INTO CATEGORY
VALUES	('WEAK', 0, 200), ('GOOD',200,800), ('BEST', 800, 10000)

--Write a query that lists each customer from the first query and displays the proper label.
SELECT CUSTOMERID, FIRSTNAME, LASTNAME, GRANDTOTAL, 
		IIF(GRANDTOTAL >= 800, (select c.category from category c where low = 800) , IIF(GRANDTOTAL >= 200, (select c.category from category c where low = 200),(select c.category from category c where low = 0))) 
FROM	TOTALMONEYSPENT

--12
SELECT	DISTINCT S.NAME, 'ANIMAL' AS ORDERTYPE
FROM	PET..SUPPLIER S INNER JOIN PET..ANIMALORDER AO ON S.SUPPLIERID = AO.SUPPLIERID
WHERE	MONTH(AO.ORDERDATE) = 6
UNION ALL
SELECT	DISTINCT S.NAME, 'MERCHANDISE' AS ORDERTYPE
FROM	PET..SUPPLIER S INNER JOIN PET..MERCHANDISEORDER MO ON S.SUPPLIERID = MO.SUPPLIERID
WHERE	MONTH(MO.ORDERDATE) = 6

--13
DROP TABLE CATEGORY

CREATE TABLE CATEGORY
(
	CATEGORY VARCHAR(10),
	LOW	INT,
	HIGH INT
)
INSERT INTO CATEGORY
VALUES	('WEAK', 0, 200), ('GOOD',200,800), ('BEST', 800, 10000)

--14
INSERT INTO CATEGORY
VALUES	('WEAK', 0, 200)

--15 (DID NOT RUN THIS QUERY SINCE IT WOULD AFFECT OTHER ANSWERS)
UPDATE CATEGORY
SET	HIGH = 400
WHERE CATEGORY = 'WEAK'

--17
DELETE FROM CATEGORY
WHERE CATEGORY = 'WEAK'

--18
SELECT * INTO TEMP_CATEGORY
FROM	CATEGORY

DELETE
FROM TEMP_CATEGORY

INSERT INTO TEMP_CATEGORY
SELECT *
FROM CATEGORY













