/*
Lab 2 report <Phillip_Hölscher phiho267 & Zijie Feng zijfe244>
*/

SOURCE company_schema.sql;
SOURCE company_data.sql;


############ ex.3 ################


/*
show all the constraints on table 'jbdept'
show create table jbdept; 
*/
 

/*
# remove constraint 'fk_dept_mgr'
*/
 alter table jbdept drop foreign key fk_dept_mgr;


/*
# remove constraint 'fk_emp_mgr', here 'manager' is a KEY in 'jbemployee'
*/
 alter table jbemployee drop foreign key fk_emp_mgr;


create table jbmanager(
    manager_id int primary key,
    foreign key (manager_id) references jbemployee(id),
    bonus int not null default 0                                           # initial bonus as 0             
    );

/* TEST
insert into jbmanager (manager_id, bonus)
values (10000, 100000);

ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`jb`.`jbmanager`, 
CONSTRAINT `jbmanager_ibfk_1` FOREIGN KEY (`manager_id`) REFERENCES `jbemployee` (`id`))
*/

/*
Written answer for question 3)

We initialized Bonus with "bonus int not null default 0". 
So every manager starts with the value 0 automatically, so it can be extended by a 
certain value in the future, like in the Lab. 

*/


/*
# insert all managers from 'jbemployee.manager' and 'jbdept.manager' into table 'jbmanager'
*/
insert into jbmanager(manager_id)
select distinct(manager) from jbemployee where manager is not null  union select manager from jbdept; 


############ ex.4 ################

update jbmanager
    set bonus = 10000
    where jbmanager.manager_id in (select manager from jbdept);

select * from jbmanager;
/*
+------------+-------+
| manager_id | bonus |
+------------+-------+
|         10 | 10000 |
|         13 | 10000 |
|         26 | 10000 |
|         32 | 10000 |
|         33 | 10000 |
|         35 | 10000 |
|         37 | 10000 |
|         55 | 10000 |
|         98 | 10000 |
|        129 | 10000 |
|        157 | 10000 |
|        199 |     0 |
+------------+-------+
12 rows in set (0.00 sec)
*/

/*
# drop column 'manager' from table 'jbemployee'
*/
alter table jbemployee drop manager;


select * from jbemployee;
/*
+------+--------------------+--------+-----------+-----------+
| id   | name               | salary | birthyear | startyear |
+------+--------------------+--------+-----------+-----------+
|   10 | Ross, Stanley      |  15908 |      1927 |      1945 |
|   11 | Ross, Stuart       |  12067 |      1931 |      1932 |
|   13 | Edwards, Peter     |   9000 |      1928 |      1958 |
|   26 | Thompson, Bob      |  13000 |      1930 |      1970 |
|   32 | Smythe, Carol      |   9050 |      1929 |      1967 |
|   33 | Hayes, Evelyn      |  10100 |      1931 |      1963 |
|   35 | Evans, Michael     |   5000 |      1952 |      1974 |
|   37 | Raveen, Lemont     |  11985 |      1950 |      1974 |
|   55 | James, Mary        |  12000 |      1920 |      1969 |
|   98 | Williams, Judy     |   9000 |      1935 |      1969 |
|  129 | Thomas, Tom        |  10000 |      1941 |      1962 |
|  157 | Jones, Tim         |  12000 |      1940 |      1960 |
|  199 | Bullock, J.D.      |  27000 |      1920 |      1920 |
|  215 | Collins, Joanne    |   7000 |      1950 |      1971 |
|  430 | Brunet, Paul C.    |  17674 |      1938 |      1959 |
|  843 | Schmidt, Herman    |  11204 |      1936 |      1956 |
|  994 | Iwano, Masahiro    |  15641 |      1944 |      1970 |
| 1110 | Smith, Paul        |   6000 |      1952 |      1973 |
| 1330 | Onstad, Richard    |   8779 |      1952 |      1971 |
| 1523 | Zugnoni, Arthur A. |  19868 |      1928 |      1949 |
| 1639 | Choy, Wanda        |  11160 |      1947 |      1970 |
| 2398 | Wallace, Maggie J. |   7880 |      1940 |      1959 |
| 4901 | Bailey, Chas M.    |   8377 |      1956 |      1975 |
| 5119 | Bono, Sonny        |  13621 |      1939 |      1963 |
| 5219 | Schwarz, Jason B.  |  13374 |      1944 |      1959 |
+------+--------------------+--------+-----------+-----------+
25 rows in set (0.00 sec)
*/

############ ex.5  account & customer ################

/*
In this part of the ex 5 do we create the tables jbcustomer and jbaccount
*/

create table jbcustomer(
    id int not null primary key,
    first_name char(20),
    sur_name char(20),
    street_address char(100),
    city_id int,
    foreign key (city_id) references jbcity(id)
    );

CREATE TABLE jbaccount(
    account_Nr int not null,
    PRIMARY KEY (account_Nr),
    balance float,
    customer_id int not null,
    foreign key (customer_id) references jbcustomer(id)
    );

############ ex.5  transaction ########################

/*
superset
create the table jbtransaction
*/
create table jbtransaction(
    transaction_Nr int not null primary key,
    account int not null,
    sdate timestamp not null,
    responsible_employee int not null,
    foreign key (responsible_employee) references jbemployee(id),
    foreign key (account) references jbaccount(account_Nr)
    );


/*
subset
create table jbdeposit which is a subset of the superclass jbtransaction
*/
create table jbdeposit(
    deposit_Nr int primary key,
    foreign key (deposit_Nr) references jbtransaction(transaction_Nr)
    );

/*
subset
create table jbwithdrawl which is a subset of the superclass jbtransaction
*/
create table jbwithdrawl(
    withdrawl_Nr int primary key,
    foreign key (withdrawl_Nr) references jbtransaction(transaction_Nr)
    );

############ ex.5 renew of debit and sale ########################

/*
Before we remove the data of the table jbsales do we drop the foreign key
*/
alter table jbsale drop foreign key fk_sale_debit;

/*
as in Ex. 5 maintained to we EMPTY the data of the table jbsales
*/
delete from jbsale;

/*
As we can see in the ER model in relation model do we have a new connection between 
sales and transactions, here do we create the connection
*/
alter table jbsale
    add foreign key (debit) references jbtransaction(transaction_Nr);

/*
we delete the whole table jbdebit and initialize a new connection to transactions
*/
drop table jbdebit;

create table jbdebit(
    debit_Nr int primary key,
    foreign key (debit_Nr) references jbtransaction(transaction_Nr)
    );

show tables;

+---------------+
| Tables_in_jb  |
+---------------+
| jbaccount     |
| jbcity        |
| jbcustomer    |
| jbdebit       |
| jbdeposit     |
| jbdept        |
| jbemployee    |
| jbitem        |
| jbmanager     |
| jbparts       |
| jbsale        |
| jbstore       |
| jbsupplier    |
| jbsupply      |
| jbtransaction |
| jbwithdrawl   |
+---------------+
16 rows in set (0.00 sec)



