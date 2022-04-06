-- ������� ������� ������ ������ ����������(���)
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
--���-�� ������ � ���� �����������
select count(fax) from Customers
------------------------------
--���-�� ������� � �������
select count(*) from Customers
-------------------------------------
-- ������� ���� ������ ������� � ������ ���������(join) 
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
-- ������� ������� ������� ������ �������� � �����
select * from Employees
select * from orders

select firstname+' ' +lastname as 'fullname', count(orderid)
from Employees as E left join orders as O
on E.EmployeeID = O.EmployeeID and O.ShipCity ='paris'
group by firstname+' ' +lastname
---------------------------------
--���������� �������
--��������� ���-�� ������� � ������ ������ � ������ ���
select * from orders
--������������� ����
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

select '�������', Year(orderdate), count(*) as total
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
--������������
select ROW_NUMBER() OVER 
						( 
							partition by categoryid
							order by unitprice desc
						) as num,
									productname, unitprice, categoryid
								
from products
order by CategoryID, unitprice desc
--������� ������ � �������� �� 11 �� 15
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
--������� ��������
select productname, unitprice,
								lag(unitprice,7) over(order by unitprice),
								lead(unitprice,7) over(order by unitprice)
from Products
order by unitprice
----------------------------------------------
--������� ���������
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

--������������ �����
select productname, unitprice
from Products
order by unitprice 
					offset 2 rows
					fetch next 8 rows only
---------------------------------------------
--������� ��������� ���-�� ������ 
--� ������ ������ ��� ������ ��������� � 2011 ���� ��� ������
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
--�������� ��� ������ � ������
Create database [����� ��������]

create table ����������
(
	������������� nvarchar(20),
	���� nvarchar(20)
)

--create table [��� �����]
--(
--	���� nvarchar(20)
--)


INSERT INTO [���������� �����]
values
('python'),
('sql')




select * from ����������
select * from [���������� �����]


Update ����������
set ���� = ���� + ' 3'
where ���� = 'python'

select * from ����������

delete ����������
where ������������� = 'Ann'
------------------------------
--select * from t

create view Results as
select * from ���������� 
where ������������� = 'jack'

------------------------------
--exists
--����� �����, ������ � ���� ��������� � ���� �����
select * from ����������
select * from [���������� �����]

select *
from [���������� �����]
where exists 
				( 
					select * from ����������
					where ����������.���� = [���������� �����].����
				)
--������� ��������������, ������� �������� ��� ���������� �����

select distinct �1.�������������
from ���������� �1
where not exists (
					select *
					from [���������� �����]
					where not exists 
									( 
										select * from ���������� �2
										where �2.���� = [���������� �����].���� 
											and �1.������������� = �2.�������������
									)
				 )
