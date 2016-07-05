---
---

# Migrating the Data

To ensure there are no issues with user, you must copy all the existing data eduPersonTargetedIDs and auEduPersonSharedTokens values from your old IdP to your new IdP.

In some cases the data may not have been recorded by your old IdP, i.e it is re-computed every time the user logs in. In this case we need to rely on the fact that the same source values and procedures are used by the new IdP when computing these values.


### Note:There are significant changes in the shibpid table structure for V3. 

To check your current table structure run the following commands within your MySQL console.

```
###Example of the V3 – shibpid table

DESCRIBE shibpid; 

+------------------+--------------+------+-----+-------------------+-----------------------------+
------------------+--------------+------+-----+-------------------+-----------------------------+
+------------------+--------------+------+-----+-------------------+-----------------------------+



SHOW INDEX FROM shibpid;

---------+------------+----------------+--------------+------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
---------+------------+----------------+--------------+------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
---------+------------+----------------+--------------+------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+
```

To export existing values from the database on the old IdP and import into the new IdP.

The data from the shibpid and tb_st tables needs to be copied across from your old IdP. These tables may be in the same schema or may be in separate schemas depending on how your IdP was originally setup.

***Export Data***

```
If in the same schema (uApprove schema in this example)
mysqldump --no-create-info -u root -p uApprove shibpid tb_st > idp_dump.sql

If in separate schemas

mysqldump --no-create-info -u root -p uApprove shibpid > idp_dump.sql

mysqldump --no-create-info –u root –p sh_token tb_st >> idp_dump.sql

```
***Import Data***

Before importing the data, delete all the entries from the shibpid and tb_st tables first.


```
DELETE * FROM shibpid;

DELETE * FROM tb_st;

mysql -u root idp_db < idp_dump.sql

```
To minimise the data duplication, check the count again and ensure that number of records in the V3 table matches with your V2 records.

```
SELECT COUNT(*) FROM shibpid;

```









