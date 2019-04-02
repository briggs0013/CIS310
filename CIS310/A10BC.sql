



--run stored procedure
EXEC A10BB

--4
SELECT	 P.PROD_SKU, P.PROD_DESCRIPT, SUM(F.LINE_QTY*F.LINE_PRICE) AS TOTAL
FROM	FACT F INNER JOIN PRODUCTDIM P ON P.PRODUCTID = F.PRODUCTID
GROUP BY P.PROD_SKU, P.PROD_DESCRIPT
HAVING SUM(F.LINE_QTY*F.LINE_PRICE) IN (SELECT TOP 5 SUM(F.LINE_QTY*F.LINE_PRICE)
									   FROM	FACT F INNER JOIN PRODUCTDIM P ON P.PRODUCTID = F.PRODUCTID
									   GROUP BY P.PROD_SKU, P.PROD_DESCRIPT
									   ORDER BY SUM(F.LINE_QTY*F.LINE_PRICE) DESC)
ORDER BY TOTAL DESC

--5

SELECT	E.EMP_FNAME, E.EMP_LNAME, SUM(F.LINE_QTY*F.LINE_PRICE) AS TOTAL
FROM	FACT F INNER JOIN EMPLOYEEDIM E ON E.EMPLOYEEID = F.EMPLOYEEID
GROUP BY E.EMP_FNAME, E.EMP_LNAME
HAVING SUM(F.LINE_QTY*F.LINE_PRICE) IN (SELECT TOP 5 SUM(F.LINE_QTY*F.LINE_PRICE)
									    FROM	FACT F INNER JOIN EMPLOYEEDIM E ON E.EMPLOYEEID = F.EMPLOYEEID
									    GROUP BY E.EMP_FNAME, E.EMP_LNAME
									    ORDER BY SUM(F.LINE_QTY*F.LINE_PRICE) DESC)
ORDER BY TOTAL DESC



--6

SELECT	C.CUST_CITY, P.BRAND_NAME, SUM(F.LINE_QTY*F.LINE_PRICE) AS TOTAL
FROM	FACT F INNER JOIN CUSTOMERDIM C ON F.CUSTOMERID = C.CUSTOMERID
		INNER JOIN	PRODUCTDIM P ON P.PRODUCTID = F.PRODUCTID
GROUP BY C.CUST_CITY, P.BRAND_NAME
ORDER BY TOTAL DESC


--7
SELECT	C.CUST_FNAME, C.CUST_LNAME, P.PROD_DESCRIPT, P.PROD_SKU, SUM(F.LINE_QTY*F.LINE_PRICE) AS TOTAL
FROM	FACT F INNER JOIN CUSTOMERDIM C ON C.CUSTOMERID = F.CUSTOMERID
		INNER JOIN PRODUCTDIM P ON P.PRODUCTID = F.PRODUCTID
GROUP BY C.CUSTOMERID, C.CUST_FNAME, C.CUST_LNAME,P.PROD_DESCRIPT, P.PROD_SKU
HAVING	SUM(F.LINE_QTY*F.LINE_PRICE) IN (SELECT TOP 5 SUM(FF.LINE_QTY*FF.LINE_PRICE)
										 FROM	FACT FF INNER JOIN CUSTOMERDIM CC ON CC.CUSTOMERID = FF.CUSTOMERID
												INNER JOIN PRODUCTDIM PP ON PP.PRODUCTID = FF.PRODUCTID
										 WHERE CC.CUSTOMERID = C.CUSTOMERID
										 GROUP BY  CC.CUSTOMERID, CC.CUST_FNAME, CC.CUST_LNAME, PP.PROD_SKU
										 ORDER BY CC.CUSTOMERID, SUM(FF.LINE_QTY*FF.LINE_PRICE) DESC)
ORDER BY C.CUST_LNAME, C.CUST_FNAME, SUM(F.LINE_QTY*F.LINE_PRICE) DESC



											
											 	


