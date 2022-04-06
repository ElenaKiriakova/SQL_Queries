-- Сколько заказов сделал каждый покупатель(ФИО)
select * from customers
select * from orders
--subquery
select contactname, 
	(
		select count(orderid)
		from orders
		where orders.CustomerID = customers.CustomerID
	) as quantity
from customers
order by quantity
--wrong join
select contactname, count(orderid) as quantity
from customers join orders
on customers.CustomerID = Orders.CustomerID
group by contactname
order by quantity
--left join
select contactname, count(orderid) as quantity
from customers left join orders
on customers.CustomerID = Orders.CustomerID
group by contactname
order by quantity
--right join
select contactname, count(orderid) as quantity
from  orders right join customers
on customers.CustomerID = Orders.CustomerID
group by contactname
order by quantity
--full join
select contactname, count(orderid) as quantity
from  orders full join customers
on customers.CustomerID = Orders.CustomerID
group by contactname
order by quantity
------------------------------------
select *
from customers left join orders
on customers.CustomerID = Orders.CustomerID
order by  ContactName
------------------------------------
select contactname, count(orderid) as quantity
from customers left join orders
on customers.CustomerID = Orders.CustomerID
group by contactname
order by quantity
----------------------------------------
--count
select * from Customers
--кол-во факсов у всех покупателей
select count(fax) from Customers
------------------------------
--кол-во строчек в таблице
select count(*) from Customers
-------------------------------------
-- сколько штук товара продано в каждой категории(join) 
select * from Categories
select * from Products
select * from [Order Details]

select CategoryName, sum(quantity) 
from Categories join Products 
on Categories.CategoryID = Products.CategoryID
join [Order Details]
on [Order Details].ProductID = Products.ProductID
group by CategoryName
order by CategoryName
----------------------------------------
-- Сколько заказов оформил каждый продавец в Париж
select * from Employees
select * from orders

select firstname+' ' +lastname as 'fullname', count(orderid)
from Employees as E left join orders as O
on E.EmployeeID = O.EmployeeID and O.ShipCity ='paris'
group by firstname+' ' +lastname
---------------------------------
--Построение отчетов
--Посчитать кол-во заказов в каждой стране в каждый год
select * from orders
--Промежуточный итог
select ShipCountry, Year(orderdate) as [year],count(*) as total
from orders
group by ShipCountry, Year(orderdate)

union all

select ShipCountry, null, count(*) as total
from orders
group by ShipCountry

union all

select null, null, count(*) as total
from orders

union all

select 'подитог', Year(orderdate), count(*) as total
from orders
group by Year(orderdate)

order by ShipCountry desc, Year(orderdate) desc
-----------------------------------------
--grouping sets
select ShipCountry, Year(orderdate) as [year],count(*) as total
from orders
group by GROUPING SETS(
							(ShipCountry, Year(orderdate)),
							(ShipCountry),
							(Year(orderdate)),
							()
					  )
order by ShipCountry desc, Year(orderdate) desc
------------------------------------------
--cube
select ShipCountry, Year(orderdate) as [year], count(*) as total
from orders
group by ShipCountry, Year(orderdate) with cube
order by ShipCountry desc, Year(orderdate) desc
-------------------------------------------
--rollup
select ShipCountry, Year(orderdate) as [year], count(*) as total
from orders
group by ShipCountry, Year(orderdate) with rollup
order by ShipCountry desc, Year(orderdate) desc
-------------------------------------------
--Ранжирование
select ROW_NUMBER() OVER 
						( 
							partition by categoryid
							order by unitprice desc
						) as num,
									productname, unitprice, categoryid
								
from products
order by CategoryID, unitprice desc
--Вывести товары с номерами от 11 до 15
select productname, num
from
(
select ROW_NUMBER() OVER 
						( 
							partition by categoryid
							order by unitprice desc
						) as num,
									productname, unitprice, categoryid
								
from products
) as t
where num between 11 and 15
order by CategoryID, unitprice desc

----------------------------------------------
--функции смещения
select productname, unitprice,
								lag(unitprice,7) over(order by unitprice),
								lead(unitprice,7) over(order by unitprice)
from Products
order by unitprice
----------------------------------------------
--оконная агрегация
select productname, unitprice,
								sum(unitprice) over(order by unitprice),
								avg(unitprice) over(
														order by unitprice
														rows between 
															3 preceding
															and 
															3 following
												   )
from Products
order by unitprice
---------------------------------------------

--Постраничный вывод
select productname, unitprice
from Products
order by unitprice 
					offset 2 rows
					fetch next 8 rows only
---------------------------------------------
--Вывести суммарные кол-во продаж 
--в каждом месяце для каждой профессии в 2011 году для женщин
select * from FactInternetSales
select * from DimCustomer
select * from DimDate

select englishmonthname, englishOccupation, sum(SalesAmount)as amount
from FactInternetSales as S
		join DimCustomer as C
		on S.CustomerKey = C.CustomerKey
		join DimDate D
		on S.OrderDateKey = D.DateKey
where D.CalendarYear =2011 and C.Gender = 'F'
group by englishmonthname, englishOccupation
order by englishmonthname, englishOccupation
--------------------------------------------------
--Создание баз данных и таблиц
Create database [Центр обучения]

create table Расписание
(
	Преподаватель nvarchar(20),
	Курс nvarchar(20)
)

--create table [Инт курсы]
--(
--	курс nvarchar(20)
--)


INSERT INTO [Интересные курсы]
values
('python'),
('sql')




select * from Расписание
select * from [Интересные курсы]


Update Расписание
set Курс = курс + ' 3'
where Курс = 'python'

select * from Расписание

delete Расписание
where Преподаватель = 'Ann'
------------------------------
--select * from t

create view Results as
select * from Расписание 
where Преподаватель = 'jack'

------------------------------
--exists
--Найти курсы, котрые я могу послушать в этой школе
select * from Расписание
select * from [Интересные курсы]

select *
from [Интересные курсы]
where exists 
				( 
					select * from Расписание
					where Расписание.Курс = [Интересные курсы].Курс
				)
--Вывести преподавателей, которые читающих все интересные курсы

select distinct Р1.Преподаватель
from Расписание Р1
where not exists (
					select *
					from [Интересные курсы]
					where not exists 
									( 
										select * from Расписание Р2
										where Р2.Курс = [Интересные курсы].Курс 
											and Р1.Преподаватель = Р2.Преподаватель
									)
				 )
