--Select
select * 
from orders
--------------------------
select OrderId, OrderDate
from orders
----------------------------
--�������  �������, ���, �� �����������(Employees)
select LastName, FirstName, BirthDate
from Employees
---------------------------
select LastName + ' ' + FirstName, BirthDate
from Employees
----------------------------
select 1+2,4*4,7/3
----------------------------
--������, ��������� ����������� � ������� 1
select * 
from orders
where EmployeeID = 1
----------------------------
--��� ����� �������, ������� � ������� 'Oakland'
select au_fname + ' ' + au_lname as [������ ���]
from authors
where city = 'Oakland'
-----------------------------
--strings
select  title,
	    len(title) as �����,
	    left(title,3), right(title,4),
	    reverse(title),
		upper(title), lower(title),
		SUBSTRING(title, 8 ,2),
		reverse(upper(title)),
		CHARINDEX('aa',title),
		upper(reverse(title)),
		upper(reverse(SUBSTRING(title, 5 ,5)))
from titles
--������� ������� ������� � ������� 5 �� 10, 
--����������� � ���������  ����� �������
-------------------------------
--������� ���, �������, ����� �������� ��� ����
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
--������� ����� ��������� ����� � ��������� �� -5 �� 5
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
--������������� ������� �� ��������� ������ �� ��������
select top(10) *, UnitPrice*UnitsInStock as ���������
from Products
order by ��������� desc
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
--������� ������, �� ��������� ������ � � ����� > 10
select * 
from titles
where type = 'business' and price>10
--������� ������, �� ��������� ������ ��� � ����� > 10
select * 
from titles
where type = 'business' or price>10
--��� ����� ����������� �� ������� ������� ����
select *
from Customers 
where City='London' and fax is not null
order by CustomerID desc
-----------------------------
select distinct country 
from Customers
order by country
-----------------------------
--���������� �������
--����� ���-�� ����� ��� �����������
select count(country) 
from Customers
--����� ���-�� ���������� ����� ��� �����������
select count(distinct country) 
from Customers
---------------------------
--����� ��������� ���-�� �������
select * from [Order Details]
select sum(quantity) from [Order Details]
--��������� ������� � ������ 1
select sum(UnitPrice*Quantity*(1-Discount))
from [Order Details]
where ProductID = 1
------------------------------------
--C���� �������/������� ���� ������
select min(unitprice) from [Order Details]
select max(unitprice) from [Order Details]
--������� ���� ������
select avg(unitprice) from [Order Details]
-----------------------------------
select *, min(unitprice) from [Order Details]
-----------------------------------
select sum(UnitPrice*Quantity*(1-Discount))
from [Order Details]
where ProductID = 1 or ProductID = 2
-----------------------------------
--��������� ������� � ������� �� �������
select * from [Order Details]

select productid, sum(UnitPrice*Quantity*(1-Discount))
from [Order Details]
group by productid
order by productid
----------------------------------
--����� ���-�� ����������� �� ������ ������
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
--������� �� ������, ��� ���-�� ������ 5
select   Country, count(CustomerID ) as [quantity of products]
from Customers
group by Country
having count(CustomerID )>5
order by [quantity of products]
-------------------------------------
--������� �� ��������, ��� ��������� ��������� ������ 10000
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
--��������� ����������
--������� ������ �� ��������� business, mod_cook, psychology
select * from titles

select *
from titles
where [type] = 'business' or [type] = 'mod_cook' or [type] = 'psychology'

select*from titles 
where [type] not in ('business','mod_cook','psychology')

--������� ������ �� ���������� �� 10 �� 20
select * from titles
where price >=10 and price <=20

select *
from titles
where price not between 10.00001 and 19.9999

-------------------------------------------
select * from Customers
--��� �����, ������������ �� ��
select contactname from Customers
where contactname like 'ma%'
--��� customerid ���� fran + ����� 1 ������
select CustomerID from Customers
where CustomerID like 'fran_'
--����� contactname ������� �������� te
Select* from[dbo].[Customers]
where [ContactName] like '%te%'
--����� contactname ������� �������� tea ��� teu
Select* from[dbo].[Customers]
where [ContactName] like '%te[au]%' 
--������� �� postalcode ������� ���������� � 12, 
--����� ���� ����� �� a-v,
--����� ����� ������
select * from [dbo].[Customers]
where [PostalCode] like '12[a-v]%'
--������� �� postalcode ������� ���������� � 12, 
--����� ���� ����� ����� ����� 3,
--����� ����� ������
select * from [dbo].[Customers]
where [PostalCode] like '12[^3]%'



