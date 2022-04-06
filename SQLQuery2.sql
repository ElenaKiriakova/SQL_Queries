-- какой продавец оформил последний заказ в Париж?
SELECT TOP (1) WITH TIES EmployeeID , ShipCity, OrderDate
FROM Orders 
WHERE ShipCity = 'Paris'
ORDER BY OrderDate DESC
---------------------------------
--Найти кол-во, среднюю цену, мин цену, макс цену, 
--доход в каждом из типов книг. Отсортировать по кол-ву книг. Вывести 
--те строки, где кол-во больше 3
select [type], count(title) as Quantity,
			MIN(Price) AS 'Мин цена',
			MAX(Price) AS 'Макс цена',
			SUM(Price) AS 'Доход от всех книг'
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
--Найти количество авторов в каждом городе, имеющих контракт
--Вывести только те города, в которых количество авторов,
--имеющих контракт больше 2
select city, count(au_id) as quantiy
from authors
where contract = 1
group by city
having count(au_id)>2


---- Сколько сотрудников родились в один и тот же год(employees)
select year(BirthDate), count(BirthDate)
from employees
group by year(BirthDate)
order by year(BirthDate)
-------------------------------------
--Вывести авторов, живущих в штатах CA, TN, OR
select 
au_lname + ' ' + au_fname as Authors
from [dbo].[authors]
where [state] in ('CA', 'TN', 'OR')
--------------------------------------
--Вывести города, которые
--заканчиваются на букву в диапозоне b-j и отсротировать
select ShipCity from Orders
where ShipCity like '%[b-j]' --or ShipCity like '%[b-j]'
order by ShipCity

--------------------------------------
-- Отчет по продажам по странам 
-- где было сделано больше 70 заказов из бразилии и германии
select ShipCountry, 
  count(OrderID) as 'кол-во заказов'
from orders
WHERE ShipCountry IN ('Brazil','Germany')-- так надо!!!
group by ShipCountry
having count(OrderID)>70
		--AND ShipCountry IN ('Brazil','Germany') -- так не надо!!!
order by ShipCountry
-------------------------------------
-- Какие продавцы в 1997 году смогли обслужить 
--больше 5 различных городов в одной стране
select  distinct employeeid--, ShipCountry, count(distinct shipcity) as quantity
from orders
where year(orderdate) = 1997
group by employeeid, ShipCountry
having count(distinct shipcity)>5
order by employeeid--, ShipCountry
------------------------------------
-- пример на UNION && UNION ALL
--Вывести города и страны для покупателей и продавцов
select city, Country from Employees
union all
select city, Country from Customers
order by city, Country
-- пример на INTERSECT
-- показать список городов и стран, где есть и клиенты и сотрудники
select city, Country from Employees
intersect
select city, Country from Customers
order by city, Country
-- пример на EXCEPT (вычитание)
-- показать список городов и стран, где есть сотрудники, но нет клиентов
select city, Country from Employees
except
select city, Country from Customers
order by city, Country
-- показать список городов и стран, где есть клиенты, но нет сотрудников
select city, Country from Customers 
except
select city, Country from Employees
order by city, Country
----------------------------------------
--Подзапросы
--Некоррелированный
--Найти товары, чья цена больше средней цены
select productname
from products
where UnitPrice>(select avg(unitprice) from Products)
-----------------------------------------
--Коррелированный
-- сколько заказов оформил каждый продавец (ФИО)
select * from orders
select * from Employees

select EmployeeID,firstname+' '+lastname,
	(
		select count(orderid) 
		from orders
		where orders.EmployeeID = Employees.EmployeeID
	) as quantity
from Employees
-- сколько заказов оформил продавец №1
SELECT COUNT(OrderID)
FROM Orders
WHERE EmployeeID = 2
--Вывести из полученных результатов только те, где кол-во больше 100




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
-- сколько заказов оформил каждый продавец (ФИО) join
SELECT *
FROM Orders AS O INNER JOIN
		Employees AS E 
     
	 ON O.EmployeeID = E.EmployeeID 

------------------------------
Select s.[EmployeeID], firstname+' '+lastname as FullName, count ([OrderID]) as Sales_am
from [dbo].[Employees] as s inner join [dbo].[Orders] as l on s.[EmployeeID]=l.[EmployeeID]

group by s.[EmployeeID], s.firstname+' '+lastname
------------------------------
--Вывести название издательства(pub_name) и информацию о нем(pr_info)
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
-- показать ФИО сотрудников(employess), 
--которые в 1997 году делали заказы(orders) в те страны, в которых проживают
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

--показать ФИО сотрудников, которые делали заказы в те города, 
---в которых проживают
SELECT DISTINCT Lastname
FROM Employees
WHERE City IN 
			(
			SELECT DISTINCT ShipCity
			FROM Orders
			WHERE EmployeeID = Employees.EmployeeID 
			)

--------------------------------------
-- сколько штук товара продано в каждой категории
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
					) as 'Штук товара'


from Categories

----------------------------------------------
--несколько join
SELECT Orders.CreatedAt, Customers.FirstName, Products.ProductName 
FROM Orders
JOIN Products ON Products.Id = Orders.ProductId
JOIN Customers ON Customers.Id=Orders.CustomerId
WHERE Products.Price < 45000
ORDER BY Customers.FirstName