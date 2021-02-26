/*
Lab 1 report <Phillip_Hölscher phiho267>
*/

/* All non code should be within SQL-comments like this */ 


/*
Drop all user created tables that have been created when solving the lab
*/

DROP TABLE IF EXISTS custom_table CASCADE;


/* Have the source scripts in the file so it is easy to recreate!*/

/*
SOURCE company_schema.sql;
SOURCE company_data.sql;
*/

source /home/phiho267/Desktop/company_schema.sql;
source /home/phiho267/Desktop/company_data.sql;

/*
1) List all employees, i.e. all tuples in the jbemployee relation.
*/

SELECT * 
FROM jbemployee;

/*
+------+--------------------+--------+---------+-----------+-----------+
| id   | name               | salary | manager | birthyear | startyear |
+------+--------------------+--------+---------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |     199 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |    NULL |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |     199 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |     199 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |     199 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |     199 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      32 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      26 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |     199 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |     199 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |     199 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |     199 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |    NULL |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      10 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |     129 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      26 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |     129 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      33 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      13 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |     129 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      55 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      26 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      32 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      55 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      33 |      1944 |      1959 |
+------+--------------------+--------+---------+-----------+-----------+
25 rows in set (0.00 sec)


*/


/*
2) List the name of all departments in alphabetical order. 
Note: by "name"" we mean the name attribute for all tuples in the jbdept relation.
*/

SELECT name
FROM jbdept 
ORDER BY name ASC;

/*
+------------------+
| name             |
+------------------+
| Bargain          |
| Book             |
| Candy            |
| Children's       |
| Children's       |
| Furniture        |
| Giftwrap         |
| Jewelry          |
| Junior Miss      |
| Junior's         |
| Linens           |
| Major Appliances |
| Men's            |
| Sportswear       |
| Stationary       |
| Toys             |
| Women's          |
| Women's          |
| Women's          |
+------------------+
19 rows in set (0.00 sec)

*/

/*
3) What parts are not in store, i.e. qoh = 0? (qoh = Quantity On Hand)
*/
SELECT name
FROM jbparts
WHERE qoh = 0;

/*
+-------------------+
| name              |
+-------------------+
| card reader       |
| card punch        |
| paper tape reader |
| paper tape punch  |
+-------------------+
4 rows in set (0.00 sec)

*/

/*
4) Which employees have a salary between 9000 (included) and 10000 (included)?
*/
SELECT name
FROM jbemployee
WHERE salary >= 9000 and salary <= 10000;

/*
+----------------+
| name           |
+----------------+
| Edwards, Peter |
| Smythe, Carol  |
| Williams, Judy |
| Thomas, Tom    |
+----------------+
4 rows in set (0.00 sec)

*/

/*
5) What was the age of each employee when they started working (startyear)?
*/
SELECT name, startyear - birthyear as startyear
FROM jbemployee;

/*
+--------------------+-----------+
| name               | startyear |
+--------------------+-----------+
| Ross, Stanley      |        18 |
| Ross, Stuart       |         1 |
| Edwards, Peter     |        30 |
| Thompson, Bob      |        40 |
| Smythe, Carol      |        38 |
| Hayes, Evelyn      |        32 |
| Evans, Michael     |        22 |
| Raveen, Lemont     |        24 |
| James, Mary        |        49 |
| Williams, Judy     |        34 |
| Thomas, Tom        |        21 |
| Jones, Tim         |        20 |
| Bullock, J.D.      |         0 |
| Collins, Joanne    |        21 |
| Brunet, Paul C.    |        21 |
| Schmidt, Herman    |        20 |
| Iwano, Masahiro    |        26 |
| Smith, Paul        |        21 |
| Onstad, Richard    |        19 |
| Zugnoni, Arthur A. |        21 |
| Choy, Wanda        |        23 |
| Wallace, Maggie J. |        19 |
| Bailey, Chas M.    |        19 |
| Bono, Sonny        |        24 |
| Schwarz, Jason B.  |        15 |
+--------------------+-----------+
25 rows in set (0.00 sec)
*/

/*
6) Which employees have a last name ending with "son"?
*/
SELECT name
FROM jbemployee
WHERE name like "%son,%";

/*
+---------------+
| name          |
+---------------+
| Thompson, Bob |
+---------------+
1 row in set (0.00 sec)
*/

/*
7) Which items (note items, not parts) have been delivered by a supplier called Fisher-Price? 
Formulate this query using a subquery in the WHERE-clause.
*/
SELECT name
FROM jbitem
WHERE supplier in 
(SELECT id
FROM jbsupplier
WHERE name = 'Fisher-Price');

/*
+-----------------+
| name            |
+-----------------+
| Maze            |
| The 'Feel' Book |
| Squeeze Ball    |
+-----------------+
3 rows in set (0.00 sec)
*/

/*
8) Formulate the same query as above, but without a subquery.
Which items (note items, not parts) have been delivered by a supplier called Fisher-Price?
*/
select I.name, S.name 
from jbitem I, jbsupplier S
where S.name='Fisher-Price' and S.id=I.supplier;

/*
+-----------------+--------------+
| name            | name         |
+-----------------+--------------+
| Maze            | Fisher-Price |
| The 'Feel' Book | Fisher-Price |
| Squeeze Ball    | Fisher-Price |
+-----------------+--------------+
3 rows in set (0.00 sec)
*/

/*
9) Show all cities that have suppliers located in them. 
Formulate this query using a subquery in the WHERE-clause.
*/
SELECT name
FROM jbcity
WHERE id in (SELECT city
FROM jbsupplier);

/*
+----------------+
| name           |
+----------------+
| Amherst        |
| Boston         |
| New York       |
| White Plains   |
| Hickville      |
| Atlanta        |
| Madison        |
| Paxton         |
| Dallas         |
| Denver         |
| Salt Lake City |
| Los Angeles    |
| San Diego      |
| San Francisco  |
| Seattle        |
+----------------+
15 rows in set (0.00 sec)
*/

/*
10) What is the name and color of the parts that are heavier than a card reader? 
Formulate this query using a subquery in the WHERE-clause. 
(The SQL query must not contain the weight as a constant.)
*/
SELECT name, color
FROM jbparts
WHERE weight > (SELECT weight
FROM jbparts
WHERE name = 'card reader');

/*
+--------------+--------+
| name         | color  |
+--------------+--------+
| disk drive   | black  |
| tape drive   | black  |
| line printer | yellow |
| card punch   | gray   |
+--------------+--------+
4 rows in set (0.00 sec)
*/

/*
11) Formulate the same query as above, but without a subquery. 
(The query must not contain the weight as a constant.)
*/
SELECT P1.name, P1.color 
FROM jbparts P1, jbparts P2
WHERE P1.weight > P2.weight 
and P2.name = 'card reader';

/*
SELECT P1.name, P1.color 
FROM jbparts P1, jbparts P2
WHERE P1.weight > P2.weight 
and P2.name = 'card reader';
*/

/*
12) What is the average weight of black parts?
*/
SELECT avg(weight) as 'avg_weight'
FROM jbparts
WHERE color = 'black';

/*
+------------+
| avg_weight |
+------------+
|   347.2500 |
+------------+
1 row in set (0.00 sec)
*/

/*
13) What is the total weight of all parts that each supplier in Massachusetts ("Mass"") has delivered?  
Retrieve the name and the total weight for each of these suppliers. 
Do not forget to take the quantity of delivered parts into account. 
Note that one row should be returned for each supplier.
*/
SELECT Su.name,  sum(quan * weight) as weight_totalsum
FROM jbcity as C
INNER JOIN jbsupplier as Su on C.id = Su.city
INNER JOIN jbsupply as Sl on Sl.supplier = Su.id
INNER JOIN jbparts as P on P.id = Sl.part
WHERE C.state = 'Mass'
GROUP BY Su.name;

/*
+--------------+-----------------+
| name         | weight_totalsum |
+--------------+-----------------+
| DEC          |            3120 |
| Fisher-Price |         1135000 |
+--------------+-----------------+
2 rows in set (0.01 sec)
*/

/*
14) Create a new relation (a table), with the same attributes as the table items using the CREATE TABLE 
syntax WHERE you define every attribute explicitly (i.e. not as a copy of another table). 
Then fill the table with all items that cost less than the average price for items. 
Remember to define primary and foreign keys in your table!
*/
CREATE TABLE jbinfo (id integer PRIMARY KEY, name varchar(25),
dept integer ,price integer , qoh integer , supplier integer );

INSERT INTO jbinfo (id, name, dept, price, qoh, supplier) 
SELECT id, name, dept, price, qoh, supplier FROM jbitem 
WHERE price<all (SELECT avg(price) FROM jbitem);

SELECT * FROM jbinfo;

drop table jbinfo;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/

/*
15) Create a view that contains the items that cost less than the average price for items.
*/

CREATE VIEW lessthanavgprice_view AS
SELECT * 
FROM jbitem 
WHERE price < (SELECT avg(price)
FROM jbitem);

SELECT * 
FROM lessthanavgprice_view;

drop view lessthanavgprice_view;

/*
+-----+-----------------+------+-------+------+----------+
| id  | name            | dept | price | qoh  | supplier |
+-----+-----------------+------+-------+------+----------+
|  11 | Wash Cloth      |    1 |    75 |  575 |      213 |
|  19 | Bellbottoms     |   43 |   450 |  600 |       33 |
|  21 | ABC Blocks      |    1 |   198 |  405 |      125 |
|  23 | 1 lb Box        |   10 |   215 |  100 |       42 |
|  25 | 2 lb Box, Mix   |   10 |   450 |   75 |       42 |
|  26 | Earrings        |   14 |  1000 |   20 |      199 |
|  43 | Maze            |   49 |   325 |  200 |       89 |
| 106 | Clock Book      |   49 |   198 |  150 |      125 |
| 107 | The 'Feel' Book |   35 |   225 |  225 |       89 |
| 118 | Towels, Bath    |   26 |   250 | 1000 |      213 |
| 119 | Squeeze Ball    |   49 |   250 |  400 |       89 |
| 120 | Twin Sheet      |   26 |   800 |  750 |      213 |
| 165 | Jean            |   65 |   825 |  500 |       33 |
| 258 | Shirt           |   58 |   650 | 1200 |       33 |
+-----+-----------------+------+-------+------+----------+
14 rows in set (0.00 sec)
*/

/*
16) What is the difference between a table and a view? One is static and the other is dynamic. 
Which is which and what do we mean by static respectively dynamic?
*/

/* A view is a virtual table. A view consists of rows and columns just like a table. 
The difference between a view and a table is that views are definitions built on top of 
other tables (or views), and do not hold data themselves. If data is changing in the underlying 
table, the same change is reflected in the view. A view can be built on top of a single table 
or multiple tables. It can also be built on top of another view. 
source: https://www.1keydata.com/sql/sql-view.html
*/


/*
17) Create a view, using only the implicit join notation, 
i.e. only use WHERE statements but no INNER JOIN, right join or left join statements, 
that calculates the total cost of each debit, by considering price and 
quantity of each bought item. (To be used for charging customer accounts). 
The view should contain the sale identifier (debit) and total cost.
*/

CREATE VIEW totalcost_implicitjoin_view as
SELECT D.id, sum(S.quantity * I.price) as total_cost
FROM jbitem as I, jbdebit as D, jbsale as S
WHERE I.id = S.item and D.id = S.debit
GROUP BY D.id;

SELECT * 
FROM totalcost_implicitjoin_view;

drop view totalcost_implicitjoin_view;

/*
+--------+------------+
| id     | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100582 |       1000 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+
6 rows in set (0.01 sec)
*/

/*
18) Do the same as in (17), using only the explicit join notation, 
i.e. using only left, right or INNER JOINs but no WHERE statement. 
Motivate why you use the join you do (left, right or inner), 
and why this is the correct one (unlike the others).
*/

CREATE VIEW totalcost_join_view as
SELECT D.id, sum(S.quantity * I.price) as total_cost
FROM jbdebit D
LEFT JOIN jbsale S on D.id = S.debit
LEFT JOIN jbitem I on I.id = S.item
GROUP BY D.id;

select * 
from totalcost_join_view;

drop view totalcost_join_view;

/*
+--------+------------+
| id     | total_cost |
+--------+------------+
| 100581 |       2050 |
| 100582 |       1000 |
| 100586 |      13446 |
| 100592 |        650 |
| 100593 |        430 |
| 100594 |       3295 |
+--------+------------+
6 rows in set (0.01 sec)
*/

/*
19) Oh no! An earthquake!

a) Remove all suppliers in Los Angeles FROM the table jbsupplier. 
This will not work right away (you will receive error code 23000) 
which you will have to solve by deleting some other related tuples. 
However, do not delete more tuples FROM other tables than necessary and 
do not change the structure of the tables, i.e. do not remove foreign keys. 
Also, remember that you are only allowed to use “Los Angeles” as a constant 
in your queries, not “199” or “900”. */

DELETE jbsale
FROM jbsale
RIGHT JOIN jbitem on jbitem.id=jbsale.item
LEFT JOIN jbsupplier on jbsupplier.id=jbitem.supplier
LEFT JOIN jbcity on jbcity.id=jbsupplier.city
where jbcity.name='Los Angeles';

DELETE jbitem
FROM jbitem
LEFT JOIN jbsupplier on jbsupplier.id=jbitem.supplier
LEFT JOIN jbcity on jbcity.id=jbsupplier.city
WHERE jbcity.name='Los Angeles';

DELETE jbsupplier
FROM jbsupplier
LEFT JOIN jbcity on jbcity.id=jbsupplier.city
WHERE jbcity.name='Los Angeles';

SELECT * FROM jbsupplier;

/*
+-----+--------------+------+
| id  | name         | city |
+-----+--------------+------+
|   5 | Amdahl       |  921 |
|  15 | White Stag   |  106 |
|  20 | Wormley      |  118 |
|  33 | Levi-Strauss |  941 |
|  42 | Whitman's    |  802 |
|  62 | Data General |  303 |
|  67 | Edger        |  841 |
|  89 | Fisher-Price |   21 |
| 122 | White Paper  |  981 |
| 125 | Playskool    |  752 |
| 199 | Koret        |  900 |
| 213 | Cannon       |  303 |
| 241 | IBM          |  100 |
| 440 | Spooley      |  609 |
| 475 | DEC          |   10 |
| 999 | A E Neumann  |  537 |
+-----+--------------+------+
16 rows in set (0.00 sec)
*/

/*
b) Explain what you did and why.
*/

/*
Before we started with this part of the task, we created a detailed overview of the ER model.
The starting point is the Supplier table from where we examined direct connections. 
We found out that there is no entry between Supplier and Supply. Accordingly, we do not 
need to look at the Supply and Parts table for this part of the task any further. 
However, if we take a closer look at the City, Item and Sale tables, we can see that there 
are relationships between them and the supplier.

If we want to delete only one tuple from a table, this generates an error, because there are 
further connections to other tables (as already explained). 
Therefore we proceeded step by step and deleted the tuple first in jbsale, then in 
jbitem and finally in jbsupplier. This task is given with restriction, only "Los Angeles" 
may be used as constant. Therefore we create a large table with several joins statements.
*/

/*
20) An employee has tried to find out which suppliers that have delivered items that
have been sold. He has created a view and a query that shows the number of items
sold FROM a supplier
*/

CREATE VIEW jbsale_supply_update(supplier, item, quantity) AS 
SELECT jbsupplier.name, jbitem.name, jbsale.quantity 
FROM jbsupplier
INNER JOIN jbitem on jbsupplier.id = jbitem.supplier
LEFT JOIN jbsale on jbsale.item = jbitem.id;

SELECT supplier, sum(quantity) AS sum FROM jbsale_supply_update
GROUP BY supplier;

drop view jbsale_supply_update;

/*
+--------------+------+
| supplier     | sum  |
+--------------+------+
| Cannon       |    6 |
| Fisher-Price | NULL |
| Koret        |    1 |
| Levi-Strauss |    1 |
| Playskool    |    2 |
| White Stag   |    4 |
| Whitman's    |    2 |
+--------------+------+
7 rows in set (0.00 sec)
*/






