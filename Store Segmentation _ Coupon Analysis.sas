/* Objective 1 */ 

/* Demographics & Transactions data */

libname Q '';run;
DATA Q.demographic_transaction_tb;
set EXP0.Merged1d EXP0.Merged2d EXP0.Merged3d EXP0.merged4d;
   if OrderMethodDesc eq '' then  OrderMethodDesc ='NONE';
   if DrinkOrd=. then DrinkOrd=0;
   if mailed=. then mailed=0; 
   if control=. then control=0;
   if Creative ne '' then dcreative=1;
   if Creative eq '' then Creative = 'NONE';
   if orderamount="." then delete;
run;

proc sort data=Q.demographic_transaction_tb;
by DomcustId;
run;

data Q.demographic_transaction_tb;
set Q.demographic_transaction_tb;
if income = "A" then income_val=3000;
if income = "B" then income_val=8500;
if income = "C" then income_val=13500;
if income = "D" then income_val=18500;
if income = "E" then income_val=23500;
if income = "F" then income_val=28500;
if income = "G" then income_val=33500;
if income = "H" then income_val=38500;
if income = "I" then income_val=43500;
if income = "J" then income_val=48500;
if income = "K" then income_val=53500;
if income = "L" then income_val=58500;
if income = "M" then income_val=63500;
if income = "N" then income_val=68500;
if income = "O" then income_val=73500;
if income = "P" then income_val=78500;
if income = "Q" then income_val=83500;
if income = "R" then income_val=88500;
if income = "S" then income_val=93500;
if income = "T" then income_val=98500;
if income = "U" then income_val=103500;
if income = "V" then income_val=108500;
if income = "W" then income_val=113500;
if income = "X" then income_val=118500;
if income = "Y" then income_val=123500;
if income = "Z" then income_val=128500;
if income = 1 then income_val=133500;
if income = 2 then income_val=138500;
if income = 3 then income_val=143500;
if income = 4 then income_val=148500;
if purchasingpowerincome= "A" then purpower_income_val=3000;
if purchasingpowerincome = "B" then purpower_income_val=8500;
if purchasingpowerincome = "C" then purpower_income_val=13500;
if purchasingpowerincome = "D" then purpower_income_val=18500;
if purchasingpowerincome = "E" then purpower_income_val=23500;
if purchasingpowerincome = "F" then purpower_income_val=28500;
if purchasingpowerincome = "G" then purpower_income_val=33500;
if purchasingpowerincome = "H" then purpower_income_val=38500;
if purchasingpowerincome = "I" then purpower_income_val=43500;
if purchasingpowerincome = "J" then purpower_income_val=48500;
if purchasingpowerincome = "K" then purpower_income_val=53500;
if purchasingpowerincome = "L" then purpower_income_val=58500;
if purchasingpowerincome = "M" then purpower_income_val=63500;
if purchasingpowerincome = "N" then purpower_income_val=68500;
if purchasingpowerincome = "O" then purpower_income_val=73500;
if purchasingpowerincome = "P" then purpower_income_val=78500;
if purchasingpowerincome = "Q" then purpower_income_val=83500;
if purchasingpowerincome = "R" then purpower_income_val=88500;
if purchasingpowerincome = "S" then purpower_income_val=93500;
if purchasingpowerincome = "T" then purpower_income_val=98500;
if purchasingpowerincome = "U" then purpower_income_val=103500;
if purchasingpowerincome = "V" then purpower_income_val=108500;
if purchasingpowerincome = "W" then purpower_income_val=113500;
if purchasingpowerincome = "X" then purpower_income_val=118500;
if purchasingpowerincome = "Y" then purpower_income_val=123500;
if purchasingpowerincome = "Z" then purpower_income_val=128500;
if purchasingpowerincome = 1 then purpower_income_val=133500;
if purchasingpowerincome = 2 then purpower_income_val=138500;
if purchasingpowerincome = 3 then purpower_income_val=143500;
if purchasingpowerincome = 4 then purpower_income_val=148500;
if coupondesc="." or coupondesc="" then coupon=0; else coupon=1;
if orderamount>100 then delete;
if domcustid=0 then delete;
run;

/* Store profile segmentation */

proc sql;
create table demographic_transaction_tb as 
select Storenum,avg(purpower_income_val) as purpower_income_val ,
       sum(orderamount) as tot_orderamt,
	   sum(bottleamount) as tot_bottleamount,
	   avg(numberofchildren) as noofchildren,
	   avg(heavy_internet_user) as heavyinternet,
	   avg(numberofadults)as numberofadults,
	   avg(coupon) as coupon,
	   count(DomCustId) as DomCustIdcount,
	   sum(case when CustType in ("Lost","Lost NOL","Lost OL") then 1 else 0 end) as churned_customers,
	   sum(case when CustType in ("Lost","At Risk NOL","High Risk NOL","Max Risk NOL","Lost","Lost NOL") then 1 else 0 end) as online_churned_custome
from Q.demographic_transaction_tb
group by Storenum;
run;

proc stdize data= demographic_transaction_tb out= demographic_transaction_Std method=std OPREFIX=O SPREFIX=S;
var purpower_income_val tot_orderamt tot_bottleamount noofchildren heavyinternet coupon DomCustIdcount churned_customers online_churned_customers;
run;


proc factor data= demographic_transaction_Std out=store_factanaly nfactors=2 method=PRIN;
var purpower_income_val tot_orderamt  noofchildren heavyinternet  ;
run;

proc fastclus data=store_factanaly out=store_seg maxclusters=5 maxiter=100;
var factor1 factor2;
run;

proc sql; 
create table store_seg _analy as 
select cluster,avg(purpower_income_val)as purpower_income_val,
	avg(tot_orderamt)as tot_orderamt,
	avg(heavyinternet) as heavyinternet ,
	avg(noofchildren) as noofchildren,
	sum(DomCustIdcount)as Domcustcount 
from  store_seg
group by cluster;
run;


proc sql;
create table store_seg as 
select a.*,b.cluster from demographic_transaction_tb a
left join store_seg b
on a.StoreNum = b.StoreNum;
run;
proc sql;
create table store_seg_cpn as
select cluster,coupondesc,count(coupondesc) as cnt
from store_seg
group by cluster, coupondesc;
run;

proc sort data= store_seg_cpn;
by descending cluster descending cnt ;
run;

proc sql;
create table store_seg_cpn2 as
select coupondesc,sum(case when cluster=1 then cnt else 0 end)as cluster1,
	sum(case when cluster=2 then cnt else 0 end)as cluster2,
	sum(case when cluster=3 then cnt else 0 end)as cluster3,
	sum(case when cluster=4 then cnt else 0 end)as cluster4,
	sum(case when cluster=5 then cnt else 0 end)as cluster5,
	sum(case when cluster=6 then cnt else 0 end)as cluster6
from store_seg
group by coupondesc;
run;

proc sort data= Cust_seg_Cpn2;
by descending cluster1 cluster2 cluster3 cluster4 cluster4 cluster5 cluster6;
run;


proc sql;
create table store_seg as
select store_seg.*, case when CouponDesc like 'Franchise%' then 1 
			when CouponDesc like 'MIX%' then 2
			when CouponDesc eq '' then 4
			else 3 end as CouponType	
from store_seg;
run;

data store_seg;
set store_seg;
year=year(DateOfOrder);
Month=Month(DateOfOrder);

proc sql;
create table store_seg_analy1 as
select cluster,year,Month, 
	count(case when CustType in ('Lost OL','Lost NOL','Lost') then 1 end)/Count(1) AS ChurnedRate,
	count(case when CustType in ('New Customer') then 1 end)/Count(1) as New_Customer_Rate,
	count(case when response=1 then 1 end)/Count(1) as ResponseRate, 
	count(case when OrderType='WEB' then 1 end)/count(1) as OnlineTran, 
	count(case when OrderType in ('PHN','WIN') then 1 end)/count(1) as OfflineTran
from store_seg
group by cluster,year,Month;
run;



