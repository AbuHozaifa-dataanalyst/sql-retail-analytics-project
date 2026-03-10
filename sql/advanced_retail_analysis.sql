/*
Business Question:
What is the year-over-year (YoY) revenue growth of the company?
*/

SELECT 
	YEAR(Sale_Date) AS Year,
	SUM(Total_Amount) AS Revenue,
	LAG(SUM(Total_Amount)) OVER (ORDER BY YEAR(Sale_Date)) AS Previous_Year_Revenue,
	SUM(Total_Amount) - LAG(SUM(Total_Amount)) OVER (ORDER BY YEAR(Sale_Date)) AS YoY_Growth
FROM Sales
GROUP BY YEAR(Sale_Date)
ORDER BY Year;



/*
Business Question:
What is the month-over-month (MoM) revenue trend?
*/

SELECT 
	YEAR(Sale_Date) AS Year,
	MONTH(Sale_Date) AS Month,
	SUM(Total_Amount) AS Revenue,
	LAG(SUM(Total_Amount)) OVER(
		ORDER BY YEAR(Sale_Date), MONTH(Sale_Date)
	) AS Previous_Month_Revenue
FROM Sales
GROUP BY YEAR(Sale_Date), MONTH(Sale_Date)
ORDER BY Year, Month;



/*
Business Question:
Which products perform best in each region?
*/

SELECT 
	st.Region,
	p.Product_Name,
	SUM(s.Total_Amount) AS Revenue,
	RANK() OVER(
		PARTITION BY st.Region
		ORDER BY SUM(s.Total_Amount) DESC
	) AS Product_Rank
FROM Sales s
JOIN Stores st
	ON s.Store_ID = st.Store_ID
JOIN Products p
	ON s.Product_ID = p.Product_ID
GROUP BY st.Region, p.Product_Name;



/*
Business Question:
Which customers generate the highest lifetime value (CLV)?
*/

SELECT 
	c.Customer_ID,
	SUM(s.Total_Amount) AS Customer_Lifetime_Value
FROM Sales s
JOIN Customers c
	ON s.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID
ORDER BY Customer_Lifetime_Value DESC;



/*
Business Question:
Which stores have the highest average basket size?
*/

SELECT 
	st.Store_Name,
	AVG(s.Quantity) AS Avg_Basket_Size
FROM Sales s
JOIN Stores st
	ON s.Store_ID = st.Store_ID
GROUP BY st.Store_Name
ORDER BY Avg_Basket_Size DESC;



/*
Business Question:
What percentage of revenue comes from the top 10 products?
*/

WITH Product_Revenue AS	(
	SELECT 
		p.Product_Name,
		SUM(s.Total_Amount) AS Revenue
	FROM Sales s
	JOIN Products p
		ON s.Product_ID = p.Product_ID
	GROUP BY p.Product_Name
)

SELECT TOP 10
	Product_Name,
	Revenue,
	Revenue * 100.0 / SUM(Revenue) OVER() AS Revenue_Percentage
FROM Product_Revenue
ORDER BY Revenue DESC;



/*
Business Question:
Which categories are growing the fastest year over year?
*/

SELECT 
	p.Category,
	YEAR(s.Sale_Date) AS Year,
	SUM(s.Total_Amount) AS Revenue
FROM Sales s
JOIN Products p
	ON s.Product_ID = p.Product_ID
GROUP BY p.Category, YEAR(s.Sale_Date)
ORDER BY p.Category, Year;



/*
Business Question:
Which cities have the highest revenue per customer?
*/

SELECT 
	c.City,
	SUM(s.Total_Amount) AS Total_Revenue,
	COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
	SUM(s.Total_Amount) / COUNT(DISTINCT c.Customer_ID) AS Revenue_Per_Customer
FROM Sales s
JOIN Customers c
	ON s.Customer_ID = c.Customer_ID
GROUP BY c.City
ORDER BY Revenue_Per_Customer DESC;



/*
Business Question:
What are the peak sales days of the week?
*/

SELECT 
	DATENAME(WEEKDAY, Sale_Date) AS Day_of_Week,
	SUM(Total_Amount) AS Revenue
FROM Sales
GROUP BY DATENAME(WEEKDAY, Sale_Date)
ORDER BY Revenue DESC;



/*
Business Question:
What are the peak sales months?
*/

SELECT 
	DATENAME(MONTH, Sale_Date) AS Month,
	SUM(Total_Amount) AS Revenue
FROM Sales
GROUP BY DATENAME(MONTH, Sale_Date)
ORDER BY Revenue DESC;
