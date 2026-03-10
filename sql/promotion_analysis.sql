/*
Business Question:
Which promotions generate the highest total revenue?
*/

SELECT 
	pr.Promo_Type,
	SUM(s.Total_Amount) AS Total_Revenue
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
GROUP BY pr.Promo_Type
ORDER BY Total_Revenue DESC;



/*
Business Question:
How many transactions occur during promotions?
*/

SELECT 
	pr.Promo_Type,
	COUNT(s.Sale_ID) AS Promotion_Transactions
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
GROUP BY pr.Promo_Type
ORDER BY Promotion_Transactions DESC;



/*
Business Question:
Which products generate the most revenue during promotions?
*/

SELECT 
	p.Product_Name,
	SUM(s.Total_Amount) AS Promotion_Revenue
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
JOIN Products p
	ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Promotion_Revenue DESC;



/*
Business Question:
How does revenue compare between promoted and non-promoted sales?
*/

SELECT 
	CASE 
		WHEN pr.Promotion_ID IS NOT NULL THEN 'Promoted'
		ELSE 'Non-Promoted'
	END AS Promotion_Status,
	SUM(s.Total_Amount) AS Revenue
FROM Sales s
LEFT JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
GROUP BY 
	CASE 
		WHEN pr.Promotion_ID IS NOT NULL THEN 'Promoted'
		ELSE 'Non-Promoted'
	END;



/*
Business Question:
Which promotion types sell the most units?
*/

SELECT 
	pr.Promo_Type,
	SUM(s.Quantity) AS Units_Sold
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
GROUP BY pr.Promo_Type
ORDER BY Units_Sold DESC;



/*
Business Question:
What is the average discount offered during promotions?
*/

SELECT 
	AVG(pr.Discount_Rate) AS Avg_Discount
FROM Promotions pr;



/*
Business Question:
Which products receive the highest average discounts?
*/

SELECT 
	p.Product_Name,
	AVG(pr.Discount_Rate) AS Avg_Discount
FROM Promotions pr
JOIN Products p
	ON pr.Product_ID = p.Product_ID
GROUP BY p.Product_Name
ORDER BY Avg_Discount DESC;



/*
Business Question:
How much revenue is generated during promotion periods by month?
*/

SELECT 
	YEAR(s.Sale_Date) AS Year,
	MONTH(s.Sale_Date) AS Month,
	SUM(s.Total_Amount) AS Promotion_Revenue
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
GROUP BY 
	YEAR(s.Sale_Date),
	MONTH(s.Sale_Date)
ORDER BY Year, Month;



/*
Business Question:
Which categories perform best during promotions?
*/

SELECT 
	p.Category,
	SUM(s.Total_Amount) AS Promotion_Revenue
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
JOIN Products p
	ON s.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY Promotion_Revenue DESC;



/*
Business Question:
Rank promotion types by total revenue generated.
*/

SELECT 
	pr.Promo_Type,
	SUM(s.Total_Amount) AS Revenue,
	RANK() OVER(ORDER BY SUM(s.Total_Amount) DESC) AS Promotion_Rank
FROM Sales s
JOIN Promotions pr
	ON s.Product_ID = pr.Product_ID
AND s.Sale_Date BETWEEN pr.Start_Date AND pr.End_Date
GROUP BY pr.Promo_Type;
