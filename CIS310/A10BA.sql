


create table PRODUCTDIM
(
	ProductID INT IDENTITY NOT NULL,
	Prod_SKU varchar(15),
	Prod_Descript varchar(255),
	Prod_Type varchar(255),
	Brand_ID numeric(4,0),
	Brand_Name varchar(100),
	Brand_Type varchar(20)
)

ALTER TABLE PRODUCTDIM
ADD CONSTRAINT PK_PRODUCTDIM PRIMARY KEY (ProdID)

Create table CUSTOMERDIM
(
	CustomerID INT IDENTITY NOT NULL,
	Cust_Code numeric(38,0),
	Cust_Fname varchar(20),
	Cust_Lname varchar(20),
	Cust_City varchar(50),
	Cust_State char(2),
	Cust_Zip char(5)
)

ALTER TABLE CUSTOMERDIM
ADD CONSTRAINT PK_CUSTOMERDIM PRIMARY KEY (CustomerID)

create table TIMEDIM
(
	TimeID INT IDENTITY NOT NULL,
	Inv_Date DATE,
	Year int,
	Month int,
	Quarter int
)

ALTER TABLE TIMEDIM
ADD CONSTRAINT PK_TIMEDIM PRIMARY KEY (TimeID)

create table EMPLOYEEDIM
(
	EmployeeID INT IDENTITY NOT NULL,
	emp_num numeric(6,0),
	emp_fname varchar(20),
	emp_lname varchar(25),
	emp_title varchar(45),
	dept_num numeric(5,0),
	dept_name varchar(50)
)

ALTER TABLE EMPLOYEEDIM
ADD CONSTRAINT PK_EMPLOYEEDIM PRIMARY KEY (EmployeeID)

create table FACT
(
	ProductID INT NOT NULL,
	TimeID INT NOT NULL,
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	Line_Qty numeric(18,0),
	Line_Price numeric(8,2)
)

ALTER TABLE FACT
ADD CONSTRAINT PK_FACT PRIMARY KEY (ProductID, TimeID, CustomerID, EmployeeID),
	CONSTRAINT FK_FACT_PRODUCT FOREIGN KEY (ProductID) REFERENCES PRODUCTDIM,
	CONSTRAINT FK_FACT_TIME FOREIGN KEY (TimeID) REFERENCES TIMEDIM,
	CONSTRAINT FK_FACT_CUSTOMER FOREIGN KEY (CustomerID) REFERENCES CUSTOMERDIM,
	CONSTRAINT FK_FACT_EMPLOYEE FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEEDIM

CREATE TABLE STAGING
(
	ProductID INT,
	TimeID INT,
	CustomerID INT,
	EmployeeID INT,
	Line_Qty NUMERIC(18,0),
	Line_Price NUMERIC(8,2),
	Cust_Code NUMERIC(38,0),
	Prod_SKU VARCHAR(15),
	Inv_Date DATE,
	Emp_Num NUMERIC(6,0)
	
)
