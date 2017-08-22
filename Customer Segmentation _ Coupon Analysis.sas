/* Objective 2 & 3 */

/* Customer profile segmentation */

proc means data= Q.demographic_transaction_tb NOPRINT nway MISSING;
var OrderAmount BottleAmount PieCt ToppingCount AllBreadCount BreadOrd ChickenOrd DessertCount DrinkOrd PastaCount SandwichCount purpower_income_val numberofadults numberofchildren heavy_internet_user coupon;
class DomCustId;
output 
	out=Cust_Behavior(rename=(freq=no_of_trans)) 
	mean(OrderAmount)=mOrderAmount
	mean(BottleAmount)=mBottleAmount
	mean(PieCt)=mPieCt
	mean(ToppingCount)=mToppingCount
	mean(AllBreadCount)=mAllBreadCount2
	mean(BreadOrd)=mBreadOrd
	mean(ChickenOrd)=mChickenOrd
	mean(DessertCount)=mDessertCount
	mean(DrinkOrd)=mDrinkOrd
	mean(PastaCount)=mPastaCount
	mean(SandwichCount)=mSandwichCount
	mean(purpower_income_val)=mpurpowerIncomeVal
	mean(numberofadults)=mnumberofadults
	mean(numberofchildren)=mnumberofchildren
	mean(heavy_internet_user)=mheavy_internet_user
	mean(response)=mresponse
	mean(coupon)=mcoupon;
run;

proc sort data=Cust_Behavior;
by DomCustId;
run;

proc stdize data=Cust_Behavior out=Cust_Behav_Std method=std OPREFIX=O SPREFIX=S;
var no_of_trans mOrderAmount mBottleAmount mPieCt mToppingCount mAllBreadCount2 mBreadOrd mChickenOrd mDessertCount mDrinkOrd mPastaCount mSandwichCount mpurpowerIncomeVal mnumberofadults mnumberofchildren mheavy_internet_user mresponse mcoupon;
run;

proc factor data=Cust_Behav_Std out=Cust_factanaly nfactors=12 method=PRIN; 
var smOrderAmount
	smBottleAmount
	/sno_of_trans/
	smPieCt
	smToppingCount
	/*smAllBreadCount2
	smBreadOrd
	smChickenOrd*/
	smDessertCount
	smDrinkOrd
	smPastaCount
	smSandwichCount
	smpurpowerIncomeVal
	smnumberofadults
	smnumberofchildren
	smheavy_internet_user
             smresponse
	smcoupon;
run;

proc fastclus data=Cust_factanaly out=Cust_seg maxclusters=6 maxiter=100;
id DomCustId;
var factor1 factor2 factor3 factor4 factor5 factor6 factor7 factor8 factor9;
run;

proc means data= Cust_seg noprint nway MISSING;
class Cluster;
output 
	out=Cust_seg_Means(rename=(freq=No_Of_Customers)) 
	/mean(ono_of_trans)=cmNo_of_trans/
	mean(omOrderAmount)=cmOrderAmount
	mean(omBottleAmount)=cmBottleAmount
	mean(omPieCt)=cmPieCt
	mean(omToppingCount)=cmToppingCount
	/*mean(omAllBreadCount2)=cmAllBreadCount2
	mean(omBreadOrd)=cmBreadOrd
	mean(omChickenOrd)=cmChickenOrd*/
	mean(omDessertCount)=cmDessertCount
	mean(omDrinkOrd)=cmDrinkOrd
	mean(omPastaCount)=cmPastaCount
	mean(omSandwichCount)=cmSandwichCount
	mean(ompurpowerIncomeVal)=cmpurpowerIncomeVal
	mean(omnumberofadults)=cmnumberofadults
	mean(omnumberofchildren)=cmnumberofchildren
	mean(omheavy_internet_user)=cmheavy_internet_user
	mean(omresponse)=cmresponse
	mean(omcoupon)=cmcoupon;
run;


data Cust_seg;
merge demographic_transaction_tb Cust_seg;
by DomcustId;
run;

proc sql;
create table Cust_seg_Cpn as
select cluster,coupondesc,count(coupondesc) as cnt
from Cust_seg
group by cluster, coupondesc;
run;

proc sort data= Cust_seg_Cpn;
by descending cluster descending cnt ;
run;

proc sql;
create table Cust_seg_Cpn2 as
select coupondesc,sum(case when cluster=1 then cnt else 0 end)as cluster1,
	sum(case when cluster=2 then cnt else 0 end)as cluster2,
	sum(case when cluster=3 then cnt else 0 end)as cluster3,
	sum(case when cluster=4 then cnt else 0 end)as cluster4,
	sum(case when cluster=5 then cnt else 0 end)as cluster5,
	sum(case when cluster=6 then cnt else 0 end)as cluster6
from Cust_seg
group by coupondesc;
run;

proc sort data= Cust_seg_Cpn2;
by descending cluster1 cluster2 cluster3 cluster4 cluster4 cluster5 cluster6;
run;

data Cust_seg;
set Cust_seg;
if CustType in ("At Risk", "At Risk NOL", "At Risk OL") then CustType='CustRisk';
if CustType in ("Frequent", "Frequent NO", "Frequent NOL", "Frequent OL") then CustType='CustFrequent';
if CustType in ("High Risk", "High Risk N", "High Risk NOL", "High Risk O", "High Risk OL") then CustType='CustHighRisk';
if CustType in ("Lost NOL", "Lost OL") then CustType='CustLost';
if CustType in ("MVP NOL", "MVP OL") then CustType='CustMVP';
if CustType in ("Max Risk NO", "Max Risk NOL", "Max Risk OL") then CustType='CustMaxRisk';
if CustType in ("New", "New NOL", "New OL") then CustType='CustNEW';
if CustType in ("Rejuvenated", "Rejuvenated NOL", "Rejuvenated OL") then CustType='CustRejuvenated';
run;


/* Predicting probabilities for coupon ordering likelihood */

ods graphics on;
proc logistic data=Cust_seg descending plots=effect;
class SideOrd / param=ref;
model coupon =  orderamount ChickenOrd  DessertCount Drink2ltrCount PastaCount PieCt SandwichCount SideOrd/ rsquare; 
output out= Cust_Cpn_Usage predicted=est_response;
run;
ods graphics off;

proc rank data= Cust_Cpn_Usage groups=10 descending out= Cust_Cpn_Usage_pred _tb;
var est_response;
ranks decile;
run;

proc sort data= Cust_Cpn_Usage_pred _tb;
by descending est_response;
run;

proc sql;
create table Cust_seg_analy as
select CustType,Cluster,count(DomcustID)as Cust_cnt,avg(est_response) as avg_est_resp,
				avg(Custamount) as avg_orderamt,
				avg(chickenord) as avg_chickenord,
				avg(Dessertcount) as avg_desert,
				avg(Drink2ltrcount) as avg_drink,
				avg(PastaCount) as avg_pasta,
				avg(piect) as avg_piect,
				avg(sandwichcount) as avg_sandwich,
				avg(mindatedifference) as avg_mindatediff
from Cust_Cpn_Usage_pred _tb
where CustType in ('CustRisk','CustFrequent','CustHighRisk','CustLost','CustMVP','CustMaxRisk','CustNEW','CustRejuvenated')
and decile in (0,1,2,3,4)
group by CustType,Cluster;
run;


/* Predicting probabilities for purchasing within 4 weeks of receiving a mailer */

proc logistic data=Cust_seg1 descending plots=effect;
class custType Mailed / param=ref;
model Purchase = CustType Mailed Transactional_Segment Avg_Tot_Items Number_of_Adults Number_of_Children/ rsquare;
output out=Cust_Mailresponse predicted=est_response;
run;
