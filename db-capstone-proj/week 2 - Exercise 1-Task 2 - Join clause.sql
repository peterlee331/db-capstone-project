SELECT customer_details.CustomerID, customer_details.FullName, 
Orders.OrderID, Orders.TotalCost, Menu.MenuName, menu_items.CourseName
FROM customer_details INNER JOIN Orders
ON customer_details.CustomerID = Orders.CustomerID
INNER JOIN Menu
ON Orders.MenuID = Menu.MenuID
INNER JOIN menu_items
ON Menu.MenuItemsID = menu_items.MenuItemsID
WHERE TotalCost > 150
ORDER BY TotalCost ASC;


