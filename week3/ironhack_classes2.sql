-- Let's check what we have in the stores table
SELECT * FROM stores;

-- Let's check what we have in the sales table
SELECT * FROM sales;

-- Let's summarize store sales
SELECT stores.stor_name AS "Store", COUNT(DISTINCT(ord_num)) AS "Orders", COUNT(title_id) AS "Items", SUM(qty) AS "Qty"
FROM sales
INNER JOIN stores ON stores.stor_id = sales.stor_id
GROUP BY "Store";

/*
What if we wanted to create a new column that derived from those?
Let's check the average number of items per order and the average quantity per item for each store
*/
SELECT "Store", "Items"/"Orders" AS "AvgItems", "Qty"/"Items"::FLOAT AS "AvgQty"
FROM (
    SELECT stores.stor_name AS "Store", COUNT(DISTINCT(ord_num)) AS "Orders", COUNT(title_id) AS "Items", SUM(qty) AS "Qty"
    FROM sales
    INNER JOIN stores ON stores.stor_id = sales.stor_id
    GROUP BY "Store"
) AS summary;

-- What if we wanted to know the sales by title for each store that averaged more than one item per order?

-- Let's check the titles table
SELECT * FROM titles;

-- Let's query everything together
SELECT "Store", ord_num AS "OrderNumber", ord_date AS "OrderDate", title AS "Title", sales.qty AS "Qty", price AS "Price", "type" AS "Type"
FROM (
    SELECT stores.stor_id AS "StoreID", stores.stor_name AS "Store", COUNT(DISTINCT(ord_num)) AS "Orders", COUNT(title_id) AS "Items", SUM(qty) AS "Qty"
    FROM sales
    INNER JOIN stores ON stores.stor_id = sales.stor_id
    GROUP BY "StoreID", "Store"
) AS summary
INNER JOIN sales ON summary."StoreID" = sales.stor_id
INNER JOIN titles ON sales.title_id = titles.title_id
WHERE "Items" / "Orders" > 1;

-- Since subqueries can get messy quickly, let's save the query inside a temporary table
SELECT stores.stor_id AS "StoreID", stores.stor_name AS "Store", COUNT(DISTINCT(ord_num)) AS "Orders", COUNT(title_id) AS "Items", SUM(qty) AS "Qty"
INTO TEMP TABLE store_sales_summary
FROM sales
INNER JOIN stores ON stores.stor_id = sales.stor_id
GROUP BY "StoreID", "Store";

-- Let's see what we have inserted into the temp table
SELECT * FROM store_sales_summary;

-- Let's rewrite the query to know the sales by title for each store that averaged more than one item per order
SELECT "Store", ord_num AS "OrderNumber", ord_date AS "OrderDate", title AS "Title", sales.qty AS "Qty", price AS "Price", "type" AS "Type"
FROM store_sales_summary AS summary
INNER JOIN sales ON summary."StoreID" = sales.stor_id
INNER JOIN titles ON sales.title_id = titles.title_id
WHERE "Items" / "Orders" > 1;