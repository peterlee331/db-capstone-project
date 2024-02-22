use littlelemondb_fv; 

SELECT MenuName
FROM Menu
WHERE MenuID = any(
SELECT MenuID
FROM Orders
WHERE Quantity > 2
order by MenuName asc);