create view view_track_details as
select 
    track.trackid, 
    track.name as track_name,  
    album.title as album_title, 
    artist.name as artist_name,  
    track.unitprice
from track
join album on track.albumid = album.albumid
join artist on album.artistid = artist.artistid
where track.unitprice > 0.99;

select * from view_track_details;

create view View_Customer_Invoice as
select 
    Customer.CustomerId, 
    concat(Customer.LastName, ' ', Customer.FirstName) as FullName, 
    Customer.Email, 
    sum(Invoice.Total) as Total_Spending, 
    Employee.LastName
from Customer
join Invoice on Customer.CustomerId = Invoice.CustomerId
join Employee on Customer.SupportRepId = Employee.EmployeeId
group by Customer.CustomerId, Customer.LastName, Customer.FirstName, Customer.Email, Employee.LastName
having Total_Spending > 50;

select * from View_Customer_Invoice;

create view view_top_selling_tracks as
select 
    track.trackid, 
    track.name as track_name,  
    genre.name as genre_name,  
    sum(invoiceline.quantity) as total_sales
from track
join invoiceline on track.trackid = invoiceline.trackid
join genre on track.genreid = genre.genreid
group by track.trackid, track.name, genre.name
having total_sales > 10;


select * from view_top_selling_tracks;

create index idx_Track_Name on Track(Name);

select * from Track where Name like '%Love%';

explain select * from Track where Name like '%Love%';

create index idx_Invoice_Total on Invoice(Total);

select * from Invoice where Total between 20 and 100;

explain select * from Invoice where Total between 20 and 100;
delimiter &&
create procedure GetCustomerSpending(in customer_id int, out total_spent decimal(10,2))
begin
    select sum(total_spending) into total_spent
    from view_customer_invoice
    where customerid = customer_id;
end &&
delimiter ;
drop procedure GetCustomerSpending;
call GetCustomerSpending(1, @total_spent);
select @total_spent;
delimiter &&
create procedure SearchTrackByKeyword(in p_keyword varchar(255))
begin
    select * 
    from track
    where name like concat('%', p_keyword, '%');
end &&
delimiter ;
call SearchTrackByKeyword('lo');
delimiter &&
create procedure GetTopSellingTracks(in p_min_sales int, in p_max_sales int)
begin
    select * 
    from view_top_selling_tracks
    where total_sales between p_min_sales and p_max_sales;
end &&
delimiter ;
call GetTopSellingTracks(10, 50);
drop view view_track_details;
drop view  view_customer_invoice;
drop view  view_top_selling_tracks;

drop index idx_track_name on track;
drop index idx_invoice_total on invoice;

drop procedure GetCustomerSpending;
drop procedure SearchTrackByKeyword;
drop procedure GetTopSellingTracks;



