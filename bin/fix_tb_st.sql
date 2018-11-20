-- Updates the characater set and collation used on the tb_st table
-- to allow for a wider range of characters to be catered for.
--
-- For MySQL and MariaDB databases only, version 5.5 or greater.
--
-- Login to the database connected to the idp_db schema and load the
-- the fix_tb_st procedure.
--
-- Below, use 'false' if you want to verify if a change is required, 
-- otherwise 'true' if you want the change to be made.
--
--     mysql idp_db
--     source fix_tb_st.sql
--     call fix_tb_st ([ture|false])
-- 
 
DROP PROCEDURE IF EXISTS fix_tb_st;

DELIMITER //

CREATE PROCEDURE fix_tb_st (IN dorun boolean)
BEGIN
  select column_name as 'Column', 
         @tb_st_charset := character_set_name as 'Current Character Set', 
         @tb_st_collation := collation_name as 'Current Collation'
  from information_schema.columns where table_name = 'tb_st';

  if (@tb_st_charset != 'utf8mb4' or @tb_st_collation != 'utf8mb4_bin') then

    if (!dorun) then
      select 'Change of character set required!' as 'Result';
    else
        alter table tb_st  default character set utf8mb4 default collate utf8mb4_bin;

        alter table tb_st convert to character set utf8mb4 collate utf8mb4_bin;

        select 'Table successfully modified' as 'Result';
    end if;

  else
    select 'Database Ok, change is NOT required!' as 'Result';

  end if;


END//

DELIMITER ;
