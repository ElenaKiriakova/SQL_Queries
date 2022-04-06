-- ����� �������� ������� ��������� ����� � �����?
SELECT TOP (1) WITH TIES EmployeeID , ShipCity, OrderDate
FROM Orders 
WHERE ShipCity = 'Paris'
ORDER BY OrderDate DESC
---------------------------------
--����� ���-��, ������� ����, ��� ����, ���� ����, 
--����� � ������ �� ����� ����. ������������� �� ���-�� ����. ������� 
--�� ������, ��� ���-�� ������ 3
select [type], count(title) as Quantity,
			MIN(Price) AS '��� ����',
			MAX(Price) AS '���� ����',
			SUM(Price) AS '����� �� ���� ����'
from titles
GROUP BY [type]
having count(title)>3
ORDER BY Quantity

Select [type], 
	count ([type]) as Amount, 
	min ([price]) as MIN_Price, 
	avg ([price]) as AV_Price,  
	max ([price]) as MAX_Price, 
	[ytd_sales]
from [dbo].[titles]
group by [type]

select distinct [type] from [titles]
------------------------------------------
--����� ���������� ������� � ������ ������, ������� ��������
--������� ������ �� ������, � ������� ���������� �������,
--������� �������� ������ 2
select city, count(au_id) as quantiy
from authors
where contract = 1
group by city
having count(au_id)>2


---- ������� ����������� �������� � ���� � ��� �� ���(employees)
select year(BirthDate), count(BirthDate)
from employees
group by year(BirthDate)
order by year(BirthDate)
-------------------------------------
--������� �������, ������� � ������ CA, TN, OR
select 
au_lname + ' ' + au_fname as Authors
from [dbo].[authors]
where [state] in ('CA', 'TN', 'OR')
--------------------------------------
--������� ������, �������
--������������� �� ����� � ��������� b-j � �������������
select ShipCity from Orders
where ShipCity like '%[b-j]' --or ShipCity like '%[b-j]'
order by ShipCity

--------------------------------------
-- ����� �� �������� �� ������� 
-- ��� ���� ������� ������ 70 ������� �� �������� � ��������
select ShipCountry, 
  count(OrderID) as '���-�� �������'
from orders
WHERE ShipCountry IN ('Brazil','Germany')-- ��� ����!!!
group by ShipCountry
having count(OrderID)>70
		--AND ShipCountry IN ('Brazil','Germany') -- ��� �� ����!!!
order by ShipCountry
-------------------------------------
-- ����� �������� � 1997 ���� ������ ��������� 
--������ 5 ��������� ������� � ����� ������
select  distinct employeeid--, ShipCountry, count(distinct shipcity) as quantity
from orders
where year(orderdate) = 1997
group by employeeid, ShipCountry
having count(distinct shipcity)>5
order by employeeid--, ShipCountry
------------------------------------
-- ������ �� UNION && UNION ALL
--������� ������ � ������ ��� ����������� � ���������
select city, Country from Employees
union all
select city, Country from Customers
order by city, Country
-- ������ �� INTERSECT
-- �������� ������ ������� � �����, ��� ���� � ������� � ����������
select city, Country from Employees
intersect
select city, Country from Customers
order by city, Country
-- ������ �� EXCEPT (���������)
-- �������� ������ ������� � �����, ��� ���� ����������, �� ��� ��������
select city, Country from Employees
except
select city, Country from Customers
order by city, Country
-- �������� ������ ������� � �����, ��� ���� �������, �� ��� �����������
select city, Country from Customers 
except
select city, Country from Employees
order by city, Country
----------------------------------------
--����������
--�����������������
--����� ������, ��� ���� ������ ������� ����
select productname
from products
where UnitPrice>(select avg(unitprice) from Products)
-----------------------------------------
--���������������
-- ������� ������� ������� ������ �������� (���)
select * from orders
select * from Employees

select EmployeeID,firstname+' '+lastname,
	(
		select count(orderid) 
		from orders
		where orders.EmployeeID = Employees.EmployeeID
	) as quantity
from Employees
-- ������� ������� ������� �������� �1
SELECT COUNT(OrderID)
FROM Orders
WHERE EmployeeID = 2
--������� �� ���������� ����������� ������ ��, ��� ���-�� ������ 100




select *
from (
	select EmployeeID, firstname+' '+lastname as [name],
		(
			select count(orderid) 
			from orders
			where orders.EmployeeID = Employees.EmployeeID
		) as quantity
	from Employees) as t
where quantity >100
-------------------------------------------------------
--join
select * from orders
select * from Employees
--cross join
--old fashioned style
select OrderID, orders.EmployeeID, Employees.EmployeeID, FirstName+' '+LastName
from orders, Employees
--the newest style
select OrderID, orders.EmployeeID, Employees.EmployeeID, FirstName+' '+LastName
from orders cross join Employees
--inner join
--old fashioned style
select OrderID, orders.EmployeeID, Employees.EmployeeID, FirstName+' '+LastName
from orders, Employees
where orders.EmployeeID = Employees.EmployeeID
--the newest style
select OrderID, orders.EmployeeID, Employees.EmployeeID, FirstName+' '+LastName
from orders join Employees
on orders.EmployeeID = Employees.EmployeeID
------------------------------------------
-- ������� ������� ������� ������ �������� (���) join
SELECT *
FROM Orders AS O INNER JOIN
		Employees AS E 
     
	 ON O.EmployeeID = E.EmployeeID 

------------------------------
Select s.[EmployeeID], firstname+' '+lastname as FullName, count ([OrderID]) as Sales_am
from [dbo].[Employees] as s inner join [dbo].[Orders] as l on s.[EmployeeID]=l.[EmployeeID]

group by s.[EmployeeID], s.firstname+' '+lastname
------------------------------
--������� �������� ������������(pub_name) � ���������� � ���(pr_info)
select * from publishers
select * from pub_info

select publishers.pub_name, pub_info.pr_info
from publishers join pub_info 
on publishers.pub_id = pub_info.pub_id

select pub_name,
	(
		select pr_info
		from pub_info
		where pub_info.pub_id = publishers.pub_id
	)
from publishers 
----------------------------------
-- �������� ��� �����������(employess), 
--������� � 1997 ���� ������ ������(orders) � �� ������, � ������� ���������
--join
select * from Employees
select * from orders

select distinct firstname+' '+lastname as FullName 
from orders as O inner join  Employees as E 
on E.EmployeeID = o.EmployeeID and o.ShipCountry = e.Country
where year(o.OrderDate)=1997 
------------------
select distinct firstname+' '+lastname as FullName
from employees
where Country in  (Select Orders.ShipCountry
  from Orders
  where year(Orders.OrderDate)=1997 and
  employees.EmployeeID=Orders.EmployeeID
  )

--�������� ��� �����������, ������� ������ ������ � �� ������, 
---� ������� ���������
SELECT DISTINCT Lastname
FROM Employees
WHERE City IN 
			(
			SELECT DISTINCT ShipCity
			FROM Orders
			WHERE EmployeeID = Employees.EmployeeID 
			)

--------------------------------------
-- ������� ���� ������ ������� � ������ ���������
select * from Categories
select * from [Order Details]
select * from Products

select categoryname, 
					(
						select sum(quantity)
						from [Order Details]
						where ProductID in 
											(
												select productid
												from products
												where Products.CategoryID = Categories.CategoryID
											)
					) as '���� ������'


from Categories

----------------------------------------------
--��������� join
SELECT Orders.CreatedAt, Customers.FirstName, Products.ProductName 
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId
JOIN Customers ON Customers.Id=Orders.CustomerId
WHERE Products.Price < 45000
ORDER BY Customers.FirstName