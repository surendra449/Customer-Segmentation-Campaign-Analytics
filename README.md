# Market Segmentation & Campaign Analytics for a leading Pizza chain in USA

## Objective 1

Create defined bucket groups for store profiles and determine offers most likely to work for each store profile group

### Overview: 
Using the demographic data, determine profiles for stores to be categorized (ie: 1.) rural, high income 2.) metro, low income, etc) into like groupings, each bucket should have similar customer base characteristics (age, income, deliverable addresses in the stores area, etc).  The idea for this is so that when we get a new store’s data it will automatically be labeled with a store profile group and we can suggest offers that have worked best in other stores that have a similar profile.

### Problem/Challenge: 
Making sure the offer recommendations include a mix of offer types: (ie: single pizza offers, bundled offers, specific day sensitive offers)

### Data Resource to Consider: 
Need to consider the national consumer database file to make determinations on the customers with all of the stores to make store profiles.  In addition, you will need to consider the transactional data file to make suggestions on which offers work best for each store profile type.

### Desired Solution: 
Determined store profiles with definitions on each (so we know why a store falls into a certain store profile), recommended coupons for each store profile type (based on previous coupon redemption).

### Method of Delivery: 
The ability to add a new store and have it automatically enter into a profile group and see the recommended offers for that profile.

## Objective 2

Coupon Ordering Likelihood

### Overview: 
Determine based on order history which offers would be the most effective to send to each household. 

### Problem/Challenge: 
Determining which offers would be relevant to run and how many different variations of offers.  

### Data Resource to Consider: 
Need to consider the transactional data and the demographic data.  Transactional data will give an indication on the ordering habits of each household and the frequency in which certain coupons are used.  The demographic data will allow comparison of similar households for recommended coupon selection.

### Desired Solution: 
To have each household tagged with certain offer sets that would be the most beneficial to mail to them.  The offer sets should be based on previous orders and offers previously redeemed by the household and by households that have similar demographic profiles.

### Method of Delivery: 
Scored data and recommended offer sets.

## Objective 3

Overall Scoring of Customers in Each Market Sector

### Overview: 
Score all customers in each market sector* (each market sector should be treated independently of the other market sectors) with likelihood to respond to direct mail in each store (*see legend for what a market sector is at end of document).

### Problem/Challenge: 
The scoring of a customer will have to be fluid with the movement of the address.  For example: if a customer is a Frequent customer and scores high among other frequent customers but then has ordering pattern changes – the address could fall into the At Risk market sector and will need to be rescored based on their likelihood to respond to direct mail compared to the other At Risk market sector addresses. In addition, when scoring each market sector, take into account a minimum of 10 addresses per carrier route and 75 addresses per zip code to stay within postal regulations.

### Data Resource to Consider: 
Need to consider the transactional data and the demographic data for scoring purposes. (i.e.: may want to weed out older customers from mailings who only appear to order when grandchildren are over, identify customers who have a dependent move out in combination with decreasing order frequency.  Also take into account the propensity to respond to direct mail and seasonality of ordering based on in-home date of the mail file)

### Desired Solution: 
To have a model that ranks each address in a market sector against the other addresses in a market sector at the time when the mail file is pulled to select the best customers to mail from the selected market sectors.

### Method of Delivery: 
The ability to run the scoring mechanism at the time of each mail file being pulled based on type of mailing.
