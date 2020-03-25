
create or replace PROCEDURE truncate_table(P_TABLE VARCHAR2) AUTHID DEFINER  AS 
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE PKD19.' || P_TABLE || ' DROP STORAGE';
END truncate_table;

create or replace PROCEDURE drop_table(P_TABLE VARCHAR2) AUTHID DEFINER  AS 
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE PKD19.' || P_TABLE || '';
END drop_table;

CREATE OR REPLACE PROCEDURE record_error(PRC VARCHAR2) AUTHID DEFINER  AS 

   PRAGMA AUTONOMOUS_TRANSACTION;
   l_mesg  VARCHAR2(32767) := SQLERRM;
 
BEGIN

	EXECUTE IMMEDIATE' INSERT INTO PKD19.logging (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, ''YYYY.MM.DD HH24:MI:SS.FF''), ''ERROR'', '''|| PRC ||''', '''|| l_mesg ||''', sys.DBMS_UTILITY.format_error_backtrace)';
		
		
   COMMIT;
END;




