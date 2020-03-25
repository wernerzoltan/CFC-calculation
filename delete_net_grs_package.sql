/*create or replace PACKAGE CFC_DELETE_NET_GRS AUTHID CURRENT_USER AS 

TYPE t_out_eszkozcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_szektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_alszektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_name IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;

procedure delete_rows(v_szektor VARCHAR2, v_alszektor VARCHAR2, eszkoz VARCHAR2, v_eszkozcsp VARCHAR2);

END CFC_DELETE_NET_GRS;
*/
------------


create or replace PACKAGE BODY CFC_DELETE_NET_GRS AS  

v_out_eszkozcsp t_out_eszkozcsp;
v_out_szektor t_out_szektor;
v_out_alszektor t_out_alszektor;
v_out_name t_out_name;
v NUMBER;


PROCEDURE delete_rows(v_szektor VARCHAR2, v_alszektor VARCHAR2, eszkoz VARCHAR2, v_eszkozcsp VARCHAR2) AS

deleteTable all_tables.TABLE_NAME%TYPE;

BEGIN

IF v_alszektor = 'S1' THEN

	v_out_alszektor(1) := 'S11';
	v_out_alszektor(2) := 'S12';
	v_out_alszektor(3) := 'S1311';
	v_out_alszektor(4) := 'S1311a';
	v_out_alszektor(5) := 'S1313';
	v_out_alszektor(6) := 'S1313a';
	v_out_alszektor(7) := 'S1314';
	v_out_alszektor(8) := 'S14';
	v_out_alszektor(9) := 'S15';
	v_out_szektor(1) := 'S11';
	v_out_szektor(2) := 'S12';
	v_out_szektor(3) := 'S13';
	v_out_szektor(4) := 'S13';
	v_out_szektor(5) := 'S13';
	v_out_szektor(6) := 'S13';
	v_out_szektor(7) := 'S13';
	v_out_szektor(8) := 'S14';
	v_out_szektor(9) := 'S15';

ELSIF v_alszektor = 'S13' THEN

	v_out_alszektor(1) := 'S1311';
	v_out_alszektor(2) := 'S1311a';
	v_out_alszektor(3) := 'S1313';
	v_out_alszektor(4) := 'S1313a';
	v_out_alszektor(5) := 'S1314';
	v_out_szektor(1) := 'S13';
	v_out_szektor(2) := 'S13';
	v_out_szektor(3) := 'S13';
	v_out_szektor(4) := 'S13';
	v_out_szektor(5) := 'S13';

ELSE 

	v_out_alszektor(1) := ''|| v_alszektor ||'';
	v_out_szektor(1) := ''|| v_szektor ||'';

END IF;


FOR x IN v_out_alszektor.FIRST..v_out_alszektor.LAST LOOP

IF v_eszkozcsp = 'CLASSIC' THEN 

	IF ''|| v_out_alszektor(x) ||'' = 'S15' THEN

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';	
		
		v_out_eszkozcsp(4) := 'BREAK';
		v_out_name(4) := 'BREAK';		

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S14' THEN

		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_eszkozcsp(4) := 'AN1139g';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';	
		v_out_name(4) := 'GYORSGEP';
		
		v_out_eszkozcsp(5) := 'BREAK';
		v_out_name(5) := 'BREAK';
		
	ELSE
	
		v_out_eszkozcsp(1) := 'AN112';
		v_out_eszkozcsp(2) := 'AN1131';
		v_out_eszkozcsp(3) := 'AN1139t';
		v_out_eszkozcsp(4) := 'AN1139g';
		v_out_eszkozcsp(5) := 'AN1173s';
		v_out_name(1) := 'EPULET';
		v_out_name(2) := 'JARMU';
		v_out_name(3) := 'TARTOSGEP';	
		v_out_name(4) := 'GYORSGEP';
		v_out_name(5) := 'SZOFTVER';	
		
		v_out_eszkozcsp(6) := 'BREAK';
		v_out_name(6) := 'BREAK';		
		
	END IF;
	

ELSIF v_eszkozcsp = 'EGYEB' THEN 

	IF ''|| v_out_alszektor(x) ||'' = 'S1311' THEN
	
		v_out_eszkozcsp(1) := 'AN114';
		v_out_eszkozcsp(2) := 'AN1123';
		v_out_eszkozcsp(3) := 'AN1173o';
		v_out_eszkozcsp(4) := 'AN1171';
		v_out_name(1) := 'FEGYVER';
		v_out_name(2) := 'FOLDJAVITAS';
		v_out_name(3) := 'OWNSOFT';	
		v_out_name(4) := 'K_F';	
		
		v_out_eszkozcsp(5) := 'BREAK';
		v_out_name(5) := 'BREAK';
		
	
	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1313' THEN
	
		v_out_eszkozcsp(1) := 'AN1123';
		v_out_name(1) := 'FOLDJAVITAS';
		
		v_out_eszkozcsp(2) := 'BREAK';
		v_out_name(2) := 'BREAK';

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1311a' THEN
	
		v_out_eszkozcsp(1) := 'AN1174';
		v_out_eszkozcsp(2) := 'AN1171';
		v_out_name(1) := 'ORIGINALS';
		v_out_name(2) := 'K_F';	
		
		v_out_eszkozcsp(3) := 'BREAK';
		v_out_name(3) := 'BREAK';		

	ELSIF ''|| v_out_alszektor(x) ||'' = 'S1313a' THEN
	
		v_out_eszkozcsp(1) := 'AN1174';
		v_out_name(1) := 'ORIGINALS';
		
		v_out_eszkozcsp(2) := 'BREAK';
		v_out_name(2) := 'BREAK';
		
	ELSIF ''|| v_out_alszektor(x) ||'' = 'S11' THEN
	
		v_out_eszkozcsp(1) := 'AN1123';
		v_out_eszkozcsp(2) := 'AN1173o';
		v_out_eszkozcsp(3) := 'AN1174';
		v_out_eszkozcsp(4) := 'AN1171';
		v_out_eszkozcsp(5) := 'AN1139k';
		v_out_eszkozcsp(6) := 'AN1131w';
		v_out_eszkozcsp(7) := 'AN1174t';
		v_out_eszkozcsp(8) := 'AN1174a';
		v_out_eszkozcsp(9) := 'AN112n';
		v_out_name(1) := 'FOLDJAVITAS';
		v_out_name(2) := 'OWNSOFT';
		v_out_name(3) := 'ORIGINALS';	
		v_out_name(4) := 'K_F';	
		v_out_name(5) := 'kiserteku';
		v_out_name(6) := 'WIZZ';
		v_out_name(7) := 'TCF';
		v_out_name(8) := 'egyeb_orig';
		v_out_name(9) := 'NOE6';
		
		v_out_eszkozcsp(10) := 'BREAK';
		v_out_name(10) := 'BREAK';
				
	ELSIF ''|| v_out_alszektor(x) ||'' = 'S12' THEN
	
		v_out_eszkozcsp(1) := 'AN1173o';
		v_out_name(1) := 'OWNSOFT';
		
		v_out_eszkozcsp(2) := 'BREAK';
		v_out_name(2) := 'BREAK';
		
	
	ELSIF ''|| v_out_alszektor(x) ||'' = 'S14' THEN
	
		v_out_eszkozcsp(1) := 'AN1123';
		v_out_eszkozcsp(2) := 'AN1173o';
		v_out_eszkozcsp(3) := 'AN1174';
		v_out_name(1) := 'FOLDJAVITAS';
		v_out_name(2) := 'OWNSOFT';
		v_out_name(3) := 'ORIGINALS';
		
		v_out_eszkozcsp(4) := 'BREAK';
		v_out_name(4) := 'BREAK';		
	
	ELSIF ''|| v_out_alszektor(x) ||'' = 'S15' THEN
	
		v_out_eszkozcsp(1) := 'AN1171';
		v_out_name(1) := 'K_F';	
		
		v_out_eszkozcsp(2) := 'BREAK';
		v_out_name(2) := 'BREAK';

	END IF;


	
ELSE
	
v_out_eszkozcsp(1) := ''|| v_eszkozcsp ||'';
v_out_name(1) := ''|| eszkoz ||'';

END IF;


FOR b IN v_out_eszkozcsp.FIRST..v_out_eszkozcsp.LAST LOOP

		DBMS_OUTPUT.PUT_LINE('Alszektor: '|| v_out_alszektor(x) ||'');
		DBMS_OUTPUT.PUT_LINE('Eszközcsoport: '|| v_out_eszkozcsp(b) ||'');

		EXIT WHEN ''|| v_out_eszkozcsp(b) ||'' = 'BREAK';
		
		SELECT COUNT(*) INTO v FROM  all_tables WHERE OWNER = 'PKD19' AND TABLE_NAME LIKE UPPER(''|| v_szektor ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_%');
		IF v > 0 THEN

		SELECT TABLE_NAME INTO deleteTable FROM (SELECT TABLE_NAME FROM all_tables WHERE OWNER = 'PKD19' AND TABLE_NAME LIKE UPPER(''|| v_szektor ||'_'|| v_out_alszektor(x) ||'_'|| v_out_name(b) ||'_%') ORDER BY TABLE_NAME desc) WHERE ROWNUM = 1;

		DBMS_OUTPUT.put_line(deleteTable);

		EXECUTE IMMEDIATE'
		DELETE FROM PKD19.'|| deleteTable ||'
		WHERE OUTPUT IN (''grs'', ''net'')
		'
		;
		
		END IF;

END LOOP;

END LOOP;

END delete_rows;
END;
