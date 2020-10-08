use classicmodels;

# Number of customers per city (office)
select e.firstName,o.city, o.country ,count(c.customerNumber) as Number_of_customers
from customers c
join employees e on e.employeeNumber = c.salesRepEmployeeNumber
join offices o on e.officeCode=o.officeCode
group by firstName,o.city;


# What is the average of sales from different countries for each year, starting from 2003
select  o.city, o.country, e.firstName, sum(p.amount) as Amount ,year(p.paymentDate) as Calendar_year
from customers c
join employees e on  e.employeeNumber = c.salesRepEmployeeNumber
join payments p on c.customerNumber=p.customerNumber 
join offices o on  e.officeCode=o.officeCode
group by o.city, o.country, e.firstName, Calendar_year;

# who's the top sale representative for 2005
 select  e.firstName, o.city, round(avg(p.amount),2)
 from payments p join customers c  
 on p.customerNumber=c.customerNumber
 join employees e on e.employeeNumber = c.salesRepEmployeeNumber
 join offices  o on e.officeCode= o.officeCode
 where year(p.paymentDate)=2005
 group by e.firstName,o.city;
 
 
 # What is the average payment per customer within a certain credit limit range (for example: platinum = credit limit>100000)
drop procedure if exists filter_palatinum;
delimiter $$
create procedure filter_palatinum(IN min_param float, IN max_param float)
begin
select c.customerName, e.firstName, round(avg(p.amount),2) as Avg_amount
from payments p join customers c on c.customerNumber =p.customerNumber
join employees e on e.employeeNumber = c.salesRepEmployeeNumber
where c.creditLimit between min_param and max_param
group by c.customerName;
end $$

DELIMITER ;
call filter_palatinum(100000,200000);

