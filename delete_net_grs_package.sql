create or replace PACKAGE CFC_DELETE_NET_GRS AUTHID CURRENT_USER AS 

procedure delete_rows(szekt VARCHAR2, alszekt VARCHAR2, eszkoz VARCHAR2);

END CFC_DELETE_NET_GRS;
------------


create or replace PACKAGE BODY CFC_DELETE_NET_GRS AS  

PROCEDURE delete_rows(szekt VARCHAR2, alszekt VARCHAR2, eszkoz VARCHAR2) AS

deleteTable all_tables.TABLE_NAME%TYPE;

BEGIN

SELECT TABLE_NAME INTO deleteTable FROM (SELECT TABLE_NAME FROM all_tables WHERE OWNER = 'PKD' AND TABLE_NAME LIKE UPPER(''|| szekt ||'_'|| alszekt ||'_'|| eszkoz ||'_%') ORDER BY TABLE_NAME desc) WHERE ROWNUM = 1;

DBMS_OUTPUT.put_line(deleteTable);

EXECUTE IMMEDIATE'
DELETE FROM PKD.'|| deleteTable ||'
WHERE OUTPUT IN (''grs'', ''net'')
'
;

END delete_rows;
END;
