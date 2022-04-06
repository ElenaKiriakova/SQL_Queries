--Select
select * 
from orders
--------------------------
select OrderId, OrderDate
from orders
----------------------------
--Вывести  фамилию, имя, др сотрудников(Employees)
select LastName, FirstName, BirthDate
from Employees
---------------------------
select LastName + ' ' + FirstName, BirthDate
from Employees
----------------------------
select 1+2,4*4,7/3
----------------------------
--Товары, проданные сотрудником с номером 1
select * 
from orders
where EmployeeID = 1
----------------------------
--Как зовут авторов, живущих в Окланде 'Oakland'
select au_fname + ' ' + au_lname as [Полное имя]
from authors
where city = 'Oakland'
-----------------------------
--strings
select  title,
	    len(title) as Длина,
	    left(title,3), right(title,4),
	    reverse(title),
		upper(title), lower(title),
		SUBSTRING(title, 8 ,2),
		reverse(upper(title)),
		CHARINDEX('aa',title),
		upper(reverse(title)),
		upper(reverse(SUBSTRING(title, 5 ,5)))
from titles
--Достать символы начиная с символа 5 до 10, 
--перевернуть и перевести  вверх регистр
-------------------------------
--Вывести имя, фамилию, номер телефона без кода
select au_fname, au_lname, right(phone, 8)
from authors
-----------------------------
select * from authors
select au_fname, au_lname, substring(phone, 
				CHARINDEX(' ',phone)+1, len(phone))
from authors
---------------------------------
--numbers
select 
		abs(-30),
		square(3),
		sqrt(25),
		rand(),
		CEILING(123.2),
		floor(123.2),
		ROUND(937.512,-4)
------------------------------
--Вернуть целое случайное число в диапозоне от -5 до 5
select round(rand()*10-7,0)
------------------------------
--date
select  GETDATE(),
		SYSDATETIME(),
		day(GETDATE()),
		year(GETDATE()),
		DATEADD(day, 27, GETDATE()),
		DATEADD(day, 270, '2020-01-12'),
		DATEDIFF(day, GETDATE(), '2020-12-03'),
		DATENAME(second, getdate())
---------------------------
--orderby
select * 
from orders
order by Freight desc
-------------------------

select * 
from orders
order by EmployeeID desc, orderdate desc
--------------------------
--отсортировать строчки по стоимости товара по убыванию
select top(10) *, UnitPrice*UnitsInStock as Стоимость
from Products
order by Стоимость desc
--------------------------
--null
select * from titles

select * from titles where price  >20 
select * from titles where price  <20 
select * from titles where price  =20 
select * from titles where price  <> 20
select * from titles where price  is null
select * from titles where price  is not null
----------------------------------
select title + ' ' +isnull(notes, 'no data') from titles
----------------------------------
--Вывести товары, из категории бизнес и с ценой > 10
select * 
from titles
where type = 'business' and price>10
--Вывести товары, из категории бизнес или с ценой > 10
select * 
from titles
where type = 'business' or price>10
--Как зовут покупателей из лондона имеющих факс
select *
from Customers 
where City='London' and fax is not null
order by CustomerID desc
-----------------------------
select distinct country 
from Customers
order by country
-----------------------------
--агрегатные функции
--Найти кол-во стран для покупателей
select count(country) 
from Customers
--Найти кол-во уникальных стран для покупателей
select count(distinct country) 
from Customers
---------------------------
--Найти суммарное кол-во товаров
select * from [Order Details]
select sum(quantity) from [Order Details]
--Посчитать выручку с товара 1
select sum(UnitPrice*Quantity*(1-Discount))
from [Order Details]
where ProductID = 1
------------------------------------
--Cамая дешевая/дорогая цена товара
select min(unitprice) from [Order Details]
select max(unitprice) from [Order Details]
--средняя цена товара
select avg(unitprice) from [Order Details]
-----------------------------------
select *, min(unitprice) from [Order Details]
-----------------------------------
select sum(UnitPrice*Quantity*(1-Discount))
from [Order Details]
where ProductID = 1 or ProductID = 2
-----------------------------------
--Посчитать выручку с каждого из товаров
select * from [Order Details]

select productid, sum(UnitPrice*Quantity*(1-Discount))
from [Order Details]
group by productid
order by productid
----------------------------------
--Найти кол-во покупателей из каждой страны
select * from Customers

select  top(1) with ties  Country, count(CustomerID ) as [quantity of products]
from Customers
group by Country
order by [quantity of products]

select  Country,city, count(CustomerID ) as [quantity of products]
from Customers
group by Country, city
order by Country
-----------------------------------
--having
--Вывести те страны, чьё кол-во больше 5
select   Country, count(CustomerID ) as [quantity of products]
from Customers
group by Country
having count(CustomerID )>5
order by [quantity of products]
-------------------------------------
--вывести те продукты, чья суммарная стоимость больше 10000
select * from [Order Details]

select productid, 
round(
		sum ((unitprice*quantity) *(1-discount)),
		0
	 ) as [Price]

from [Order Details]
group by productid
having sum ((unitprice*quantity) *(1-discount))>10000
order by [Price] desc
--------------------------------------
--Операторы Фильтрации
--Достать книжки из категорий business, mod_cook, psychology
select * from titles

select *
from titles
where [type] = 'business' or [type] = 'mod_cook' or [type] = 'psychology'

select*from titles 
where [type] not in ('business','mod_cook','psychology')

--Достать книжки со стоимостью от 10 до 20
select * from titles
where price >=10 and price <=20

select *
from titles
where price not between 10.00001 and 19.9999

-------------------------------------------
select * from Customers
--Все имена, начинающиеся на ма
select contactname from Customers
where contactname like 'ma%'
--все customerid вида fran + любой 1 символ
select CustomerID from Customers
where CustomerID like 'fran_'
--найти contactname который содержит te
Select* from[dbo].[Customers]
where [ContactName] like '%te%'
--найти contactname который содержит tea или teu
Select* from[dbo].[Customers]
where [ContactName] like '%te[au]%' 
--вывести те postalcode которые начинаются с 12, 
--далее идет буква от a-v,
--далее любая строка
select * from [dbo].[Customers]
where [PostalCode] like '12[a-v]%'
--вывести те postalcode которые начинаются с 12, 
--далее идет любая цифра кроме 3,
--далее любая строка
select * from [dbo].[Customers]
where [PostalCode] like '12[^3]%'



