/*
create or replace PACKAGE CFC_IMPORT AUTHID CURRENT_USER AS 
TYPE T_AGAZAT_IMP IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkozcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_name IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_name_cl IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_agazat IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE T_SZEKTOR IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;

procedure gfcf_imp_alt(GFCF_EV NUMBER, v_gfcf_table VARCHAR2, v_gfcf_ar_table VARCHAR2, v_gfcf_out_table VARCHAR2, v_inv2_table VARCHAR2, v_lifetime_table VARCHAR2, v_arindex_1999 VARCHAR2, v_eszkozcsp VARCHAR2, v_gfcf_name VARCHAR2, v_alszektor VARCHAR2, eszkoz VARCHAR2, table_rate_m VARCHAR2, v_arindex_lanc VARCHAR2, v_compare VARCHAR2, schema_name VARCHAR2, version_to_run VARCHAR2);


PROCEDURE gfcf_imp_1999(GFCF_EV NUMBER, v_gfcf_out_table VARCHAR2, v_arindex_1999 VARCHAR2, schema_name VARCHAR2, v_o_name VARCHAR2, v_eszk VARCHAR2, v_szekt VARCHAR2, v_agazat VARCHAR2);
PROCEDURE gfcf_imp_inv2(GFCF_EV NUMBER, v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_o_name VARCHAR2, v_eszk VARCHAR2, v_szekt VARCHAR2, v_agazat VARCHAR2, v_inv2_table VARCHAR2);
PROCEDURE gfcf_imp_jarmu(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_szekt VARCHAR2);
PROCEDURE gfcf_imp_epulet(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_szekt VARCHAR2);
PROCEDURE gfcf_imp_ownsoft(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_szekt VARCHAR2);

PROCEDURE gfcf_imp_valt(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_gfcf_mod_table VARCHAR2, GFCF_EV NUMBER, v_arindex_1999 VARCHAR2, v_inv2_table VARCHAR2, table_rate_m VARCHAR2, version_to_run VARCHAR2);

PROCEDURE add_columns(schema_name VARCHAR2, v_gfcf_out_table VARCHAR2);


END CFC_IMPORT;
*/
------------


create or replace PACKAGE BODY CFC_IMPORT AS  
V_AGAZAT_IMP T_AGAZAT_IMP;
v_out_eszkozcsp t_out_eszkozcsp;
v_out_name t_out_name;
v_out_name_cl t_out_name_cl;
v_agazat t_agazat;
V_SZEKTOR T_SZEKTOR;



-- GFCF import általános


PROCEDURE gfcf_imp_alt(GFCF_EV NUMBER, v_gfcf_table VARCHAR2, v_gfcf_ar_table VARCHAR2, v_gfcf_out_table VARCHAR2, v_inv2_table VARCHAR2, v_lifetime_table VARCHAR2, v_arindex_1999 VARCHAR2, v_eszkozcsp VARCHAR2, v_gfcf_name VARCHAR2, v_alszektor VARCHAR2, eszkoz VARCHAR2, table_rate_m VARCHAR2, v_arindex_lanc VARCHAR2, v_compare VARCHAR2, schema_name VARCHAR2, version_to_run VARCHAR2) AS  

v_logging VARCHAR2(10);
procName VARCHAR2(30);
v NUMERIC;
v1 NUMERIC;
GFCF_num NUMBER;
GFCF_minus VARCHAR2(10) := ''|| GFCF_EV ||''-1;
GFCF_plus VARCHAR2(10) := ''|| GFCF_EV ||''+1;

TYPE e_compare IS RECORD (AGAZAT VARCHAR2(5), ALSZEKTOR VARCHAR2(20), ESZKOZCSP VARCHAR2(20));
TYPE t_compare IS TABLE OF e_compare INDEX BY BINARY_INTEGER;
v_compare_a t_compare; 

-- TYPE t_compare IS TABLE OF C_IMP_COMPARE%ROWTYPE;
-- v_compare_a t_compare; 

TYPE t_agazat_type IS TABLE OF VARCHAR2(20); 
v_agazat_type t_agazat_type; 

TYPE t_agazat_type_g IS TABLE OF VARCHAR2(20); 
v_agazat_type_g t_agazat_type_g; 

TYPE t_agazat_type_a IS TABLE OF VARCHAR2(5); 
v_agazat_type_a t_agazat_type_a; 

TYPE t_column_type_a IS TABLE OF all_tab_columns%ROWTYPE; -- ÉLES
v_column_type_a t_column_type_a; 

sql_statement VARCHAR2(500);
v_arindex_table VARCHAR2(500);
agazat_is_null NUMBER;

table_gfcf VARCHAR2(30) := ''|| v_gfcf_table ||'';
table_gfcf_out VARCHAR2(30) := ''|| v_gfcf_out_table ||'';
t_rate_m VARCHAR2(30) := ''|| table_rate_m ||'';
v_lanc VARCHAR2(30) := ''|| v_arindex_lanc ||'';
v_bazis VARCHAR2(30) := ''|| v_arindex_1999 ||'';
v_compare_t VARCHAR2(30) := ''|| v_compare ||'';
v_date VARCHAR2(30);
version_num NUMBER;

BEGIN

v_logging := 'LOGGING';

GFCF_num := GFCF_EV;

V_SZEKTOR(1) := 'S1311';
V_SZEKTOR(2) := 'S1313';
V_SZEKTOR(3) := 'S1314';
V_SZEKTOR(4) := 'S11';
V_SZEKTOR(5) := 'S12'; 
V_SZEKTOR(6) := 'S14';
V_SZEKTOR(7) := 'S15'; 
V_SZEKTOR(8) := 'S1311a';
V_SZEKTOR(9) := 'S1313a';

v_out_eszkozcsp(1) := 'AN112'; -- klasszikus --
v_out_eszkozcsp(2) := 'AN1131';	-- klasszikus --
v_out_eszkozcsp(3) := 'AN1139t'; -- klasszikus  --
v_out_eszkozcsp(4) := 'AN1139g'; -- klasszikus --
v_out_eszkozcsp(5) := 'AN1173s'; -- klasszikus --
v_out_eszkozcsp(6) := 'AN111';
v_out_eszkozcsp(7) := 'AN1173o';
v_out_eszkozcsp(8) := 'AN1174';
v_out_eszkozcsp(9) := 'AN1123';
v_out_eszkozcsp(10) := 'AN1171';
v_out_eszkozcsp(11) := 'AN114';
v_out_eszkozcsp(12) := 'AN1131w';
v_out_eszkozcsp(13) := 'AN1139k';
v_out_eszkozcsp(14) := 'AN1174t';
v_out_eszkozcsp(15) := 'AN1174a';
v_out_eszkozcsp(16) := 'AN112n';

v_out_name(1) := 'EPULET'; -- klasszikus
v_out_name(2) := 'JARMU';		-- klasszikus
v_out_name(3) := 'TARTOSGEP';	-- klasszikus
v_out_name(4) := 'GYORSGEP';	-- klasszikus
v_out_name(5) := 'SZOFTVER';	-- klasszikus
v_out_name(6) := 'LAKAS';	
v_out_name(7) := 'OWNSOFT';	
v_out_name(8) := 'ORIGINALS';	
v_out_name(9) := 'FOLDJAVITAS';	
v_out_name(10) := 'K_F';
v_out_name(11) := 'FEGYVER';
v_out_name(12) := 'WIZZ';
v_out_name(13) := 'KISERTEKU';
v_out_name(14) := 'TCF';
v_out_name(15) := 'EGYEB_ORIG';
v_out_name(16) := 'NOE6';


--klasszikus eszközök:
--S11 esetén 36->361-be átmigrálandó mezők
--S1311 esetén 42->421, 71->711, 82->821, 85->851, 84->841-be sorolandó mezők
--S1313 esetén 84->841-be sorolandó mezők
v_out_name_cl(1) := 'EPITES';
v_out_name_cl(2) := 'BELFOLDI_GEP';
v_out_name_cl(3) := 'BELFOLDI_JARMU';
v_out_name_cl(4) := 'IMPORT_GEP';
v_out_name_cl(5) := 'IMPORT_JARMU';
v_out_name_cl(6) := 'HASZNALT_EPULET_VASARLAS';
v_out_name_cl(7) := 'HASZNALT_EPULET_ERTEKESITES';
v_out_name_cl(8) := 'EPULET_ATVET';
v_out_name_cl(9) := 'EPULET_ATADAS';
v_out_name_cl(10) := 'HASZN_GEP_VASARLAS';
v_out_name_cl(11) := 'HASZN_GEP_ERTEKESITES';
v_out_name_cl(12) := 'GEP_ATVET';
v_out_name_cl(13) := 'GEP_ATAD';
v_out_name_cl(14) := 'HASZN_JARMU_VASARLAS';
v_out_name_cl(15) := 'HASZN_JARMU_ERTEKESITES';
v_out_name_cl(16) := 'JARMU_ATVET';
v_out_name_cl(17) := 'JARMU_ATAD';
v_out_name_cl(18) := 'EPULET_PENZUGYI_LIZING';
v_out_name_cl(19) := 'JARMU_PENZUGYI_LIZING';
v_out_name_cl(20) := 'GEP_PENZUGYI_LIZING';
v_out_name_cl(21) := 'GEP';
v_out_name_cl(22) := 'TARTOSGEP';
v_out_name_cl(23) := 'GYORSGEP';
v_out_name_cl(24) := 'EPULET';
v_out_name_cl(25) := 'JARMU';
v_out_name_cl(26) := 'SZOFTVER';
v_out_name_cl(27) := 'VASAROLT_SZAMITOGEPES_SZ';
v_out_name_cl(28) := 'VASAROLT_SZAMITOGEPES_DB';


procName := 'GFCF to INV2';
v_arindex_table := ''||v_arindex_1999 ||'';


-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate 1999 price', '');

sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'';
EXECUTE IMMEDIATE sql_statement INTO v1;

	IF v1 > 0 THEN

-- 1. lépés: hozzunk létre új mezőket a GFCF táblában

	CFC_IMPORT.add_columns(''|| schema_name ||'', ''|| v_gfcf_out_table ||'');

	COMMIT;
	
-- 2. lépés: a GFCF táblában a S1311 esetében a következők kerülnek összevonásra:
		-- 03,81->01
		-- 37,39->38
		-- 74->72
		-- minden más 841-be (ezt a compare résznél kezeljük)
			
	sql_statement := 'SELECT * FROM all_tab_columns WHERE table_name = '''|| v_gfcf_out_table ||''' AND OWNER = '''|| schema_name ||''' AND
	column_name NOT IN (''SZEKTOR'', ''ALSZEKTOR'', ''AGAZAT'', ''EGYEB'') '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_column_type_a;

	FOR a IN v_column_type_a.FIRST..v_column_type_a.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_column_type_a(a).column_name ||''; 
	--	DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
	END LOOP;
		
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1311''
		AND a.AGAZAT IN (''01'', ''03'', ''81'')
		)
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''01''
		'
		;
		
		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1311''
		AND a.AGAZAT IN (''74'', ''72'')
		)
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''72''
		'
		;

		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1311''
		AND a.AGAZAT IN (''37'', ''38'', ''39'')
		)
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''38''
		'
		;
				
	END LOOP;
	
	COMMIT;

	-- az átmásolt ágazatok esetében 0 értéket írunk be, de csak azokban a mezőkben, ahol alapból volt érték (nem NULL volt)
	v_agazat(1) := '03';
	v_agazat(2) := '74';
	v_agazat(3) := '37';
	v_agazat(4) := '39';
	v_agazat(5) := '81';
	
	FOR y IN 1..v_agazat.COUNT LOOP  
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
			sql_statement := 'SELECT COUNT('|| V_AGAZAT_IMP(j) ||') FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE '|| V_AGAZAT_IMP(j) ||' IS NOT NULL AND AGAZAT = '''|| v_agazat(y) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| V_AGAZAT_IMP(j) ||' = ''0''
				WHERE ALSZEKTOR = ''S1311''
				AND AGAZAT = '''|| v_agazat(y) ||'''
				'
				;
				
			END IF;
			
		END LOOP;
		
	END LOOP;
	
	COMMIT;

	-- S1313 esetén: 
		-- 01, 03 -> 81
		-- 78 -> 71
		
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1313''
		AND a.AGAZAT IN (''01'', ''03'', ''81'')
		)
		WHERE ALSZEKTOR = ''S1313''
		AND AGAZAT = ''81''
		'
		;

		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1313''
		AND a.AGAZAT IN (''78'', ''71'')
		)
		WHERE ALSZEKTOR = ''S1313''
		AND AGAZAT = ''71''
		'
		;
		
	END LOOP;
	
	COMMIT;

	-- az átmásolt ágazatok esetében 0 értéket írunk be, de csak azokban a mezőkben, ahol alapból volt érték (nem NULL volt)
	v_agazat(1) := '01';
	v_agazat(2) := '03';
	v_agazat(3) := '78';
	
	FOR y IN 1..3 LOOP  
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
			sql_statement := 'SELECT COUNT('|| V_AGAZAT_IMP(j) ||') FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE '|| V_AGAZAT_IMP(j) ||' IS NOT NULL AND AGAZAT = '''|| v_agazat(y) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| V_AGAZAT_IMP(j) ||' = ''0''
				WHERE ALSZEKTOR = ''S1313''
				AND AGAZAT = '''|| v_agazat(y) ||'''
				'
				;
				
			END IF;
			
		END LOOP;
		
	END LOOP;

	COMMIT;
	
-- 3. lépés: a GFCF táblában 3 jegyű ágazatok létrehozása S11 esetében:
	
	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S11'' AND AGAZAT = ''361'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S11'', ''S11'', ''361'')
			'
			;
		
		
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||',0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S11''
			AND a.AGAZAT = ''36'')
			WHERE ALSZEKTOR = ''S11''
			AND AGAZAT = ''361''
			'
			;		

		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S11''
			AND AGAZAT = ''36''
			'
			;		

		END LOOP;
		
	END IF;
	
	COMMIT;
	
	-- a GFCF táblában 3 jegyű ágazatok létrehozása S1311 esetében:
		
	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''421'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''421'')
			'
			;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''42'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''421''
			'
			;	

		END LOOP;
		
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''42''
			'
			;		

		END LOOP;
		
		END IF;
		
		COMMIT;
	
	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''711'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''711'')
			'
			;
			
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''71'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''711''
			'
			;
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''71''
			'
			;		

		END LOOP;
		
		END IF;
		
		COMMIT;

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''821'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''821'')
			'
			;
			
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''82'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''821''
			'
			;			
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''82''
			'
			;		

		END LOOP;

		END IF;
		
		COMMIT;

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''851'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''851'')
			'
			;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  			
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''85'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''851''
			'
			;			
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''85''
			'
			;		

		END LOOP;
		
		END IF;
		
		COMMIT;
		
-- S1311 esetén FEGYVER mező 84->841, GRIPPEN mező 84->FEGYVER 846

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''846'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT, EGYEB)
			VALUES (''S13'', ''S1311'', ''846'', ''GRIPEN'')
			'
			;
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET FEGYVER = (SELECT NVL(a.FEGYVER, 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''841''
			'
			;			

			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET FEGYVER = (SELECT NVL(a.GRIPPEN, 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''846''
			'
			;	

			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			SET FEGYVER = ''0''
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84''
			'
			;	

			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			SET GRIPPEN = ''0''
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84''
			'
			;				
			
		END IF;
		
		COMMIT;

-- 841 esetén S1311 és S1313-ban is létrehozzuk:
FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
	
	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' AND AGAZAT = ''841'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
		
		IF ''|| V_SZEKTOR(a) ||'' IN ('S1311', 'S1313') THEN
		
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', '''|| V_SZEKTOR(a) ||''', ''841'')
			'
			;
			
		END IF;
		
		END IF;
		
		IF ''|| V_SZEKTOR(a) ||'' IN ('S1311', 'S1313') THEN
		
		FOR j IN 1..v_out_name_cl.COUNT LOOP  			
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND a.AGAZAT = ''84'')
			WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND AGAZAT = ''841''
			'
			;			
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND AGAZAT = ''84''
			'
			;		

		END LOOP;	

		END IF;

END LOOP;

COMMIT;
		

-- 4. lépés: a GFCF táblában létrehozunk egy JÁRMŰ oszlopot: 
	-- S11, S12, S1311, S1313, S14, S15: (((BELFOLDI_JARMU + IMPORT_JARMU) + (HASZN_JARMU_VASARLAS * 0.07) + (JARMU_ATVET * 0.07) + JARMU_PENZUGYI_LIZING)
	-- S1314:  (((BELFOLDI_JARMU + IMPORT_JARMU) + (HASZN_JARMU_VASARLAS * 0.068048) + (JARMU_ATVET * 0.040328) + JARMU_PENZUGYI_LIZING)
	
	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
	
		CFC_IMPORT.gfcf_imp_jarmu(''|| v_gfcf_out_table ||'', ''|| schema_name ||'' , ''|| V_SZEKTOR(a) ||''); 
	
	END LOOP;
	
	COMMIT;
				
	-- S1311-ben a 841-es ágazatból még ki kell vonni a GRIPEN értéket

		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		SET JARMU = 
		(SELECT (NVL(JARMU, 0)) - (NVL((SELECT FEGYVER FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE AGAZAT = ''846'' AND ALSZEKTOR = ''S1311''), 0))
		FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''841'')
		WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''841'' 
		'
		; 
		
	COMMIT;
		

-- 5. lépés: a GFCF táblában létrehozunk egy EPULET oszlopot: 
	-- S11, S12, S1311, S1313, S14, S15: EPITES + (hasznalt_epulet_vasarlas * 0.04) + (epulet_atvet * 0.04) + epulet_penzugyi_lizing - LAKAS (a LAKAS-t csak a 68-as ágazatból kell kivonni)
	-- S1314: EPITES + (hasznalt_epulet_vasarlas * 0.087359) + (epulet_atvet * 0.040309) + epulet_penzugyi_lizing
	
	
	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
	
		CFC_IMPORT.gfcf_imp_epulet(''|| v_gfcf_out_table ||'', ''|| schema_name ||'' , ''|| V_SZEKTOR(a) ||''); 
		
	END LOOP;
	
	COMMIT;
		
			
-- 6. lépés: a GFCF táblában létrehozunk egy OWNSOFT oszlopot: 
	-- SAJAT_SZAMITOGEPES_SZ + SAJAT_SZAMITOGEPES_DB
	-- a GFCF táblában létrehozunk egy SZOFTVER oszlopot: 
	-- VASAROLT_SZAMITOGEPES_SZ + VASAROLT_SZAMITOGEPES_DB

	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
		
		CFC_IMPORT.gfcf_imp_ownsoft(''|| v_gfcf_out_table ||'', ''|| schema_name ||'' , ''|| V_SZEKTOR(a) ||''); 
		
	END LOOP;
	
	COMMIT;
		
	
	--7 .lépés: létrehozzuk a GEP mezőket, de még nem számoljuk át az arányokat TARTOSGEP-re és GYORSGEP-re, mert előzőleg a GEP 841-es ágazatba a 8-as lépésben még át kell tenni a többi ágazat értékét
	
	MACHINE_DIVIDE.machine_divide(''|| table_gfcf_out ||'', ''|| t_rate_m ||'', '0');
	
	COMMIT;
	
	-- 8. lépés: 
	-- meg kell vizsgálni, hogy a GFCF táblában van-e olyan rekord, ahol van érték, de az INV2-ben nincsen 
	-- ezek bekerülnek a 841/84-es ágazatba S1311, S1313, S1313a esetében
	-- S1311a esetében 39-es ágazatba menjenek az 37 és 39-es ágazat adatai, minden más az 84-be

EXECUTE IMMEDIATE'
DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'
';
COMMIT;

v_out_name(3) := 'GEP';	

FOR b IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP

	-- nézzük meg, hogy az INV2 táblában van-e olyan szektor amit keresünk, ha nincs akkor ne is fusson le
	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(b) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN
	
		FOR a IN v_out_name.FIRST..v_out_name.LAST LOOP
			
		-- nézzük meg, hogy az INV2 táblában van-e olyan eszközcsoport amit keresünk, ha nincs, akkor ne is fusson le
		sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(b) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(a) ||''' ';
		EXECUTE IMMEDIATE sql_statement INTO v;
		
		IF v > 0 THEN		
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| schema_name ||'.'|| v_compare_t ||' (AGAZAT, ALSZEKTOR, ESZKOZCSP)
			
			(SELECT AGAZAT, '''|| V_SZEKTOR(b) ||''', '''|| v_out_eszkozcsp(a) ||'''
			FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
			WHERE '|| v_out_name(a) ||' IS NOT NULL AND '|| v_out_name(a) ||' != ''0''
			AND ALSZEKTOR = '''|| V_SZEKTOR(b) ||'''
			
			MINUS

			SELECT AGAZAT, '''|| V_SZEKTOR(b) ||''', '''|| v_out_eszkozcsp(a) ||'''
			FROM '|| schema_name ||'.'|| v_inv2_table ||'
			WHERE ESZKOZCSP = '''|| v_out_eszkozcsp(a) ||'''
			AND ALSZEKTOR = '''|| V_SZEKTOR(b) ||''')
			'
			;
		
		END IF;
		
		END LOOP;
	
	END IF;
	
END LOOP;

COMMIT;

	--S1311 esetén a következő ágazatokat nem kell figyelni: 03, 37, 38, 42, 71, 74, 81, 82, 85
	--S1313 esetén a következő ágazatokat nem kell figyelni: 03, 78
	--S11 esetén a következő ágazatokat nem kell figyelni: 36
	--S1311/AN1171 (K+F) esetén a következő ágazatokat nem kell figyelni: 72
	--S1311 és S1313 esetén FÖLDJAVÍTÁS (AN1123) nem kell figyelni, azt külön kezeljük
	
	EXECUTE IMMEDIATE'
	DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'
	WHERE ALSZEKTOR = ''S11''
	AND AGAZAT = ''36''
	'
	;
		
	EXECUTE IMMEDIATE'
	DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'
	WHERE ALSZEKTOR = ''S1311'' 
	AND AGAZAT IN (''03'', ''37'', ''38'', ''42'', ''71'', ''74'', ''81'', ''82'', ''85'', ''846'')
	'
	;

	EXECUTE IMMEDIATE'
	DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'
	WHERE AGAZAT = ''72''
	AND ALSZEKTOR = ''S1311''
	AND ESZKOZCSP = ''AN1171''
	'
	;
	
	EXECUTE IMMEDIATE'
	DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'
	WHERE AGAZAT IN (''03'', ''78'')
	AND ALSZEKTOR = ''S1313''
	'
	;	

	EXECUTE IMMEDIATE'
	DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'
	WHERE ALSZEKTOR IN (''S1311'', ''S1313'') AND ESZKOZCSP = ''AN1123''
	'
	;	

COMMIT;
	
-- a COMPARE tábla értékeit elmentjük a C_IMP_COMPARE_évszám táblába, hogy a későbbiek számára meglegyen

	SELECT COUNT(*) INTO v FROM all_tables where table_name = UPPER(''|| v_compare_t ||'_'|| GFCF_EV ||'');

		IF v=0 THEN

			EXECUTE IMMEDIATE'
			CREATE TABLE '|| schema_name ||'.'|| v_compare_t ||'_'|| GFCF_EV ||'
			("AGAZAT" VARCHAR2(5 BYTE), 
			"ALSZEKTOR" VARCHAR2(20 BYTE), 
			"ESZKOZCSP" VARCHAR2(20 BYTE)
			)
			'
			;
				
		ELSE

			EXECUTE IMMEDIATE'
			DELETE FROM '|| schema_name ||'.'|| v_compare_t ||'_'|| GFCF_EV ||'
			'
			;
	
		END IF;
	
	EXECUTE IMMEDIATE'
	INSERT INTO '|| schema_name ||'.'|| v_compare_t ||'_'|| GFCF_EV ||'
	(SELECT * FROM '|| schema_name ||'.'|| v_compare_t ||')
	'
	;

COMMIT;
	
FOR z IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP 
	
	-- csak az S1311 és S1313 alszektorokra futtatjuk le: minden eltérő elem a 841-be megy
	IF ''|| V_SZEKTOR(z) ||'' IN ('S1311', 'S1313') THEN 
		
	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;	
				
	IF v > 0 THEN
	
	DBMS_OUTPUT.put_line('Eltérés van a GFCF tábla és az INV2 tábla ágazatai között a futtatott eszközcsoport és alszektor esetében, az eltérő elemek bekerülnek a 84/841-es ágazatba.');

	sql_statement := 'SELECT * FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_compare_a;

	FOR a IN v_compare_a.FIRST..v_compare_a.LAST LOOP 
		DBMS_OUTPUT.put_line('Az eltérések: ÁGAZAT: '|| v_compare_a(a).AGAZAT ||' _ ALSZEKTOR: '|| v_compare_a(a).ALSZEKTOR ||' - ESZKOZCSP: '|| v_compare_a(a).ESZKOZCSP ||' ');  
	END LOOP;
	
	-- ha van eltérés, akkor minden mezőérték bekerül S1311 és S1313 esetén a 841-es ágazatba klasszikus eszközcsoportok esetén
		
		FOR j IN v_out_name.FIRST..5 LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''841'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''')
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''841''
				'
				;
			
		
			END IF;

		END LOOP;
		
		COMMIT;
		
		FOR j IN v_out_name.FIRST..5 LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
					AND AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;
		
		COMMIT;


	-- ha van eltérés, akkor minden mezőérték bekerül S1311 és S1313 esetén a 84-es ágazatba NEM klasszikus eszközcsoportok esetén
		
		FOR j IN 6..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''84'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''')
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''84''
				'
				;
				
			END IF;
					
		END LOOP;
		
		COMMIT;
		
		FOR j IN 6..v_out_name.LAST LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
					AND AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;
		
		COMMIT;
		
	END IF;
	
	
	
	-- S1313a esetén minden eltérő elem a 84-be megy
	ELSIF ''|| V_SZEKTOR(z) ||'' = 'S1313a' THEN

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;	
				
	IF v > 0 THEN
	
	DBMS_OUTPUT.put_line('Eltérés van a GFCF tábla és az INV2 tábla ágazatai között a futtatott eszközcsoport és alszektor esetében, az eltérő elemek bekerülnek a 84-es ágazatba.');


	sql_statement := 'SELECT * FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_compare_a;

	FOR a IN v_compare_a.FIRST..v_compare_a.LAST LOOP 
		DBMS_OUTPUT.put_line('Az eltérések: ÁGAZAT: '|| v_compare_a(a).AGAZAT ||' _ ALSZEKTOR: '|| v_compare_a(a).ALSZEKTOR ||' - ESZKOZCSP: '|| v_compare_a(a).ESZKOZCSP ||' ');  
	END LOOP;
	
	-- ha van eltérés, akkor minden mezőérték bekerül S1313a esetén a 84-es ágazatba klasszikus eszközcsoportok esetén
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND AGAZAT = ''84'') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''')
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''84''
				'
				;
			
		
			END IF;

		END LOOP;
		
		COMMIT;
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' 
					AND AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;
		
		COMMIT;

	-- S1311a: minden eltérő elem a 84-be megy, 37 és 39 a 39-be megy
	ELSIF ''|| V_SZEKTOR(z) ||'' = 'S1311a' THEN 

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;	
				
	IF v > 0 THEN
	
	DBMS_OUTPUT.put_line('Eltérés van a GFCF tábla és az INV2 tábla ágazatai között a futtatott eszközcsoport és alszektor esetében, az eltérő elemek bekerülnek a 84-es ágazatba, 37 ás 39-es ágazat esetén a 39-es ágazatba kerülnek.');


	sql_statement := 'SELECT * FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_compare_a;

	FOR a IN v_compare_a.FIRST..v_compare_a.LAST LOOP 
		DBMS_OUTPUT.put_line('Az eltérések: ÁGAZAT: '|| v_compare_a(a).AGAZAT ||' _ ALSZEKTOR: '|| v_compare_a(a).ALSZEKTOR ||' - ESZKOZCSP: '|| v_compare_a(a).ESZKOZCSP ||' ');  
	END LOOP;
	
	-- ha van eltérés, akkor minden mezőérték bekerül S1311a esetén a 84-es ágazatba klasszikus eszközcsoportok esetén, kivéve 37 és 39-es ágazat
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT NOT IN (''37'', ''39'') ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''84'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT NOT IN (''37'', ''39''))
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''84''
				'
				;
			
		
			END IF;

		END LOOP;
		
		COMMIT;

	-- ha van eltérés, akkor minden mezőérték bekerül S1311a esetén a 39-es ágazatba klasszikus eszközcsoportok esetén, 37 és 39-es ágazat esetében
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT IN (''37'', ''39'') ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''39'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT IN (''37'', ''39''))
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''39''
				'
				;
						
		
			END IF;

		END LOOP;
		
		COMMIT;
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM '|| schema_name ||'.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' 
					AND AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;
	
	END IF;
	
	END IF;
		
	END IF;
				
END LOOP;

COMMIT;

-- FÖLDJAVÍTÁS
	-- S1313 esetén minden érték, ami egyéb ágazatokban van (kivéve 84) -> 39-es ágazatba kerül
	-- S1311 esetén minden érték, ami egyéb ágazatokban van -> 84-es ágazatba kerül
	
	-- S1313
	EXECUTE IMMEDIATE'
	UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = 
	(
	SELECT sum(NVL(FOLDJAVITAS, 0)) 
	FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
	WHERE ALSZEKTOR = ''S1313''	AND AGAZAT != ''84''			
	)
	WHERE ALSZEKTOR = ''S1313'' AND AGAZAT = ''39''
	'
	;			
	

	EXECUTE IMMEDIATE'
	UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = ''0''
	WHERE ALSZEKTOR = ''S1313'' AND AGAZAT NOT IN (''39'', ''84'')	
	'
	;

	-- S1311
	EXECUTE IMMEDIATE'
	UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = 
	(
	SELECT sum(NVL(FOLDJAVITAS, 0)) 
	FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
	WHERE ALSZEKTOR = ''S1311''				
	)
	WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''84''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = ''0''
	WHERE ALSZEKTOR = ''S1311'' AND AGAZAT NOT IN (''84'')	
	'
	;
	
v_out_name(3) := 'TARTOSGEP';	

	COMMIT;
	
-- 9. lépés: itt kell meghívni a MACHINE_DIVIDE eljárást, mivel a gépekhez kapcsoldó adatokat is létre kell hozni
			
	MACHINE_DIVIDE.machine_divide(''|| table_gfcf_out ||'', ''|| t_rate_m ||'', '1');

	COMMIT;
	
-- 10. lépés: a GFCF tábla adatait 1999-es árra átszámítjuk
	
-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate 1999 price', '');

-- kiszámítjuk az 1999-es árat minden ágazatra	

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
	sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' '; 
		
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;
	
	FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP
	
		FOR j IN 1..v_agazat_type_g.COUNT LOOP  

			CFC_IMPORT.gfcf_imp_1999(''|| GFCF_EV ||'', ''|| v_gfcf_out_table ||'', ''|| v_arindex_1999 ||'', ''|| schema_name ||'', ''|| v_out_name(b) ||'', ''|| v_out_eszkozcsp(b) ||'', ''|| v_szektor(a) ||'', ''|| v_agazat_type_g(j) ||'');
		
		END LOOP;
	
	END LOOP;
	
END LOOP;

COMMIT;
 
-- 11.lépés: meglévő INV2 táblába történő beillesztés
	
-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Put in INV2', '');

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('Y'|| GFCF_EV ||'') AND table_name = ''|| v_inv2_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
				
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_inv2_table ||'
		ADD Y'|| GFCF_EV ||' NUMBER
		'
		; 
	
	END IF;

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP

	FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP
	
		sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' 
		AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 
			
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;

		-- szektoronként beillesztük a mezőbe az értékeket a GFCF táblából	
		FOR k IN 1..v_agazat_type_g.COUNT LOOP  

			CFC_IMPORT.gfcf_imp_inv2(''|| GFCF_EV ||'', ''|| v_gfcf_out_table ||'', ''|| schema_name ||'', ''|| v_out_name(b) ||'', ''|| v_out_eszkozcsp(b) ||'', ''|| v_szektor(a) ||'', ''|| v_agazat_type_g(k) ||'', ''|| v_inv2_table ||'');
			
		END LOOP;
		
	END LOOP;

END LOOP;
	
COMMIT;
	
-- 12. lépés: az LT táblát is még ki kell egészíteni, az aktuális évbe be kell másolni a tavalyi év adatait
-- csak 2016-os évtől kezdődően, az előtt nem módosítunk

	IF ''|| version_to_run ||'' != 'v3' THEN

		IF ''|| GFCF_num ||'' >= 2017 THEN

		SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('Y'|| GFCF_EV ||'') AND table_name = ''|| v_lifetime_table ||'' AND OWNER = ''|| schema_name ||'';
		
		IF v=0 THEN
					
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| schema_name ||'.'|| v_lifetime_table ||'
			ADD Y'|| GFCF_EV ||' NUMBER
			'
			; 
		
		END IF;	

		EXECUTE IMMEDIATE'
		UPDATE '|| schema_name ||'.'|| v_lifetime_table ||'
		SET Y'|| GFCF_EV ||' = Y'|| GFCF_minus ||'
		'
		;
		
		END IF;
		
	END IF;
	
	COMMIT;
	

INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'ÁR START', '');

	
-- 13. lépés: hozzunk létre egy új mezőt az aktuális árhoz az ÁR BÁZIS táblában

IF ''|| version_to_run ||'' != 'v3' THEN

	IF ''|| GFCF_num ||'' >= 2017 THEN

		SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('Y'|| GFCF_plus ||'_1999') AND table_name = ''|| v_arindex_1999 ||'' AND OWNER = ''|| schema_name ||'';
		
		IF v=0 THEN
			
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| schema_name ||'.'|| v_arindex_1999 ||'
			ADD Y'|| GFCF_plus ||'_1999 NUMBER
			'
			;
		
		END IF;
		
		COMMIT;
		
	-- az ÁR BÁZIS táblában ki kell számolni az aktuális évre vonatkozó árindexet (forrás: GFCF_20xx_AR tábla értéke * az előző évi árindex értéke / 100)

	--IF v=0 THEN

	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP

	IF V_SZEKTOR(a) = 'S1311' THEN
	v_out_name(10) := 'K_F_S13';
	ELSIF V_SZEKTOR(a) = 'S1313' THEN
	v_out_name(10) := 'K_F_S13';
	ELSIF V_SZEKTOR(a) = 'S1311a' THEN
	v_out_name(10) := 'K_F_S13';
	ELSIF V_SZEKTOR(a) = 'S1313a' THEN
	v_out_name(10) := 'K_F_S13';
	ELSIF V_SZEKTOR(a) = 'S11' THEN
	v_out_name(10) := 'K_F_S11';
	ELSIF V_SZEKTOR(a) = 'S15' THEN
	v_out_name(10) := 'K_F_S15';
	END IF;
		
		FOR b IN v_out_eszkozcsp.FIRST..v_out_eszkozcsp.LAST LOOP
		
			SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER(''|| v_out_name(b) ||'') AND table_name = ''|| v_gfcf_ar_table ||'' AND OWNER = ''|| schema_name ||'';
			IF v > 0 THEN
		
			sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_arindex_1999 ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 
		
			EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;
		
			FOR j IN 1..v_agazat_type.COUNT LOOP  

				EXECUTE IMMEDIATE' 
				UPDATE '|| schema_name ||'.'|| v_arindex_1999 ||'
				SET Y'|| GFCF_plus ||'_1999 = 
				(SELECT a.Y'|| GFCF_EV ||'_1999 * b.'|| v_out_name(b) ||' / 100
				FROM '|| schema_name ||'.'|| v_arindex_1999 ||' a
				INNER JOIN '|| schema_name ||'.'|| v_gfcf_ar_table ||' b 
				ON a.AGAZAT = b. AGAZAT 
				WHERE a.AGAZAT = '''|| v_agazat_type(j) ||'''
				AND a.ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' AND a.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' 
				)
				WHERE AGAZAT = '|| v_agazat_type(j) ||' AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' 
				AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' 
				'
				; 
				
			END LOOP;
			
			COMMIT;
			
			END IF;
			
		END LOOP;

		-- GRIPEN esetén a GFCF_AR tábla GRIPEN mezőjéből vesszük át az AR_LANC tábla AN114/846-os AGAZAT-ba az értéket
		IF V_SZEKTOR(a) = 'S1311' THEN
							
			EXECUTE IMMEDIATE'					
			UPDATE '|| schema_name ||'.'|| v_arindex_1999 ||'
			SET Y'|| GFCF_plus ||'_1999 = 
			(SELECT Y'|| GFCF_EV ||'_1999 * 
			(SELECT GRIPPEN 
			FROM '|| schema_name ||'.'|| v_gfcf_ar_table ||'
			WHERE AGAZAT = ''84'')
			/ 100
			FROM '|| schema_name ||'.'|| v_arindex_1999 ||'
			WHERE AGAZAT = ''84'' AND ALSZEKTOR = ''S1311'' AND ESZKOZCSP = ''AN114''			)
			WHERE AGAZAT = ''846'' AND ALSZEKTOR = ''S1311'' AND ESZKOZCSP = ''AN114''
			'
			;
		
		END IF;
		
	END LOOP;
		
	--END IF;

				--az ár lánc táblát is módosítsuk:
				-- EXECUTE IMMEDIATE'
				-- UPDATE '|| v_out_schema ||'.'|| v_lanc ||'
				-- SET Y'|| GFCF_plus ||'_'|| GFCF_EV ||' = 
				-- (SELECT a.'|| v_out_name(b) ||' / 100
				-- FROM '|| v_out_schema ||'.'|| v_gfcf_ar_table ||' a
				-- INNER JOIN '|| v_out_schema ||'.'|| v_lanc ||' b
				-- ON a.AGAZAT = b.AGAZAT 
				-- WHERE a.AGAZAT = '''|| v_agazat_type(j) ||''' AND b.ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' AND b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' 
				-- )
				-- WHERE AGAZAT = '''|| v_agazat_type(j) ||''' AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' 
				-- '
				-- ;

				
		SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('Y'|| GFCF_plus ||'_'|| GFCF_EV ||'') AND table_name = ''|| v_lanc ||'' AND OWNER = ''|| schema_name ||'';
		
		IF v=0 THEN
			
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| schema_name ||'.'|| v_lanc ||'
			ADD Y'|| GFCF_plus ||'_'|| GFCF_EV ||' NUMBER
			'
			; 
		
		END IF;
		
				
	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
				
		FOR b IN v_out_eszkozcsp.FIRST..v_out_eszkozcsp.LAST LOOP
		
			SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER(''|| v_out_name(b) ||'') AND table_name = ''|| v_gfcf_ar_table ||'';
			IF v > 0 THEN
				
			sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_ar_table ||' '; 

			EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;

			FOR j IN 1..v_agazat_type.COUNT LOOP  

				EXECUTE IMMEDIATE' 
				UPDATE '|| schema_name ||'.'|| v_lanc ||'
				SET Y'|| GFCF_plus ||'_'|| GFCF_EV ||' = 
				(SELECT '|| v_out_name(b) ||' / 100
				FROM '|| schema_name ||'.'|| v_gfcf_ar_table ||'
				WHERE AGAZAT = '''|| v_agazat_type(j) ||''')
				WHERE AGAZAT = '''|| v_agazat_type(j) ||''' AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
				'
				;
				
			END LOOP;
			
			END IF;
			
		END LOOP;

		-- GRIPEN esetén a GFCF_AR tábla GRIPEN mezőjéből vesszük át az AR_LANC tábla AN114/846-os AGAZAT-ba az értéket
		IF V_SZEKTOR(a) = 'S1311' THEN
				
			EXECUTE IMMEDIATE'					
			UPDATE '|| schema_name ||'.'|| v_lanc ||'
			SET Y'|| GFCF_plus ||'_'|| GFCF_EV ||' = 
			(
			SELECT GRIPPEN / 100
			FROM '|| schema_name ||'.'|| v_gfcf_ar_table ||'
			WHERE AGAZAT = ''84''
			)
			WHERE AGAZAT = ''846'' AND ALSZEKTOR = ''S1311'' AND ESZKOZCSP = ''AN114''
			'
			;
			
		END IF;
		
	END LOOP;

	END IF; -- 2017-től

END IF;

 ELSE
 
	dbms_output.put_line('Üres a GFCF tábla!');
 
 END IF;


v_out_name(10) := 'K_F';

COMMIT;

-- hozzuk létre a bázis árindex alapján (amit előbb egészítettünk ki az aktuális évvel) a lánc árindex táblát is újra -- 2017-től nem kell futtatni, csak a végén lévő 42-> 41 másolás miatt kell

--CFC_ARINDEX.CFC_ARINDEX(''|| v_lanc ||'', ''|| v_bazis ||'');

INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'END', '');

END gfcf_imp_alt;



PROCEDURE add_columns(schema_name VARCHAR2, v_gfcf_out_table VARCHAR2) AS

v NUMBER;
v1 NUMBER;
sql_statement VARCHAR2(3000);

BEGIN

v_out_name(1) := 'EPULET'; -- klasszikus
v_out_name(2) := 'JARMU';		-- klasszikus
v_out_name(3) := 'TARTOSGEP';	-- klasszikus
v_out_name(4) := 'GYORSGEP';	-- klasszikus
v_out_name(5) := 'SZOFTVER';	-- klasszikus
v_out_name(6) := 'LAKAS';	
v_out_name(7) := 'OWNSOFT';	
v_out_name(8) := 'ORIGINALS';	
v_out_name(9) := 'FOLDJAVITAS';	
v_out_name(10) := 'K_F';
v_out_name(11) := 'FEGYVER';
v_out_name(12) := 'WIZZ';
v_out_name(13) := 'KISERTEKU';
v_out_name(14) := 'TCF';
v_out_name(15) := 'EGYEB_ORIG';
v_out_name(16) := 'NOE6';

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('JARMU') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
		
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD JARMU NUMBER
		'
		; 
	
	END IF;

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('OWNSOFT') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD OWNSOFT NUMBER
		'
		;
		
	END IF;	

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('SZOFTVER') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD SZOFTVER NUMBER
		'
		;

		
	END IF;

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('EPULET') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD EPULET NUMBER
		'
		;
		
	END IF;
	

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('GEP') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD GEP NUMBER
		'
		;

		
	END IF;

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('TARTOSGEP') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD TARTOSGEP NUMBER
		'
		;
		
	END IF;

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('GYORSGEP') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
		ADD GYORSGEP NUMBER
		'
		;
		
	END IF;
	
--IF v_eszkozcsp != 'CLASSIC' THEN 

	SELECT COUNT(*) INTO v FROM all_tab_cols WHERE column_name = UPPER('EPULET_1999') AND table_name = ''|| v_gfcf_out_table ||'' AND OWNER = ''|| schema_name ||'';
	
	IF v = 0 THEN 
			
		FOR a IN v_out_name.FIRST..v_out_name.LAST LOOP
			
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			ADD '|| v_out_name(a) ||'_1999 NUMBER
			'
			; 
			
		END LOOP;
				
	END IF;
	
	COMMIT;

END add_columns;


-- gfcf_imp_1999
PROCEDURE gfcf_imp_1999(GFCF_EV NUMBER, v_gfcf_out_table VARCHAR2, v_arindex_1999 VARCHAR2, schema_name VARCHAR2, v_o_name VARCHAR2, v_eszk VARCHAR2, v_szekt VARCHAR2, v_agazat VARCHAR2) AS  

BEGIN

	EXECUTE IMMEDIATE ' 
	UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
	SET '|| v_o_name ||'_1999 = 
	(SELECT 
		CASE b.Y'|| GFCF_EV ||'_1999
			WHEN 0 THEN a.'|| v_o_name ||'
			ELSE a.'|| v_o_name ||' / b.Y'|| GFCF_EV ||'_1999 
		END as '|| v_o_name ||'_1999
	
	FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' a
	INNER JOIN '|| schema_name ||'.'|| v_arindex_1999 ||' b
	ON a.AGAZAT = b.AGAZAT 
	WHERE a.AGAZAT = '''|| v_agazat ||'''
	AND a.ALSZEKTOR = '''|| v_szekt ||''' AND b.ALSZEKTOR = '''|| v_szekt ||''' 
	AND b.ESZKOZCSP = '''|| v_eszk ||''' 
	)
	WHERE AGAZAT = '''|| v_agazat ||''' AND ALSZEKTOR = '''|| v_szekt ||'''
	'
	;
		
END gfcf_imp_1999;


-- gfcf_imp_inv2
PROCEDURE gfcf_imp_inv2(GFCF_EV NUMBER, v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_o_name VARCHAR2, v_eszk VARCHAR2, v_szekt VARCHAR2, v_agazat VARCHAR2, v_inv2_table VARCHAR2) AS  

sql_statement VARCHAR2(3000);
agazat_is_null NUMBER;

BEGIN

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' 
	WHERE AGAZAT = '''|| v_agazat ||''' AND ALSZEKTOR = '''|| v_szekt ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO agazat_is_null;
	IF agazat_is_null > 0 THEN 

	sql_statement := 'SELECT '|| v_o_name ||'_1999 
	FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' 
	WHERE AGAZAT = '''|| v_agazat ||''' AND ALSZEKTOR = '''|| v_szekt ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO agazat_is_null;
	
	IF (agazat_is_null > 0 AND agazat_is_null IS NOT NULL) THEN

		EXECUTE IMMEDIATE '
		UPDATE '|| schema_name ||'.'|| v_inv2_table ||'
		SET Y'|| GFCF_EV ||' =
		(SELECT '|| v_o_name ||'_1999 
		FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' 
		WHERE ALSZEKTOR = '''|| v_szekt ||''' AND AGAZAT = '''|| v_agazat ||'''
		)
		WHERE AGAZAT = '''|| v_agazat ||''' AND ALSZEKTOR = '''|| v_szekt ||''' 
		AND ESZKOZCSP = '''|| v_eszk ||'''
		'
		;
		
	END IF;
	
	END IF;

END gfcf_imp_inv2;



-- gfcf_imp_jarmu
PROCEDURE gfcf_imp_jarmu(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_szekt VARCHAR2) AS  

TYPE t_agazat_type_a IS TABLE OF VARCHAR2(5); 
v_agazat_type_a t_agazat_type_a; 

sql_statement VARCHAR2(3000);

BEGIN


-- a GFCF táblában létrehozunk egy JÁRMŰ oszlopot: 
	-- S11, S12, S1311, S1313, S14, S15: (((BELFOLDI_JARMU + IMPORT_JARMU) + (HASZN_JARMU_VASARLAS * 0.07) + (JARMU_ATVET * 0.07) + JARMU_PENZUGYI_LIZING)
	-- S1314:  (((BELFOLDI_JARMU + IMPORT_JARMU) + (HASZN_JARMU_VASARLAS * 0.068048) + (JARMU_ATVET * 0.040328) + JARMU_PENZUGYI_LIZING)
	
	sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szekt ||''' '; 

		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_a;
		
		IF ''|| v_szekt ||'' = 'S11' THEN
			
			FOR j IN 1..v_agazat_type_a.COUNT LOOP  
			
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET JARMU = 
				(SELECT ((NVL(BELFOLDI_JARMU, 0) + NVL(IMPORT_JARMU, 0)) + (NVL(HASZN_JARMU_VASARLAS, 0) * 0.07) + (NVL(JARMU_ATVET, 0) * 0.07)
				+ NVL(JARMU_PENZUGYI_LIZING, 0)) - NVL(WIZZ, 0)
				FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = '''|| v_szekt ||'''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = '''|| v_szekt ||''' 
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;
		
			END LOOP;
				
		ELSIF ''|| v_szekt ||'' NOT IN ('S11', 'S1314') THEN
			
			FOR j IN 1..v_agazat_type_a.COUNT LOOP  
			
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET JARMU = 
				(SELECT (NVL(BELFOLDI_JARMU, 0) + NVL(IMPORT_JARMU, 0)) + (NVL(HASZN_JARMU_VASARLAS, 0) * 0.07) + (NVL(JARMU_ATVET, 0) * 0.07) 
				+ NVL(JARMU_PENZUGYI_LIZING, 0) 
				FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = '''|| v_szekt ||'''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = '''|| v_szekt ||''' 
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;
		
			END LOOP;
		
		ELSE
		
			FOR j IN 1..v_agazat_type_a.COUNT LOOP  	
		
				EXECUTE IMMEDIATE'
				UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
				SET JARMU = 
				(SELECT (NVL(BELFOLDI_JARMU, 0) + NVL(IMPORT_JARMU, 0)) + (NVL(HASZN_JARMU_VASARLAS, 0) * 0.068048) + (NVL(JARMU_ATVET, 0) * 0.040328) 
				+ NVL(JARMU_PENZUGYI_LIZING, 0) 
				FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = ''S1314''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = ''S1314''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;	
		
			END LOOP;
		
		END IF;

END gfcf_imp_jarmu;


-- gfcf_imp_epulet
PROCEDURE gfcf_imp_epulet(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_szekt VARCHAR2) AS  

TYPE t_agazat_type_a IS TABLE OF VARCHAR2(5); 
v_agazat_type_a t_agazat_type_a; 

sql_statement VARCHAR2(3000);

BEGIN

	sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szekt ||''' '; 

		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_a;
		
			IF ''|| v_szekt ||'' != 'S1314' THEN
	
				FOR j IN 1..v_agazat_type_a.COUNT LOOP  
	
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET EPULET = 
					(SELECT NVL(EPITES, 0) + (NVL(hasznalt_epulet_vasarlas, 0) * 0.04) + (NVL(epulet_atvet, 0) * 0.04) + NVL(epulet_penzugyi_lizing, 0)
					FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
					WHERE ALSZEKTOR = '''|| v_szekt ||'''
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
					WHERE ALSZEKTOR = '''|| v_szekt ||''' 
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
					'
					;
				
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET EPULET = 
					(SELECT (NVL(EPITES, 0) + (NVL(hasznalt_epulet_vasarlas, 0) * 0.04) + (NVL(epulet_atvet, 0) * 0.04) + NVL(epulet_penzugyi_lizing, 0)) - NVL(LAKAS, 0)
					FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
					WHERE ALSZEKTOR = '''|| v_szekt ||'''
					AND AGAZAT = ''68'')
					WHERE ALSZEKTOR = '''|| v_szekt ||'''
					AND AGAZAT = ''68''
					'
					;
				
				END LOOP;
				
			ELSE
				
				FOR j IN 1..v_agazat_type_a.COUNT LOOP  
				
					EXECUTE IMMEDIATE'
					UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
					SET EPULET = 
					(SELECT NVL(EPITES, 0) + (NVL(hasznalt_epulet_vasarlas, 0) * 0.087359) + (NVL(epulet_atvet, 0) * 0.040309) + NVL(epulet_penzugyi_lizing, 0)
					FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
					WHERE ALSZEKTOR = ''S1314''
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
					WHERE ALSZEKTOR = ''S1314'' 
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
					'
					;		
				
				END LOOP;
				
			END IF;

END gfcf_imp_epulet;


-- gfcf_imp_ownsoft
PROCEDURE gfcf_imp_ownsoft(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_szekt VARCHAR2) AS  

TYPE t_agazat_type_a IS TABLE OF VARCHAR2(5); 
v_agazat_type_a t_agazat_type_a; 

sql_statement VARCHAR2(3000);

BEGIN

sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szekt ||''' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_a;

		FOR j IN 1..v_agazat_type_a.COUNT LOOP 

			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET OWNSOFT =
			(SELECT NVL(SAJAT_SZAMITOGEPES_SZ, 0) + NVL(SAJAT_SZAMITOGEPES_DB, 0)
			FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
			WHERE ALSZEKTOR = '''|| v_szekt ||'''
			AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
			WHERE ALSZEKTOR = '''|| v_szekt ||''' 
			AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
			'
			;	
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET SZOFTVER =
			(SELECT NVL(VASAROLT_SZAMITOGEPES_SZ, 0) + NVL(VASAROLT_SZAMITOGEPES_DB, 0)
			FROM '|| schema_name ||'.'|| v_gfcf_out_table ||'
			WHERE ALSZEKTOR = '''|| v_szekt ||'''
			AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
			WHERE ALSZEKTOR = '''|| v_szekt ||''' 
			AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
			'
			;	
	
		END LOOP;

END gfcf_imp_ownsoft;
			
			
------ gfcf_imp_valt
PROCEDURE gfcf_imp_valt(v_gfcf_out_table VARCHAR2, schema_name VARCHAR2, v_gfcf_mod_table VARCHAR2, GFCF_EV NUMBER, v_arindex_1999 VARCHAR2, v_inv2_table VARCHAR2, table_rate_m VARCHAR2, version_to_run VARCHAR2) AS  

sql_statement VARCHAR2(4000);
procName VARCHAR2(30);

TYPE t_col_name IS TABLE OF VARCHAR2(30); 
v_col_name t_col_name; 

TYPE e_type IS RECORD (ALSZEKTOR VARCHAR2(26), AGAZAT VARCHAR2(5));
TYPE e_list IS TABLE OF e_type INDEX BY BINARY_INTEGER;
t_list e_list;

col_value NUMBER;
v NUMBER;

TYPE t_agazat_type_g IS TABLE OF VARCHAR2(5); 
v_agazat_type_g t_agazat_type_g; 

jarmu_start NUMBER;
epulet_start NUMBER;
ownsoft_start NUMBER;
gep_start NUMBER;


BEGIN

jarmu_start := 0;
epulet_start := 0;
ownsoft_start := 0;
gep_start := 0;

V_SZEKTOR(1) := 'S1311';
V_SZEKTOR(2) := 'S1313';
V_SZEKTOR(3) := 'S1314';
V_SZEKTOR(4) := 'S11';
V_SZEKTOR(5) := 'S12'; 
V_SZEKTOR(6) := 'S14';
V_SZEKTOR(7) := 'S15'; 
V_SZEKTOR(8) := 'S1311a';
V_SZEKTOR(9) := 'S1313a';

-- a GFCF és INV2 compare során megvizsgálandó mezők 
v_out_eszkozcsp(1) := 'AN112'; -- klasszikus --
v_out_eszkozcsp(2) := 'AN1131';	-- klasszikus --
v_out_eszkozcsp(3) := 'AN1139t'; -- klasszikus  --
v_out_eszkozcsp(4) := 'AN1139g'; -- klasszikus --
v_out_eszkozcsp(5) := 'AN1173s'; -- klasszikus --
v_out_eszkozcsp(6) := 'AN111';
v_out_eszkozcsp(7) := 'AN1173o';
v_out_eszkozcsp(8) := 'AN1174';
v_out_eszkozcsp(9) := 'AN1123';
v_out_eszkozcsp(10) := 'AN1171';
v_out_eszkozcsp(11) := 'AN114';
v_out_eszkozcsp(12) := 'AN1131w';
v_out_eszkozcsp(13) := 'AN1139k';
v_out_eszkozcsp(14) := 'AN1174t';
v_out_eszkozcsp(15) := 'AN1174a';
v_out_eszkozcsp(16) := 'AN112n';

-- a GFCF táblába létrehozandó xxx_1999 mezők megnevezései
-- a GFCF és INV2 compare során megvizsgálandó mezők 
v_out_name(1) := 'EPULET'; -- klasszikus
v_out_name(2) := 'JARMU';		-- klasszikus
v_out_name(3) := 'TARTOSGEP';	-- klasszikus
v_out_name(4) := 'GYORSGEP';	-- klasszikus
v_out_name(5) := 'SZOFTVER';	-- klasszikus
v_out_name(6) := 'LAKAS';	
v_out_name(7) := 'OWNSOFT';	
v_out_name(8) := 'ORIGINALS';	
v_out_name(9) := 'FOLDJAVITAS';	
v_out_name(10) := 'K_F';
v_out_name(11) := 'FEGYVER';
v_out_name(12) := 'WIZZ';
v_out_name(13) := 'KISERTEKU';
v_out_name(14) := 'TCF';
v_out_name(15) := 'EGYEB_ORIG';
v_out_name(16) := 'NOE6';

procName := 'GFCF MOD - v1';

IF ''|| version_to_run ||'' IN ('v1', 'v5') THEN

	CFC_IMPORT.add_columns(''|| schema_name ||'', ''|| v_gfcf_out_table ||'');
	
	commit;
	
END IF;

IF ''|| version_to_run ||'' = 'v1' THEN

	INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
	VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'GFCF table mod - v1', '');

	sql_statement := 'select COLUMN_NAME from all_tab_columns where OWNER = '''|| schema_name ||''' AND TABLE_NAME = '''|| v_gfcf_mod_table ||''' AND COLUMN_NAME NOT IN (''SZEKTOR'', ''ALSZEKTOR'', ''AGAZAT'', ''EGYEB'')';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_col_name;

	FOR a IN v_col_name.FIRST..v_col_name.LAST LOOP

		sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE '|| v_col_name(a) ||' > 0';
		EXECUTE IMMEDIATE sql_statement INTO v;
		
		IF v > 0 THEN
		
		sql_statement := 'SELECT ALSZEKTOR, AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE '|| v_col_name(a) ||' > 0';
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO t_list;
		
		FOR b IN t_list.FIRST..t_list.LAST LOOP

			sql_statement := 'SELECT '|| v_col_name(a) ||' FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE ALSZEKTOR = '''|| t_list(b).ALSZEKTOR ||''' AND AGAZAT = '''|| t_list(b).AGAZAT ||''' AND '|| v_col_name(a) ||' > 0';
			EXECUTE IMMEDIATE sql_statement INTO col_value;
			
			EXECUTE IMMEDIATE'
			UPDATE '|| schema_name ||'.'|| v_gfcf_out_table ||'
			SET '|| v_col_name(a) ||' = '|| col_value ||' + '|| v_col_name(a) ||'
			WHERE ALSZEKTOR = '''|| t_list(b).ALSZEKTOR ||''' AND AGAZAT = '''|| t_list(b).AGAZAT ||'''
			'
			;
			
			col_value := 0;
		
		END LOOP;
		
		END IF;

	END LOOP;

	commit;

END IF;

-- JÁRMŰ újraszámítása, ha van olyan mező, ahol az érték > 0

-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'JÁRMŰ - v1', '');

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
				
sql_statement := 'select COLUMN_NAME from all_tab_columns where OWNER = '''|| schema_name ||''' AND TABLE_NAME = '''|| v_gfcf_mod_table ||''' AND COLUMN_NAME IN (''BELFOLDI_JARMU'', ''IMPORT_JARMU'', ''HASZN_JARMU_VASARLAS'', ''JARMU_ATVET'', ''JARMU_PENZUGYI_LIZING'', ''WIZZ'')';
EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_col_name;

FOR b IN v_col_name.FIRST..v_col_name.LAST LOOP

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE '|| v_col_name(b) ||' > 0 AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN jarmu_start := 1; END IF;
		
END LOOP;
	
	IF jarmu_start = 1 THEN

		CFC_IMPORT.gfcf_imp_jarmu(''|| v_gfcf_out_table ||'', ''|| schema_name ||'' , ''|| V_SZEKTOR(a) ||''); 
	
	END IF;

END LOOP;

COMMIT;

-- ÉPÜLET újraszámítása, ha van olyan mező, ahol az érték > 0

-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'ÉPÜLET - v1', '');

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
sql_statement := 'select COLUMN_NAME from all_tab_columns where OWNER = '''|| schema_name ||''' AND TABLE_NAME = '''|| v_gfcf_mod_table ||''' AND COLUMN_NAME IN (''EPITES'', ''hasznalt_epulet_vasarlas'', ''epulet_atvet'', ''epulet_penzugyi_lizing'', ''LAKAS'')';
EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_col_name;

FOR b IN v_col_name.FIRST..v_col_name.LAST LOOP

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE '|| v_col_name(b) ||' > 0 AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN epulet_start := 1; END IF;
		
END LOOP;
	
	IF epulet_start = 1 THEN

		CFC_IMPORT.gfcf_imp_epulet(''|| v_gfcf_out_table ||'', ''|| schema_name ||'' , ''|| V_SZEKTOR(a) ||''); 
	
	END IF;

END LOOP;

COMMIT;

-- OWNSOFT+SZOFTVER újraszámítása, ha van olyan mező, ahol az érték > 0

-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'OWNSOFT - v1', '');

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
sql_statement := 'select COLUMN_NAME from all_tab_columns where OWNER = '''|| schema_name ||''' AND TABLE_NAME = '''|| v_gfcf_mod_table ||''' AND COLUMN_NAME IN (''SAJAT_SZAMITOGEPES_SZ'', ''SAJAT_SZAMITOGEPES_DB'', ''VASAROLT_SZAMITOGEPES_SZ'', ''VASAROLT_SZAMITOGEPES_DB'')';
EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_col_name;

FOR b IN v_col_name.FIRST..v_col_name.LAST LOOP

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE '|| v_col_name(b) ||' > 0 AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN ownsoft_start := 1; END IF;
		
END LOOP;
	
	IF ownsoft_start = 1 THEN

		CFC_IMPORT.gfcf_imp_ownsoft(''|| v_gfcf_out_table ||'', ''|| schema_name ||'' , ''|| V_SZEKTOR(a) ||''); 
	
	END IF;

END LOOP;

COMMIT;

-- GÉP újraszámítása, ha van olyan mező, ahol az érték > 0

-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'OWNSOFT - v1', '');

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
sql_statement := 'select COLUMN_NAME from all_tab_columns where OWNER = '''|| schema_name ||''' AND TABLE_NAME = '''|| v_gfcf_mod_table ||''' AND COLUMN_NAME IN (''BELFOLDI_GEP'', ''IMPORT_GEP'', ''HASZN_GEP_VASARLAS'', ''GEP_ATVET'', ''GEP_PENZUGYI_LIZING'')';
EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_col_name;

FOR b IN v_col_name.FIRST..v_col_name.LAST LOOP

	sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_mod_table ||' WHERE '|| v_col_name(b) ||' > 0 AND ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN gep_start := 1; END IF;
		
END LOOP;
	
	IF gep_start = 1 THEN

		MACHINE_DIVIDE.machine_divide(''|| v_gfcf_out_table ||'', ''|| table_rate_m ||'', '0');
		MACHINE_DIVIDE.machine_divide(''|| v_gfcf_out_table ||'', ''|| table_rate_m ||'', '1');
	
	END IF;

END LOOP;

COMMIT;

-- kiszámítjuk az 1999-es árat minden ágazatra	

-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate 1999 price - v1', '');

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
	sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' '; 
		
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;
	
	FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP
	
		FOR j IN 1..v_agazat_type_g.COUNT LOOP  

			CFC_IMPORT.gfcf_imp_1999(''|| GFCF_EV ||'', ''|| v_gfcf_out_table ||'', ''|| v_arindex_1999 ||'', ''|| schema_name ||'', ''|| v_out_name(b) ||'', ''|| v_out_eszkozcsp(b) ||'', ''|| v_szektor(a) ||'', ''|| v_agazat_type_g(j) ||'');
		
		END LOOP;
	
	END LOOP;
	
END LOOP;

COMMIT;

-- meglévő INV2 táblába történő beillesztés

-- log
INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Put in INV2', '');
	
IF ''|| version_to_run ||'' = 'v1' THEN

	FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP

		FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' 
			AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 
				
			EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;

			--szektoronként beillesztük a mezőbe az értékeket a GFCF táblából	
			FOR k IN 1..v_agazat_type_g.COUNT LOOP  
			
				CFC_IMPORT.gfcf_imp_inv2(''|| GFCF_EV ||'', ''|| v_gfcf_out_table ||'', ''|| schema_name ||'', ''|| v_out_name(b) ||'', ''|| v_out_eszkozcsp(b) ||'', ''|| v_szektor(a) ||'', ''|| v_agazat_type_g(k) ||'', ''|| v_inv2_table ||'');
				
			END LOOP;
			
		END LOOP;

	END LOOP;
	
	COMMIT;
	
ELSIF ''|| version_to_run ||'' = 'v5' THEN
	
	FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
		FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP

			sql_statement := 'SELECT COUNT(*) FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' AND '|| v_out_name(b) ||' > 0'; 			
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v > 0 THEN
			
				sql_statement := 'SELECT AGAZAT FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' 
				AND '|| v_out_name(b) ||' > 0 '; 
					
				EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;
				
				FOR k IN 1..v_agazat_type_g.COUNT LOOP  
				
					EXECUTE IMMEDIATE 'UPDATE '|| schema_name ||'.'|| v_inv2_table ||'
					SET Y'|| GFCF_EV ||' =
					((SELECT Y'|| GFCF_EV ||' FROM '|| schema_name ||'.'|| v_inv2_table ||' WHERE AGAZAT = '''|| v_agazat_type_g(k) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''') + (SELECT '|| v_out_name(b) ||'_1999 FROM '|| schema_name ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' AND AGAZAT = '''|| v_agazat_type_g(k) ||'''))
					WHERE AGAZAT = '''|| v_agazat_type_g(k) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''					
					'
					;
								
				END LOOP;		
			
			END IF;
		
		END LOOP;	
	
	END LOOP;	
	
	COMMIT;

END IF;

END gfcf_imp_valt;

END;