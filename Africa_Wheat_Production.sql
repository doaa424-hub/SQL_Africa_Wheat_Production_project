--Q1-Top 5 wheat-producing countries in the last 10 years
SELECT TOP 5  Country, SUM(CAST([Value] AS FLOAT)) AS Total_Wheat_Production
FROM [africa_final - africa]
WHERE [Year] >= (SELECT MAX([Year]) FROM [africa_final - africa]) - 9
GROUP BY Country
ORDER BY Total_Wheat_Production DESC;

--Q2-Which countries have the highest average annual growth in agricultural production overall?
SELECT [Country], AVG(CAST([YoY Change] AS FLOAT)) AS Avg_YoY_Growth
FROM [africa_final - africa]
GROUP BY [Country]
ORDER BY Avg_YoY_Growth DESC;

--Q3-do countries with “Official” estimates produce more than those with “Estimated” data?
SELECT [Flag], AVG(CAST([Value] AS FLOAT)) AS Avg_Production
FROM [africa_final - africa]
GROUP BY [Flag];

--Q4-Which countries have the highest year-to-year production fluctuation تقلب في الانتاج ?
SELECT [Country], STDEV(CAST([Value] AS FLOAT)) AS Production_Variability
FROM [africa_final - africa]
GROUP BY [Country]
ORDER BY Production_Variability DESC;

--Q5-What is the production growth rate of Wheat in Nigeria over the last 5 years?
SELECT [Year], [Value]
FROM [africa_final - africa]
WHERE [Country] = 'Nigeria'
  AND [Year] >= (SELECT MAX([Year]) FROM [africa_final - africa]) - 4
ORDER BY [Year];

--Q6-What are the top 5 African countries in total agricultural production across all years?
SELECT TOP 5 [Country], SUM(CAST([Value] AS FLOAT)) AS Total_Production
FROM [africa_final - africa]
GROUP BY [Country]
ORDER BY Total_Production DESC;

--Q7-Which countries have the most stable wheat production over the years?
SELECT TOP 5 [Country], STDEV(CAST([Value] AS FLOAT)) AS Stability
FROM [africa_final - africa]
GROUP BY [Country]
ORDER BY Stability ASC;

--Q8-What was the worst year for total wheat production in Africa?
SELECT TOP 1 [Year], SUM(CAST([Value] AS FLOAT)) AS Total_Production
FROM [africa_final - africa]
GROUP BY [Year]
ORDER BY Total_Production ASC;

--Q9-Is Africa’s overall wheat production increasing or declining over time? >>(بتزيد)
SELECT [Year], SUM(CAST([Value] AS FLOAT)) AS Total_Production
FROM [africa_final - africa]
GROUP BY [Year]
ORDER BY [Year];

--Q10-Are there low-production countries with fast growth trends?
SELECT [Country], AVG(CAST([YoY Change] AS FLOAT)) AS Growth
FROM [africa_final - africa]
GROUP BY [Country]
HAVING SUM(CAST([Value] AS FLOAT)) < 100000
ORDER BY Growth DESC;

--Q11-Which countries had major production drops in a single year?
SELECT [Country], [Year], [YoY Change]
FROM [africa_final - africa]
WHERE TRY_CAST([YoY Change] AS FLOAT) < -10
ORDER BY TRY_CAST([YoY Change] AS FLOAT) ASC;

--Q12-Which countries have the biggest year-to-year swings in production?
WITH yearly AS (
    SELECT [Country], [Year], SUM(CAST([Value] AS FLOAT)) AS Total
    FROM [africa_final - africa]
    GROUP BY [Country], [Year]
),
diffs AS (
    SELECT [Country], [Year],
           Total - LAG(Total) OVER (PARTITION BY [Country] ORDER BY [Year]) AS YoY_Diff
    FROM yearly
)
SELECT * FROM diffs WHERE YoY_Diff IS NOT NULL
ORDER BY ABS(YoY_Diff) DESC;

 