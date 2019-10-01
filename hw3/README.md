## Ryan Inghilterra  -   Cats  - Index Milestone 3 Homework

**Data Used**

$ python catsRandomGenerator.py -number_of_users 10000 -number_of_videos 10000 -number_of_friendships 100000 -number_of_watched_videos 100000 -number_of_watched_videos 100000 -number_of_likes 100000 -out cats_test_data.sql    
output file: cats_test_data.sql     
create tables? Y    
number of users (rows) generated: 10000     
number of videos: 10000    
number of friendships: 100000   
number of watched videos: 100000   
number of likes: 100000   

**Query 1:**   
**Performance with no index:**   
Limit  (cost=9277.83..9278.03 rows=10 width=12) (actual time=88.901..88.905 rows=10 loops=1)

**added Indexes:**    
CREATE INDEX q1_1 ON cats.likes(user_id);   
CREATE INDEX q1_2 ON cats.watch(user_id);   

**Performance with added Indexes:**   
Limit  (cost=5585.30..5585.50 rows=10 width=12) (actual time=70.159..70.162 rows=10 loops=1)

**Improvement in performance when adding indexes for query 1!**
This is due to the "liked" and "watched"  CTEs in my query 1, which have user_id in the where clause. By adding indexes on the user_id for these tables, that gets rid of a full sequential scan for these CTE's and replaces with
a bitmap index scan.


**Query 2:**   
**Performance with no Index:**   
Limit  (cost=9845.71..9845.91 rows=10 width=12) (actual time=51.169..51.173 rows=10 loops=1)

**added Indexes:**   
CREATE INDEX q2_1 ON cats.likes(user_id);   
CREATE INDEX q2_2 ON cats.watch(user_id);   
CREATE INDEX q2_3 ON cats.friend(user_id);   

**Performance with added Indexes:**   
Limit  (cost=1770.39..1770.59 rows=10 width=12) (actual time=11.801..11.807 rows=10 loops=1)

**Improvement in performance when adding indexes for query 2!**    
This is due to the "liked" and "watched"  CTEs in my query 2, which have user_id in the where clause. By adding indexes on the user_id for these tables, that gets rid of a full sequential scan for these CTE's and replaces with
a bitmap index scan for them. Then for the flikes CTE, the index on friend(user_id) replaces a seq. scan with an index lookup since in where clause we have a "friends.user_id" check




**Query 3:**   
**Performance with no index:**    
Limit  (cost=10637.13..10637.33 rows=10 width=12) (actual time=68.641..68.645 rows=10 loops=1)

**added Indexes:**   
CREATE INDEX q3_1 ON cats.likes(user_id);    
CREATE INDEX q3_2 ON cats.watch(user_id);    
CREATE INDEX q3_3 ON cats.friend(user_id);    

**Performance with added Indexes:**    
Limit  (cost=3952.42..3952.62 rows=10 width=12) (actual time=38.342..38.348 rows=10 loops=1)

**Improvement in performance when adding indexes for query 3!**  
This is due to the "liked" and "watched"  CTEs in my query 3, which have user_id in the where clause. By adding indexes on the user_id for these tables, that gets rid of a full sequential scan for these CTE's and replaces with
a bitmap index scan for them. Then for the flikes CTE, the index on friend(user_id) replaces a seq. scan with an index lookup since in where clause we have a "friends.user_id" check.    

**Query 4:**    
**Performance with no index:**  
Limit  (cost=9234.76..9234.96 rows=10 width=12) (actual time=64.159..64.165 rows=10 loops=1)

**added Indexes:**   
CREATE INDEX q4_1 ON cats.likes(user_id);   
CREATE INDEX q4_2 ON cats.watch(user_id);   
CREATE INDEX q4_3 ON cats.likes(video_id);   

**Performance with added Indexes:**    
Limit  (cost=3937.46..3937.66 rows=10 width=12) (actual time=33.947..33.950 rows=10 loops=1)

**Improvement in performance when adding indexes for query 4!**   
This is due to the "liked" and "watched"  CTEs in my query 4, which have user_id in the where clause. By adding indexes on the user_id for these tables, that gets rid of a full sequential scan for these CTE's and replaces with
a bitmap index scan for them. Then the user_liked CTE has a like table video_id check in the "where" clause so an index on the the likes.video_id column will replace a sequential scan with an index lookup and improve performance     


**Query 5:**   
**Performance with no index:**   
Limit  (cost=26529342494903.96..26529342494903.98 rows=10 width=14) (actual time=744537.196..744537.197 rows=10 loops=1)

-Wow look at that cost! The way I wrote my query 5 for milestone2 was obviously extremely inefficient, :( 

no real improvement in performance for query 5 when adding indexes (most likely due to CROSS JOINS used in query







**Additional Notes**

Postgres automatically add primary key as index on table creation

Big improvements were seen on all queries except question 5 for Cats when adding indexes vs only 1 query for my sales queries. The primary reason is because I used CROSS JOIN in my sales queries where I did not use CROSS JOIN in my cats queries (except for q5 on Cats)..



## Ryan Inghilterra  -   Sales  - Index Milestone 3 Homework  

**Data Used**    

$ python datacubeRandomGenerator.py -create_tables Y -number_of_customers 10000 -number_of_categories 100 -number_of_sales 1000000 -out sales_test_data.sql   
output file: sales_test_data.sql         
create tables? Y    
number of customers (rows) generated: 10000    
number of categories: 100    
number of products: 100   
number of sales: 1000000   

**Query 1:**   
**Performance with no index: **   
Hash Right Join  (cost=19356.82..19707.43 rows=10000 width=44) (actual time=330.589..337.661 rows=10000 loops=1)

No improvement with indexes

**Query 2:**     
**Performance with no Index:**    
Hash Right Join  (cost=22332.15..22335.16 rows=540 width=158) (actual time=293.852..294.014 rows=50 loops=1)

No improvement with indexes

**Query 3:**    
**Performance with no index:**   
Sort  (cost=12606.84..12607.09 rows=98 width=48) (actual time=34.935..34.939 rows=58 loops=1)

**added Index:**    
CREATE INDEX q3_index on sales.sale(customer_id);

**Performance with added Index:**   
Sort  (cost=380.65..380.90 rows=98 width=48) (actual time=0.382..0.386 rows=58 loops=1)

**Big Improvement performance when adding index for query 3!** 
This is due to the sales.customer_id column being referenced in the where clause of q3. By adding an index on that column we get rid of an expensive 'Filter' of the nested loop of the group aggregate in the query plan and
replaces it with a bitmap index scan within the nested loop of the query plan which is way less expensive! 



**Query 4:**   
**Performance with no index:**   
Sort  (cost=14248303.49..14310803.49 rows=25000000 width=284) (actual time=7844.793..7985.136 rows=1000000 loops=1)

No improvement with indexes



**Query 5:**   
**Performance with no index:**   
Merge Left Join  (cost=159980.68..161330.68 rows=54000 width=284) (actual time=2907.188..2911.173 rows=5000 loops=1)

No improvement with indexes 

**Query 6:**    
**Performance with no index:**   
CTE Scan on t3  (cost=335482.83..335614.59 rows=6588 width=48) (actual time=2736.077..3764.308 rows=400 loops=1)

No improvement with indexes



**Additional Notes**

Queries 4,5 and 6 use cross joins (cartesian products) so that could be the main reason indices did not help for them. If those cross joins were replaced with outer joins, then I would suspect that indexes like sale (product_id, customer_id) might help.

Even when trying to add indices the solution queries given to us , I did not see any real improvements using indices other than Q3. The solution queries also had cross joins. (results consistent with my query results)

Looking at the query plans, it is confirmed that when adding indices, the plans do not change at all and neither does the COST.

Postgres automatically add primary key as index on table creation


**Note: The indexes are consolidated in the index sql files of this repo, that way there are no duplicate indexes.**  


