/*
create or replace PACKAGE CFC_IMPORT AUTHID CURRENT_USER AS 
TYPE T_AGAZAT_IMP IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkozcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_name IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_name_cl IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_agazat IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE T_SZEKTOR IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;
procedure gfcf_imp_alt(GFCF_EV VARCHAR2, v_gfcf_table VARCHAR2, v_gfcf_ar_table VARCHAR2, v_gfcf_out_table VARCHAR2, v_inv2_table VARCHAR2, 
v_lifetime_table VARCHAR2, v_arindex_1999 VARCHAR2, v_eszkozcsp VARCHAR2, v_gfcf_name VARCHAR2, 
v_alszektor VARCHAR2, eszkoz VARCHAR2, table_rate_m VARCHAR2, v_arindex_lanc VARCHAR2, v_compare VARCHAR2);


END CFC_IMPORT;
*/
------------


create or replace PACKAGE BODY CFC_IMPORT AS  
v_out_schema VARCHAR(10) := 'PKD'; -- PKD séma -- mindenhova kell 
V_AGAZAT_IMP T_AGAZAT_IMP;
v_out_eszkozcsp t_out_eszkozcsp;
v_out_name t_out_name;
v_out_name_cl t_out_name_cl;
v_agazat t_agazat;
V_SZEKTOR T_SZEKTOR;

-- GFCF import általános


PROCEDURE gfcf_imp_alt(GFCF_EV VARCHAR2, v_gfcf_table VARCHAR2, v_gfcf_ar_table VARCHAR2, v_gfcf_out_table VARCHAR2, v_inv2_table VARCHAR2, v_lifetime_table VARCHAR2, v_arindex_1999 VARCHAR2, v_eszkozcsp VARCHAR2, v_gfcf_name VARCHAR2, v_alszektor VARCHAR2, eszkoz VARCHAR2, table_rate_m VARCHAR2, v_arindex_lanc VARCHAR2, v_compare VARCHAR2) AS  

procName VARCHAR2(30);
v NUMERIC;
v1 NUMERIC;
GFCF_num NUMBER;
GFCF_minus VARCHAR2(10) := ''|| GFCF_EV ||''-1;
GFCF_plus VARCHAR2(10) := ''|| GFCF_EV ||''+1;

TYPE t_compare IS TABLE OF C_IMP_COMPARE%ROWTYPE;
v_compare_a t_compare; 

TYPE t_agazat_type IS TABLE OF VARCHAR2(20); 
v_agazat_type t_agazat_type; 

TYPE t_agazat_type_g IS TABLE OF VARCHAR2(20); 
v_agazat_type_g t_agazat_type_g; 

TYPE t_agazat_type_a IS TABLE OF VARCHAR2(5); 
v_agazat_type_a t_agazat_type_a; 

TYPE t_column_type_a IS TABLE OF user_tab_columns%ROWTYPE; -- ÉLES
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

GFCF_num := TO_NUMBER(''|| GFCF_EV ||'');

V_SZEKTOR(1) := 'S1311';
V_SZEKTOR(2) := 'S1313';
V_SZEKTOR(3) := 'S1314';
V_SZEKTOR(4) := 'S11'; -- ha a GFCF táblában minden benne lesz, akkor élesíteni kell (kommentet leszedni)
V_SZEKTOR(5) := 'S12'; -- ha a GFCF táblában minden benne lesz, akkor élesíteni kell (kommentet leszedni)
V_SZEKTOR(6) := 'S14'; -- ha a GFCF táblában minden benne lesz, akkor élesíteni kell (kommentet leszedni)
V_SZEKTOR(7) := 'S15'; -- ha a GFCF táblában minden benne lesz, akkor élesíteni kell (kommentet leszedni)
V_SZEKTOR(8) := 'S1311a'; -- ha a GFCF táblában minden benne lesz, akkor élesíteni kell (kommentet leszedni)
V_SZEKTOR(9) := 'S1313a'; -- ha a GFCF táblában minden benne lesz, akkor élesíteni kell (kommentet leszedni)

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
INSERT INTO PKD.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate 1999 price', '');

-- ha létezik már v_gfcf_out_table, akkor azt időpecséttel átnevezzük, majd létrehozzuk
sql_statement := 'SELECT TO_CHAR(CURRENT_DATE, ''_DD_MM_YY'') FROM dual';
EXECUTE IMMEDIATE sql_statement INTO v_date;

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_gfcf_out_table ||'';
	
	IF v > 0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| v_gfcf_out_table ||' RENAME TO '|| v_gfcf_out_table ||''|| v_date ||'
		'
		;		
	
	END IF;
	
	EXECUTE IMMEDIATE'
	CREATE TABLE PKD.'|| v_gfcf_out_table ||' AS
	(SELECT * FROM PKD.'|| v_gfcf_table ||')
	'
	;
	

-- 1. lépés: hozzunk létre új mezőket a GFCF táblában

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||'';
	EXECUTE IMMEDIATE sql_statement INTO v1;
	
	IF v1 > 0 THEN

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('JARMU') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
		
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD JARMU NUMBER
		'
		; 
	
	END IF;

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('OWNSOFT') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD OWNSOFT NUMBER
		'
		;
		
	END IF;	

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('SZOFTVER') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD SZOFTVER NUMBER
		'
		;

		
	END IF;

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('EPULET') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD EPULET NUMBER
		'
		;
		
	END IF;
	

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('GEP') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD GEP NUMBER
		'
		;

		
	END IF;

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('TARTOSGEP') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD TARTOSGEP NUMBER
		'
		;
		
	END IF;

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('GYORSGEP') AND table_name = ''|| v_gfcf_out_table ||'';
	
	IF v=0 THEN
	
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_gfcf_out_table ||'
		ADD GYORSGEP NUMBER
		'
		;
		
	END IF;
	
--IF v_eszkozcsp != 'CLASSIC' THEN 

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('EPULET_1999') AND table_name = ''|| v_gfcf_out_table ||'' ;
	
	IF v = 0 THEN 
			
		FOR a IN v_out_name.FIRST..v_out_name.LAST LOOP
			
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
			ADD '|| v_out_name(a) ||'_1999 NUMBER
			'
			; 
			
		END LOOP;
				
	END IF;
	
	COMMIT;

--END IF;

	
-- 2. lépés: a GFCF táblában a S1311 esetében a következők kerülnek összevonásra:
		-- 03,81->01
		-- 37,39->38
		-- 74->72
		-- minden más 841-be (ezt a compare résznél kezeljük)
			
	sql_statement := 'SELECT * FROM user_tab_columns WHERE table_name = '''|| v_gfcf_out_table ||'''
	and column_name NOT IN (''SZEKTOR'', ''ALSZEKTOR'', ''AGAZAT'', ''EGYEB'') '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_column_type_a;

	FOR a IN v_column_type_a.FIRST..v_column_type_a.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_column_type_a(a).column_name ||''; 
	--	DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
	END LOOP;
		
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM PKD.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1311''
		AND a.AGAZAT IN (''01'', ''03'', ''81'')
		)
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''01''
		'
		;
		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM PKD.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1311''
		AND a.AGAZAT IN (''74'', ''72'')
		)
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''72''
		'
		;

		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM PKD.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1311''
		AND a.AGAZAT IN (''37'', ''38'', ''39'')
		)
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''38''
		'
		;
				
	END LOOP;

	-- az átmásolt ágazatok esetében 0 értéket írunk be, de csak azokban a mezőkben, ahol alapból volt érték (nem NULL volt)
	v_agazat(1) := '03';
	v_agazat(2) := '74';
	v_agazat(3) := '37';
	v_agazat(4) := '39';
	v_agazat(5) := '81';
	
	FOR y IN 1..v_agazat.COUNT LOOP  
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
			sql_statement := 'SELECT COUNT('|| V_AGAZAT_IMP(j) ||') FROM PKD.'|| v_gfcf_out_table ||' WHERE '|| V_AGAZAT_IMP(j) ||' IS NOT NULL AND AGAZAT = '''|| v_agazat(y) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET '|| V_AGAZAT_IMP(j) ||' = ''0''
				WHERE ALSZEKTOR = ''S1311''
				AND AGAZAT = '''|| v_agazat(y) ||'''
				'
				;
				
			END IF;
			
		END LOOP;
		
	END LOOP;

	-- S1313 esetén: 
		-- 01, 03 -> 81
		-- 78 -> 71
		
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM PKD.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1313''
		AND a.AGAZAT IN (''01'', ''03'', ''81'')
		)
		WHERE ALSZEKTOR = ''S1313''
		AND AGAZAT = ''81''
		'
		;

		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_gfcf_out_table ||'
		SET '|| V_AGAZAT_IMP(j) ||' = (SELECT SUM(NVL(a.'|| V_AGAZAT_IMP(j) ||', 0)) FROM PKD.'|| v_gfcf_out_table ||' a
		WHERE a.ALSZEKTOR = ''S1313''
		AND a.AGAZAT IN (''78'', ''71'')
		)
		WHERE ALSZEKTOR = ''S1313''
		AND AGAZAT = ''71''
		'
		;
		
	END LOOP;

	-- az átmásolt ágazatok esetében 0 értéket írunk be, de csak azokban a mezőkben, ahol alapból volt érték (nem NULL volt)
	v_agazat(1) := '01';
	v_agazat(2) := '03';
	v_agazat(3) := '78';
	
	FOR y IN 1..3 LOOP  
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
			sql_statement := 'SELECT COUNT('|| V_AGAZAT_IMP(j) ||') FROM PKD.'|| v_gfcf_out_table ||' WHERE '|| V_AGAZAT_IMP(j) ||' IS NOT NULL AND AGAZAT = '''|| v_agazat(y) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET '|| V_AGAZAT_IMP(j) ||' = ''0''
				WHERE ALSZEKTOR = ''S1313''
				AND AGAZAT = '''|| v_agazat(y) ||'''
				'
				;
				
			END IF;
			
		END LOOP;
		
	END LOOP;

	
	
-- 3. lépés: a GFCF táblában 3 jegyű ágazatok létrehozása S11 esetében:
	
	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S11'' AND AGAZAT = ''361'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S11'', ''S11'', ''361'')
			'
			;
		
		
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||',0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S11''
			AND a.AGAZAT = ''36'')
			WHERE ALSZEKTOR = ''S11''
			AND AGAZAT = ''361''
			'
			;		

		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S11''
			AND AGAZAT = ''36''
			'
			;		

		END LOOP;
		
	END IF;
	
	-- a GFCF táblában 3 jegyű ágazatok létrehozása S1311 esetében:
		
	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''421'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''421'')
			'
			;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''42'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''421''
			'
			;	

		END LOOP;
		
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''42''
			'
			;		

		END LOOP;
		
		END IF;
	
	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''711'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''711'')
			'
			;
			
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''71'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''711''
			'
			;
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''71''
			'
			;		

		END LOOP;
		
		END IF;

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''821'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''821'')
			'
			;
			
		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''82'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''821''
			'
			;			
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''82''
			'
			;		

		END LOOP;

		END IF;

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''851'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', ''S1311'', ''851'')
			'
			;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  			
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''85'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''851''
			'
			;			
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''85''
			'
			;		

		END LOOP;
		
		END IF;
		
-- S1311 esetén FEGYVER mező 84->841, GRIPPEN mező 84->FEGYVER 846

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''846'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT, EGYEB)
			VALUES (''S13'', ''S1311'', ''846'', ''GRIPEN'')
			'
			;
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET FEGYVER = (SELECT NVL(a.FEGYVER, 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''841''
			'
			;			

			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET FEGYVER = (SELECT NVL(a.GRIPPEN, 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84'')
			WHERE ALSZEKTOR = ''S1311''
			AND AGAZAT = ''846''
			'
			;	

			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||' a
			SET FEGYVER = ''0''
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84''
			'
			;	

			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||' a
			SET GRIPPEN = ''0''
			WHERE a.ALSZEKTOR = ''S1311''
			AND a.AGAZAT = ''84''
			'
			;				
			
		END IF;

-- 841 esetén S1311 és S1313-ban is létrehozzuk:
FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
	
	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' AND AGAZAT = ''841'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
		IF v = 0 THEN
		
		IF ''|| V_SZEKTOR(a) ||'' IN ('S1311', 'S1313') THEN
		
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_gfcf_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT)
			VALUES (''S13'', '''|| V_SZEKTOR(a) ||''', ''841'')
			'
			;
			
		END IF;
		
		END IF;
		
		IF ''|| V_SZEKTOR(a) ||'' IN ('S1311', 'S1313') THEN
		
		FOR j IN 1..v_out_name_cl.COUNT LOOP  			
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = (SELECT NVL(a.'|| v_out_name_cl(j) ||', 0) FROM PKD.'|| v_gfcf_out_table ||' a
			WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND a.AGAZAT = ''84'')
			WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND AGAZAT = ''841''
			'
			;			
			
		END LOOP;

		FOR j IN 1..v_out_name_cl.COUNT LOOP  
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| v_gfcf_out_table ||'
			SET '|| v_out_name_cl(j) ||' = ''0''
			WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
			AND AGAZAT = ''84''
			'
			;		

		END LOOP;	

		END IF;

END LOOP;
		

-- 4. lépés: a GFCF táblában létrehozunk egy JÁRMŰ oszlopot: 
	-- S11, S12, S1311, S1313, S14, S15: (((BELFOLDI_JARMU + IMPORT_JARMU) + (HASZN_JARMU_VASARLAS * 0.07) + (JARMU_ATVET * 0.07) + JARMU_PENZUGYI_LIZING)
	-- S1314:  (((BELFOLDI_JARMU + IMPORT_JARMU) + (HASZN_JARMU_VASARLAS * 0.068048) + (JARMU_ATVET * 0.040328) + JARMU_PENZUGYI_LIZING)
	
	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
		
		sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' '; 

		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_a;
		
		IF ''|| V_SZEKTOR(a) ||'' = 'S11' THEN
			
			FOR j IN 1..v_agazat_type_a.COUNT LOOP  
			
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET JARMU = 
				(SELECT ((NVL(BELFOLDI_JARMU, 0) + NVL(IMPORT_JARMU, 0)) + (NVL(HASZN_JARMU_VASARLAS, 0) * 0.07) + (NVL(JARMU_ATVET, 0) * 0.07)
				+ NVL(JARMU_PENZUGYI_LIZING, 0)) - NVL(WIZZ, 0)
				FROM PKD.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' 
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;
		
			END LOOP;
				
		ELSIF ''|| V_SZEKTOR(a) ||'' NOT IN ('S11', 'S1314') THEN
			
			FOR j IN 1..v_agazat_type_a.COUNT LOOP  
			
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET JARMU = 
				(SELECT (NVL(BELFOLDI_JARMU, 0) + NVL(IMPORT_JARMU, 0)) + (NVL(HASZN_JARMU_VASARLAS, 0) * 0.07) + (NVL(JARMU_ATVET, 0) * 0.07) 
				+ NVL(JARMU_PENZUGYI_LIZING, 0) 
				FROM PKD.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' 
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;
		
			END LOOP;
		
		ELSE
		
			FOR j IN 1..v_agazat_type_a.COUNT LOOP  	
		
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET JARMU = 
				(SELECT (NVL(BELFOLDI_JARMU, 0) + NVL(IMPORT_JARMU, 0)) + (NVL(HASZN_JARMU_VASARLAS, 0) * 0.068048) + (NVL(JARMU_ATVET, 0) * 0.040328) 
				+ NVL(JARMU_PENZUGYI_LIZING, 0) 
				FROM PKD.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = ''S1314''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = ''S1314''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;	
		
			END LOOP;
		
		END IF;
		
	END LOOP;
	
	-- S1311-ben a 841-es ágazatból még ki kell vonni a GRIPEN értéket

		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_gfcf_out_table ||'
		SET JARMU = 
		(SELECT (NVL(JARMU, 0)) - (NVL((SELECT FEGYVER FROM PKD.'|| v_gfcf_out_table ||' WHERE AGAZAT = ''846'' AND ALSZEKTOR = ''S1311''), 0))
		FROM PKD.'|| v_gfcf_out_table ||' WHERE AGAZAT = ''841'' AND ALSZEKTOR = ''S1311'')
		WHERE AGAZAT = ''841'' AND ALSZEKTOR = ''S1311''
		'
		;
		

-- 5. lépés: a GFCF táblában létrehozunk egy EPULET oszlopot: 
	-- S11, S12, S1311, S1313, S14, S15: EPITES + (hasznalt_epulet_vasarlas * 0.04) + (epulet_atvet * 0.04) + epulet_penzugyi_lizing - LAKAS (a LAKAS-t csak a 68-as ágazatból kell kivonni)
	-- S1314: EPITES + (hasznalt_epulet_vasarlas * 0.087359) + (epulet_atvet * 0.040309) + epulet_penzugyi_lizing
	
	
	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
		
		sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' '; 

		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_a;
		
			IF ''|| V_SZEKTOR(a) ||'' != 'S1314' THEN
	
				FOR j IN 1..v_agazat_type_a.COUNT LOOP  
	
					EXECUTE IMMEDIATE'
					UPDATE PKD.'|| v_gfcf_out_table ||'
					SET EPULET = 
					(SELECT NVL(EPITES, 0) + (NVL(hasznalt_epulet_vasarlas, 0) * 0.04) + (NVL(epulet_atvet, 0) * 0.04) + NVL(epulet_penzugyi_lizing, 0)
					FROM PKD.'|| v_gfcf_out_table ||'
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' 
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
					'
					;
				
					EXECUTE IMMEDIATE'
					UPDATE PKD.'|| v_gfcf_out_table ||'
					SET EPULET = 
					(SELECT (NVL(EPITES, 0) + (NVL(hasznalt_epulet_vasarlas, 0) * 0.04) + (NVL(epulet_atvet, 0) * 0.04) + NVL(epulet_penzugyi_lizing, 0)) - NVL(LAKAS, 0)
					FROM PKD.'|| v_gfcf_out_table ||'
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
					AND AGAZAT = ''68'')
					WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
					AND AGAZAT = ''68''
					'
					;
				
				END LOOP;
				
				ELSE
				
				FOR j IN 1..v_agazat_type_a.COUNT LOOP  
				
					EXECUTE IMMEDIATE'
					UPDATE PKD.'|| v_gfcf_out_table ||'
					SET EPULET = 
					(SELECT NVL(EPITES, 0) + (NVL(hasznalt_epulet_vasarlas, 0) * 0.087359) + (NVL(epulet_atvet, 0) * 0.040309) + NVL(epulet_penzugyi_lizing, 0)
					FROM PKD.'|| v_gfcf_out_table ||'
					WHERE ALSZEKTOR = ''S1314''
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
					WHERE ALSZEKTOR = ''S1314'' 
					AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
					'
					;		
				
				END LOOP;
				
			END IF;

	END LOOP;

	
	-- 6. lépés: a GFCF táblában létrehozunk egy OWNSOFT oszlopot: 
	-- SAJAT_SZAMITOGEPES_SZ + SAJAT_SZAMITOGEPES_DB
	-- a GFCF táblában létrehozunk egy SZOFTVER oszlopot: 
	-- VASAROLT_SZAMITOGEPES_SZ + VASAROLT_SZAMITOGEPES_DB

	FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
		
		sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' '; 

		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_a;
	
			FOR j IN 1..v_agazat_type_a.COUNT LOOP 
	
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET OWNSOFT =
				(SELECT NVL(SAJAT_SZAMITOGEPES_SZ, 0) + NVL(SAJAT_SZAMITOGEPES_DB, 0)
				FROM PKD.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' 
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;	
				
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| v_gfcf_out_table ||'
				SET SZOFTVER =
				(SELECT NVL(VASAROLT_SZAMITOGEPES_SZ, 0) + NVL(VASAROLT_SZAMITOGEPES_DB, 0)
				FROM PKD.'|| v_gfcf_out_table ||'
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||''')
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||''' 
				AND AGAZAT = ''' ||v_agazat_type_a(j) ||'''
				'
				;	
		
			END LOOP;
	
	END LOOP;
	
	--7 .lépés: létrehozzuk a GEP mezőket, de még nem számoljuk át az arányokat TARTOSGEP-re és GYORSGEP-re, mert előzőleg a GEP 841-es ágazatba a 8-as lépésben még át kell tenni a többi ágazat értékét
	
	MACHINE_DIVIDE.machine_divide(''|| table_gfcf_out ||'', ''|| t_rate_m ||'', '0');
	
	
	-- 8. lépés: 
	-- meg kell vizsgálni, hogy a GFCF táblában van-e olyan rekord, ahol van érték, de az INV2-ben nincsen 
	-- ezek bekerülnek a 841/84-es ágazatba S1311, S1313, S1313a esetében
	-- S1311a esetében 39-es ágazatba menjenek az 37 és 39-es ágazat adatai, minden más az 84-be

PKD.truncate_table(''|| v_compare_t ||'');

v_out_name(3) := 'GEP';	

FOR b IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP

	-- nézzük meg, hogy az INV2 táblában van-e olyan szektor amit keresünk, ha nincs akkor ne is fusson le
	sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(b) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN
	
		FOR a IN v_out_name.FIRST..v_out_name.LAST LOOP
			
		-- nézzük meg, hogy az INV2 táblában van-e olyan eszközcsoport amit keresünk, ha nincs, akkor ne is fusson le
		sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(b) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(a) ||''' ';
		EXECUTE IMMEDIATE sql_statement INTO v;
		
		IF v > 0 THEN		
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_schema ||'.'|| v_compare_t ||' (AGAZAT, ALSZEKTOR, ESZKOZCSP)
			
			(SELECT AGAZAT, '''|| V_SZEKTOR(b) ||''', '''|| v_out_eszkozcsp(a) ||'''
			FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
			WHERE '|| v_out_name(a) ||' IS NOT NULL AND '|| v_out_name(a) ||' != ''0''
			AND ALSZEKTOR = '''|| V_SZEKTOR(b) ||'''
			
			MINUS

			SELECT AGAZAT, '''|| V_SZEKTOR(b) ||''', '''|| v_out_eszkozcsp(a) ||'''
			FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
			WHERE ESZKOZCSP = '''|| v_out_eszkozcsp(a) ||'''
			AND ALSZEKTOR = '''|| V_SZEKTOR(b) ||''')
			'
			;
		
		END IF;
		
		END LOOP;
	
	END IF;
	
END LOOP;

	--S1311 esetén a következő ágazatokat nem kell figyelni: 03, 37, 38, 42, 71, 74, 81, 82, 85
	--S1313 esetén a következő ágazatokat nem kell figyelni: 03, 78
	--S11 esetén a következő ágazatokat nem kell figyelni: 36
	--S1311/AN1171 (K+F) esetén a következő ágazatokat nem kell figyelni: 72
	--S1311 és S1313 esetén FÖLDJAVÍTÁS (AN1123) nem kell figyelni, azt külön kezeljük
	
	EXECUTE IMMEDIATE'
	DELETE FROM PKD.'|| v_compare_t ||'
	WHERE AGAZAT = ''36''
	AND ALSZEKTOR = ''S11''
	'
	;
		
	EXECUTE IMMEDIATE'
	DELETE FROM PKD.'|| v_compare_t ||'
	WHERE AGAZAT IN (''03'', ''37'', ''38'', ''42'', ''71'', ''74'', ''81'', ''82'', ''85'', ''846'')
	AND ALSZEKTOR = ''S1311''
	'
	;

	EXECUTE IMMEDIATE'
	DELETE FROM PKD.'|| v_compare_t ||'
	WHERE AGAZAT = ''72''
	AND ALSZEKTOR = ''S1311''
	AND ESZKOZCSP = ''AN1171''
	'
	;
	
	EXECUTE IMMEDIATE'
	DELETE FROM PKD.'|| v_compare_t ||'
	WHERE AGAZAT IN (''03'', ''78'')
	AND ALSZEKTOR = ''S1313''
	'
	;	

	EXECUTE IMMEDIATE'
	DELETE FROM PKD.'|| v_compare_t ||'
	WHERE ALSZEKTOR IN (''S1311'', ''S1313'') AND ESZKOZCSP = ''AN1123''
	'
	;	
	
-- a COMPARE tábla értékeit elmentjük a C_IMP_COMPARE_évszám táblába, hogy a későbbiek számára meglegyen

	SELECT COUNT(*) INTO v FROM all_tables where table_name = UPPER(''|| v_compare_t ||'_'|| GFCF_EV ||'');

		IF v=0 THEN

			EXECUTE IMMEDIATE'
			CREATE TABLE PKD.'|| v_compare_t ||'_'|| GFCF_EV ||'
			("AGAZAT" VARCHAR2(5 BYTE), 
			"ALSZEKTOR" VARCHAR2(20 BYTE), 
			"ESZKOZCSP" VARCHAR2(20 BYTE)
			)
			'
			;
				
		ELSE
	
			PKD.truncate_table(''|| v_compare_t ||'_'|| GFCF_EV ||'');
	
		END IF;
	
	EXECUTE IMMEDIATE'
	INSERT INTO '|| v_out_schema ||'.'|| v_compare_t ||'_'|| GFCF_EV ||'
	(SELECT * FROM '|| v_out_schema ||'.'|| v_compare_t ||')
	'
	;

	
FOR z IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP 
	
	-- csak az S1311 és S1313 alszektorokra futtatjuk le: minden eltérő elem a 841-be megy
	IF ''|| V_SZEKTOR(z) ||'' IN ('S1311', 'S1313') THEN 
		
	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;	
				
	IF v > 0 THEN
	
	DBMS_OUTPUT.put_line('Eltérés van a GFCF tábla és az INV2 tábla ágazatai között a futtatott eszközcsoport és alszektor esetében, az eltérő elemek bekerülnek a 84/841-es ágazatba.');


	sql_statement := 'SELECT * FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_compare_a;

	FOR a IN v_compare_a.FIRST..v_compare_a.LAST LOOP 
		DBMS_OUTPUT.put_line('Az eltérések: ÁGAZAT: '|| v_compare_a(a).AGAZAT ||' _ ALSZEKTOR: '|| v_compare_a(a).ALSZEKTOR ||' - ESZKOZCSP: '|| v_compare_a(a).ESZKOZCSP ||' ');  
	END LOOP;
	
	-- ha van eltérés, akkor minden mezőérték bekerül S1311 és S1313 esetén a 841-es ágazatba klasszikus eszközcsoportok esetén
		
		FOR j IN v_out_name.FIRST..5 LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''841'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''')
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''841''
				'
				;
			
		
			END IF;

		END LOOP;
		
		FOR j IN v_out_name.FIRST..5 LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;


	-- ha van eltérés, akkor minden mezőérték bekerül S1311 és S1313 esetén a 84-es ágazatba NEM klasszikus eszközcsoportok esetén
		
		FOR j IN 6..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''84'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''')
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''84''
				'
				;
				
			END IF;
					
		END LOOP;
		
		FOR j IN 6..v_out_name.LAST LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;
		
	END IF;
	
	-- S1313a esetén minden eltérő elem a 84-be megy
	ELSIF ''|| V_SZEKTOR(z) ||'' = 'S1313a' THEN

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;	
				
	IF v > 0 THEN
	
	DBMS_OUTPUT.put_line('Eltérés van a GFCF tábla és az INV2 tábla ágazatai között a futtatott eszközcsoport és alszektor esetében, az eltérő elemek bekerülnek a 84-es ágazatba.');


	sql_statement := 'SELECT * FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_compare_a;

	FOR a IN v_compare_a.FIRST..v_compare_a.LAST LOOP 
		DBMS_OUTPUT.put_line('Az eltérések: ÁGAZAT: '|| v_compare_a(a).AGAZAT ||' _ ALSZEKTOR: '|| v_compare_a(a).ALSZEKTOR ||' - ESZKOZCSP: '|| v_compare_a(a).ESZKOZCSP ||' ');  
	END LOOP;
	
	-- ha van eltérés, akkor minden mezőérték bekerül S1313a esetén a 84-es ágazatba klasszikus eszközcsoportok esetén
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''84'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''')
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''84''
				'
				;
			
		
			END IF;

		END LOOP;
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;

	-- S1311a: minden eltérő elem a 84-be megy, 37 és 39 a 39-be megy
	ELSIF ''|| V_SZEKTOR(z) ||'' = 'S1311a' THEN 

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;	
				
	IF v > 0 THEN
	
	DBMS_OUTPUT.put_line('Eltérés van a GFCF tábla és az INV2 tábla ágazatai között a futtatott eszközcsoport és alszektor esetében, az eltérő elemek bekerülnek a 84-es ágazatba, 37 ás 39-es ágazat esetén a 39-es ágazatba kerülnek.');


	sql_statement := 'SELECT * FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_compare_a;

	FOR a IN v_compare_a.FIRST..v_compare_a.LAST LOOP 
		DBMS_OUTPUT.put_line('Az eltérések: ÁGAZAT: '|| v_compare_a(a).AGAZAT ||' _ ALSZEKTOR: '|| v_compare_a(a).ALSZEKTOR ||' - ESZKOZCSP: '|| v_compare_a(a).ESZKOZCSP ||' ');  
	END LOOP;
	
	-- ha van eltérés, akkor minden mezőérték bekerül S1311a esetén a 84-es ágazatba klasszikus eszközcsoportok esetén, kivéve 37 és 39-es ágazat
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT NOT IN (''37'', ''39'') ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''84'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT NOT IN (''37'', ''39''))
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''84''
				'
				;
			
		
			END IF;

		END LOOP;

	-- ha van eltérés, akkor minden mezőérték bekerül S1311a esetén a 39-es ágazatba klasszikus eszközcsoportok esetén, 37 és 39-es ágazat esetében
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT IN (''37'', ''39'') ';
			
			EXECUTE IMMEDIATE sql_statement INTO v;
			
			IF v > 0 THEN
		
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
				SET '|| v_out_name(j) ||' = ((SELECT NVL(a.'|| v_out_name(j) ||', 0) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a WHERE AGAZAT = ''39'' AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||''') + (SELECT SUM(NVL(a.'|| v_out_name(j) ||', 0)) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a
				WHERE a.ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND a.AGAZAT IN (SELECT AGAZAT FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' AND AGAZAT IN (''37'', ''39''))
				))
				WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
				AND AGAZAT = ''39''
				'
				;
						
		
			END IF;

		END LOOP;
		
		FOR j IN v_out_name.FIRST..v_out_name.LAST LOOP
		
			FOR x IN v_compare_a.FIRST..v_compare_a.LAST LOOP	

				sql_statement := 'SELECT COUNT(AGAZAT) FROM PKD.'|| v_compare_t ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(z) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(j) ||''' ';
				
				EXECUTE IMMEDIATE sql_statement INTO v;
				
				IF v > 0 THEN
			
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
					SET '|| v_out_name(j) ||' = ''0''
					WHERE AGAZAT = '''|| v_compare_a(x).AGAZAT ||'''
					AND ALSZEKTOR = '''|| V_SZEKTOR(z) ||'''
					'
					;
					
				END IF;
			
			END LOOP;
		
		END LOOP;
	
	END IF;
	
	END IF;
		
	END IF;
				
END LOOP;

-- FÖLDJAVÍTÁS
	-- S1313 esetén minden érték, ami egyéb ágazatokban van (kivéve 84) -> 39-es ágazatba kerül
	-- S1311 esetén minden érték, ami egyéb ágazatokban van -> 84-es ágazatba kerül
	
	-- S1313
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = 
	(
	SELECT sum(NVL(FOLDJAVITAS, 0)) 
	FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
	WHERE ALSZEKTOR = ''S1313''	AND AGAZAT != ''84''			
	)
	WHERE ALSZEKTOR = ''S1313'' AND AGAZAT = ''39''
	'
	;			
	

	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = ''0''
	WHERE ALSZEKTOR = ''S1313'' AND AGAZAT NOT IN (''39'', ''84'')	
	'
	;

	-- S1311
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = 
	(
	SELECT sum(NVL(FOLDJAVITAS, 0)) 
	FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
	WHERE ALSZEKTOR = ''S1311''				
	)
	WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''84''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
	SET FOLDJAVITAS = ''0''
	WHERE ALSZEKTOR = ''S1311'' AND AGAZAT NOT IN (''84'')	
	'
	;
	
v_out_name(3) := 'TARTOSGEP';	

	
-- 9. lépés: itt kell meghívni a MACHINE_DIVIDE eljárást, mivel a gépekhez kapcsoldó adatokat is létre kell hozni
			
	MACHINE_DIVIDE.machine_divide(''|| table_gfcf_out ||'', ''|| t_rate_m ||'', '1');

-- 10. lépés: a GFCF tábla adatait 1999-es árra átszámítjuk
	
-- log
INSERT INTO PKD.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate 1999 price', '');

-- kiszámítjuk az 1999-es árat minden ágazatra	


FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP
	
	sql_statement := 'SELECT AGAZAT FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' '; 
		
--	END IF;
		
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;
	
	FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP
	
		FOR j IN 1..v_agazat_type_g.COUNT LOOP  

			EXECUTE IMMEDIATE ' 
			UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_table ||'
			SET '|| v_out_name(b) ||'_1999 = 
			(SELECT 
				CASE b.Y'|| GFCF_EV ||'_1999
					WHEN 0 THEN a.'|| v_out_name(b) ||'
					ELSE a.'|| v_out_name(b) ||' / b.Y'|| GFCF_EV ||'_1999 
				END as '|| v_out_name(b) ||'_1999
			
			FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' a
			INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
			ON a.AGAZAT = b.AGAZAT 
			WHERE a.AGAZAT = '''|| v_agazat_type_g(j) ||'''
			AND a.ALSZEKTOR = '''|| v_szektor(a) ||''' AND b.ALSZEKTOR = '''|| v_szektor(a) ||''' 
			AND b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' 
			)
			WHERE AGAZAT = '''|| v_agazat_type_g(j) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||'''
			'
			;
		
		END LOOP;
	
	END LOOP;
	
END LOOP;

	
 
-- 11.lépés: meglévő INV2 táblába történő beillesztés
	
-- log
INSERT INTO PKD.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Put in INV2', '');

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('Y'|| GFCF_EV ||'') AND table_name = ''|| v_inv2_table ||'';
	
	IF v=0 THEN
				
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| v_out_schema ||'.'|| v_inv2_table ||'
		ADD Y'|| GFCF_EV ||' NUMBER
		'
		; 
	
	END IF;

FOR a IN v_szektor.FIRST..v_szektor.LAST LOOP

	FOR b IN v_out_name.FIRST..v_out_name.LAST LOOP
	
		sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_inv2_table ||' WHERE ALSZEKTOR = '''|| v_szektor(a) ||''' 
		AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 
			
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_g;

		-- szektoronként beillesztük a mezőbe az értékeket a GFCF táblából	
		FOR k IN 1..v_agazat_type_g.COUNT LOOP  
		
			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' 
			WHERE AGAZAT = '''|| v_agazat_type_g(k) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||''' ';
			EXECUTE IMMEDIATE sql_statement INTO agazat_is_null;
			IF agazat_is_null > 0 THEN 
		
			sql_statement := 'SELECT '|| v_out_name(b) ||'_1999 
			FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' 
			WHERE AGAZAT = '''|| v_agazat_type_g(k) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||''' ';
			EXECUTE IMMEDIATE sql_statement INTO agazat_is_null;
			
			IF (agazat_is_null > 0 AND agazat_is_null IS NOT NULL) THEN
		
				EXECUTE IMMEDIATE '
				UPDATE '|| v_out_schema ||'.'|| v_inv2_table ||'
				SET Y'|| GFCF_EV ||' =
				(SELECT '|| v_out_name(b) ||'_1999 
				FROM '|| v_out_schema ||'.'|| v_gfcf_out_table ||' 
				WHERE AGAZAT = '''|| v_agazat_type_g(k) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||''' 
				)
				WHERE AGAZAT = '''|| v_agazat_type_g(k) ||''' AND ALSZEKTOR = '''|| v_szektor(a) ||''' 
				AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
				'
				;
				
			END IF;
			
			END IF;
				
		END LOOP;
		
	END LOOP;

END LOOP;
	

-- 12. lépés: az LT táblát is még ki kell egészíteni, az aktuális évbe be kell másolni a tavalyi év adatait
-- csak 2016-os évtől kezdődően, az előtt nem módosítunk

	IF ''|| GFCF_num ||'' >= 2017 THEN

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('Y'|| GFCF_EV ||'') AND table_name = ''|| v_lifetime_table ||'';
	
	IF v=0 THEN
				
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| v_out_schema ||'.'|| v_lifetime_table ||'
		ADD Y'|| GFCF_EV ||' NUMBER
		'
		; 
	
	END IF;	

	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_schema ||'.'|| v_lifetime_table ||'
	SET Y'|| GFCF_EV ||' = Y'|| GFCF_minus ||'
	'
	;
	
	END IF;

INSERT INTO PKD.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'ÁR START', '');

	
-- 13. lépés: hozzunk létre egy új mezőt az aktuális árhoz az ÁR BÁZIS táblában

IF ''|| GFCF_num ||'' >= 2016 THEN

	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('Y'|| GFCF_plus ||'_1999') AND table_name = ''|| v_arindex_1999 ||'';
	
	IF v=0 THEN
		
		EXECUTE IMMEDIATE'
		ALTER TABLE '|| v_arindex_1999 ||'
		ADD Y'|| GFCF_plus ||'_1999 NUMBER
		'
		; 
	
	END IF;
	
	
	
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
	
		SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER(''|| v_out_name(b) ||'') AND table_name = ''|| v_gfcf_ar_table ||'';
		IF v > 0 THEN
	
		sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_arindex_1999 ||' WHERE ALSZEKTOR = '''|| V_SZEKTOR(a) ||'''
		AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;
	
		FOR j IN 1..v_agazat_type.COUNT LOOP  

			EXECUTE IMMEDIATE' 
			UPDATE '|| v_out_schema ||'.'|| v_arindex_1999 ||'
			SET Y'|| GFCF_plus ||'_1999 = 
			(SELECT a.Y'|| GFCF_EV ||'_1999 * b.'|| v_out_name(b) ||' / 100
			FROM '|| v_out_schema ||'.'|| v_arindex_1999 ||' a
			INNER JOIN '|| v_out_schema ||'.'|| v_gfcf_ar_table ||' b 
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
		UPDATE '|| v_out_schema ||'.'|| v_arindex_1999 ||'
		SET Y'|| GFCF_plus ||'_1999 = 
		(SELECT Y'|| GFCF_EV ||'_1999 * 
		(SELECT GRIPPEN 
		FROM '|| v_out_schema ||'.'|| v_gfcf_ar_table ||'
		WHERE AGAZAT = ''84'')
		/ 100
		FROM '|| v_out_schema ||'.'|| v_arindex_1999 ||'
		WHERE ALSZEKTOR = ''S1311'' AND ESZKOZCSP = ''AN114'' AND AGAZAT = ''846''
		)
		WHERE ALSZEKTOR = ''S1311'' AND ESZKOZCSP = ''AN114'' AND AGAZAT = ''846''
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

			
	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('Y'|| GFCF_plus ||'_'|| GFCF_EV ||'') AND table_name = ''|| v_lanc ||'';
	
	IF v=0 THEN
		
		EXECUTE IMMEDIATE'
		ALTER TABLE PKD.'|| v_lanc ||'
		ADD Y'|| GFCF_plus ||'_'|| GFCF_EV ||' NUMBER
		'
		; 
	
	END IF;
	
			
FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP
			
	FOR b IN v_out_eszkozcsp.FIRST..v_out_eszkozcsp.LAST LOOP
	
		SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER(''|| v_out_name(b) ||'') AND table_name = ''|| v_gfcf_ar_table ||'';
		IF v > 0 THEN
			
		sql_statement := 'SELECT AGAZAT FROM PKD.'|| v_gfcf_ar_table ||' '; 

		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;

		FOR j IN 1..v_agazat_type.COUNT LOOP  

			EXECUTE IMMEDIATE' 
			UPDATE '|| v_out_schema ||'.'|| v_lanc ||'
			SET Y'|| GFCF_plus ||'_'|| GFCF_EV ||' = 
			(SELECT '|| v_out_name(b) ||' / 100
			FROM '|| v_out_schema ||'.'|| v_gfcf_ar_table ||'
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
		UPDATE '|| v_out_schema ||'.'|| v_lanc ||'
		SET Y'|| GFCF_plus ||'_'|| GFCF_EV ||' = 
		(
		SELECT GRIPPEN / 100
		FROM '|| v_out_schema ||'.'|| v_gfcf_ar_table ||'
		WHERE AGAZAT = ''84''
		)
		WHERE ALSZEKTOR = ''S1311'' AND ESZKOZCSP = ''AN114'' AND AGAZAT = ''846''
		'
		;
		
	END IF;
	
END LOOP;

END IF; -- 2017-től

 ELSE
 
	dbms_output.put_line('Üres a GFCF tábla!');
 
 END IF;


v_out_name(10) := 'K_F';

-- hozzuk létre a bázis árindex alapján (amit előbb egészítettünk ki az aktuális évvel) a lánc árindex táblát is újra -- 2017-től nem kell futtatni, csak a végén lévő 42-> 41 másolás miatt kell

--CFC_ARINDEX.CFC_ARINDEX(''|| v_lanc ||'', ''|| v_bazis ||'');

INSERT INTO PKD.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'END', '');

END gfcf_imp_alt;

END;