/*
CREATE TABLE PKD19.OUTPUT_KULONSBEG
("ALSZEKTOR" VARCHAR2(26 BYTE), 
	"AGAZAT" VARCHAR2(26 BYTE), 
		"EV" VARCHAR2(20 BYTE), 
	"F_V_99" VARCHAR2(20 BYTE), 
	"CFC_NET_GRS" VARCHAR2(20 BYTE)) ;
*/


create or replace PROCEDURE OUTPUT_MINUS AUTHID CURRENT_USER AS

v_kulonbseg VARCHAR2(50);
v_original VARCHAR2(50);
v_modified VARCHAR2(50); 

BEGIN

v_kulonbseg := 'OUTPUT_KULONSBEG';
v_original := 'C_OUTPUT_PROBA';
v_modified := 'C_OUTPUT_P_FINAL';

EXECUTE IMMEDIATE'
DELETE FROM PKD19.'|| v_kulonbseg ||' 
'
;

EXECUTE IMMEDIATE'
insert into PKD19.'|| v_kulonbseg ||' 
(select ALSZEKTOR, AGAZAT, EV, F_V_99, CFC_NET_GRS FROM 
(select *  from PKD19.'|| v_original ||'
minus
select * from PKD19.'|| v_modified ||'))
'
;


END;