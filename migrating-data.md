---
---

# Migrating the Data

To ensure there are no issues with user, you must copy all the existing data eduPersonTargetedIDs and auEduPersonSharedTokens values from your old IdP to your new IdP.

In some cases the data may not have been recorded by your old IdP, i.e it is re-computed every time the user logs in. In this case we need to rely on the fact that the same source values and procedures are used by the new IdP when computing these values.


### Note:There are significant changes in the shibpid table structure for V3. To avoid the data duplication and data corruption, ensure that your database structure meet with V3 requirements.

To check your current table structure run the following commands within your MySQL console.

```
###Example of the V3 – shibpid table

DESCRIBE shibpid; 

+------------------+--------------+------+-----+-------------------+-----------------------------+| Field            | Type         | Null | Key | Default           | Extra                       |+------------------+--------------+------+-----+-------------------+-----------------------------+| localEntity      | varchar(255) | NO   | PRI | NULL              |                             || peerEntity       | varchar(255) | NO   | PRI | NULL              |                             || persistentId     | varchar(50)  | NO   | PRI | NULL              |                             || principalName    | varchar(50)  | NO   |     | NULL              |                             || localId          | varchar(50)  | NO   |     | NULL              |                             || peerProvidedId   | varchar(50)  | YES  |     | NULL              |                             || creationDate     | timestamp    | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP || deactivationDate | timestamp    | YES  |     | NULL              |                             |
+------------------+--------------+------+-----+-------------------+-----------------------------+



SHOW INDEX FROM shibpid;
+---------+------------+----------------+--------------+------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+| Table   | Non_unique | Key_name       | Seq_in_index | Column_name      | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment | Index_comment |+---------+------------+----------------+--------------+------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+| shibpid |          0 | PRIMARY        |            1 | localEntity      | A         |           5 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          0 | PRIMARY        |            2 | peerEntity       | A         |          10 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          0 | PRIMARY        |            3 | persistentId     | A         |          10 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          1 | persistentId   |            1 | persistentId     | A         |          10 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          1 | persistentId_2 |            1 | persistentId     | A         |          10 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          1 | persistentId_2 |            2 | deactivationDate | A         |          10 |     NULL | NULL   | YES  | BTREE      |         |               || shibpid |          1 | localEntity    |            1 | localEntity      | A         |           5 |       16 | NULL   |      | BTREE      |         |               || shibpid |          1 | localEntity    |            2 | peerEntity       | A         |          10 |       16 | NULL   |      | BTREE      |         |               || shibpid |          1 | localEntity    |            3 | localId          | A         |          10 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          1 | localEntity_2  |            1 | localEntity      | A         |           5 |       16 | NULL   |      | BTREE      |         |               || shibpid |          1 | localEntity_2  |            2 | peerEntity       | A         |          10 |       16 | NULL   |      | BTREE      |         |               || shibpid |          1 | localEntity_2  |            3 | localId          | A         |          10 |     NULL | NULL   |      | BTREE      |         |               || shibpid |          1 | localEntity_2  |            4 | deactivationDate | A         |          10 |     NULL | NULL   | YES  | BTREE      |         |               |+---------+------------+----------------+--------------+------------------+-----------+-------------+----------+--------+------+------------+---------+---------------+SELECT COUNT(*) FROM shibpid;
```

To export existing values from the database on the old IdP and import into the new IdP.

The data from the shibpid and tb_st tables needs to be copied across from your old IdP. These tables may be in the same schema or may be in separate schemas depending on how your IdP was originally setup.

*** Export Data***

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










