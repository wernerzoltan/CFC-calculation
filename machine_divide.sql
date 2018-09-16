/*

create or replace PACKAGE MACHINE_DIVIDE AUTHID CURRENT_USER AS 

TYPE T_AGAZAT_IMP IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_alszektor IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER;

procedure MACHINE_DIVIDE;

END MACHINE_DIVIDE;

-------
*/


create or replace PACKAGE BODY MACHINE_DIVIDE AS 
V_AGAZAT_IMP T_AGAZAT_IMP;
v_out_alszektor t_out_alszektor;

procedure MACHINE_DIVIDE AS

table_gfcf VARCHAR2(30);
table_rate_m VARCHAR2(30);
table_rate VARCHAR2(30);

--alszektor VARCHAR2(30);
sql_statement VARCHAR2(300);

v NUMERIC;

TYPE t_agazat_type IS TABLE OF RATE_MACHINE%ROWTYPE; 
v_agazat_type t_agazat_type; 
TYPE t_agazat_type_gfcf IS TABLE OF GFCF_2015_180904%ROWTYPE; 
v_agazat_type_gfcf t_agazat_type_gfcf; 


BEGIN

--alszektor := 'S1311'; -- ALSZEKTOR beállítása

table_gfcf := 'GFCF_2015_180904';
table_rate_m := 'RATE_MACHINE'; 

-- 1. létrehozzuk a GEP, TARTOSGEP és GYORSOSGEP mezőket
	
	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('TARTOSGEP') AND table_name = ''|| table_gfcf ||'';
	
		IF v=0 THEN
				
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| table_gfcf ||'
			ADD GEP NUMBER
			'
			;  

			EXECUTE IMMEDIATE'
			ALTER TABLE '|| table_gfcf ||'
			ADD TARTOSGEP NUMBER
			'
			;  

			EXECUTE IMMEDIATE'
			ALTER TABLE '|| table_gfcf ||'
			ADD GYORSGEP NUMBER
			'
			;  
			
		END IF;
		
	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE column_name = UPPER('TARTOSGEP_ARANY') AND table_name = ''|| table_rate_m ||'';
	
		IF v=0 THEN		
		
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| table_rate_m ||'
			ADD TARTOSGEP_ARANY NUMBER
			'
			;  
			
			EXECUTE IMMEDIATE'
			ALTER TABLE '|| table_rate_m ||'
			ADD GYORSGEP_ARANY NUMBER
			'
			;  
			
	END IF;

		
-- 2. létrehozzuk a GEP mezőt: 
-- S1311: belföldi gép + import gép + használt gép vásárlás * 0,07 + gép átvét * 0,07 + gép pü-i lízing - fegyver (csak a 841-es ágazatból kell a fegyvert levonni)
-- S1313: belföldi gép + import gép + használt gép vásárlás * 0,07 + gép átvét * 0,07 + gép pü-i lízing
-- S1314: belföldi gép + import gép + használt gép vásárlás * 0,066509 + gép átvét * 0,040289 + gép pü-i lízing

FOR z IN v_out_alszektor.FIRST..v_out_alszektor.LAST LOOP 

IF ''|| v_out_alszektor(z) ||'' = 'S1311' THEN
	table_rate := 'RATE_CALC_KORM';
ELSE
	table_rate := 'RATE_CALC_ONK';
END IF;

	sql_statement := 'SELECT * FROM '|| table_gfcf ||' WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||''' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_gfcf;

	FOR a IN v_agazat_type_gfcf.FIRST..v_agazat_type_gfcf.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_gfcf(a).AGAZAT ||''; 
	END LOOP;

	IF ''|| v_out_alszektor(z) ||'' != 'S1314' THEN
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
			EXECUTE IMMEDIATE'
			UPDATE '|| table_gfcf ||'
			SET GEP =
			(SELECT (((BELFOLDI_GEP + IMPORT_GEP + HASZN_GEP_VASARLAS) * 0.07) + (GEP_ATVET * 0.07) + GEP_PENZUGYI_LIZING)
			FROM '|| table_gfcf ||'
			WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
			AND AGAZAT = '''|| V_AGAZAT_IMP(j) ||''')
			WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
			AND AGAZAT = '''|| V_AGAZAT_IMP(j) ||'''
			'
			;	
	
		END LOOP;
				
		ELSE 
		
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
			EXECUTE IMMEDIATE'
			UPDATE '|| table_gfcf ||'
			SET GEP =
			(SELECT (((BELFOLDI_GEP + IMPORT_GEP + HASZN_GEP_VASARLAS) * 0.066509) + (GEP_ATVET * 0.066509) + GEP_PENZUGYI_LIZING)
			FROM '|| table_gfcf ||'
			WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
			AND AGAZAT = '''|| V_AGAZAT_IMP(j) ||''')
			WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
			AND AGAZAT = '''|| V_AGAZAT_IMP(j) ||'''
			'
			;	
	
		END LOOP;
	
	END IF;
	
	-- S1311 esetén a fegyvert ki kell vonni a 841-ből
	
	IF ''|| v_out_alszektor(z) ||'' = 'S1311' THEN
	
		EXECUTE IMMEDIATE'
		UPDATE '|| table_gfcf ||'
		SET GEP =
		(SELECT GEP - (SELECT sum(FEGYVER) FROM '|| table_gfcf ||' WHERE AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'') AND ALSZEKTOR = ''S1311'')
		FROM '|| table_gfcf ||' 
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''841'')
		WHERE ALSZEKTOR = ''S1311''
		AND AGAZAT = ''841''
		'
		;
		
	END IF;
			
-- 2. ahol a RATE_MACHINE táblában az arányszáma 1 az ARANY_TARTOS esetében, annak a GFCF értéke átkerül a TARTOSGEP mezőbe

sql_statement := 'SELECT * FROM '|| table_rate_m ||' WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||''' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;

	FOR a IN v_agazat_type.FIRST..v_agazat_type.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type(a).T08 ||''; 
	END LOOP;

		
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
		
			
			EXECUTE IMMEDIATE'
			UPDATE '|| table_gfcf ||' 
			SET TARTOSGEP = 
			(SELECT a.GEP
			FROM '|| table_gfcf ||' a
			INNER JOIN '|| table_rate_m ||' b
			ON a.AGAZAT = b.T08 AND a.ALSZEKTOR = b.ALSZEKTOR
			WHERE b.ARANY_TARTOS = ''1''
			AND b.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
			AND b.T08 = '|| V_AGAZAT_IMP(j) ||'
			AND b.T08 != ''841'')
			WHERE AGAZAT = '|| V_AGAZAT_IMP(j) ||'
			AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
			'
			;

		END LOOP;

		
-- 2/b. a 841-es szektor adatait külön át kell pakolni, mert több van belőle a RATE táblában

	EXECUTE IMMEDIATE'
	UPDATE '|| table_gfcf ||' 
	SET TARTOSGEP = 
	(SELECT a.GEP
	FROM '|| table_gfcf ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND AGAZAT = ''841'')
	WHERE AGAZAT = ''841''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;


-- 3. ahol nem 1-es az arányszám, ott számolunk: T08-as ágazat szerinti tartósgép arányszám (RATE_MACHINE) * INV2 arányszám (RATE_CALC)

			
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
	
	-- TARTOSGEP
	EXECUTE IMMEDIATE'
		UPDATE '|| table_rate_m ||' 
		SET TARTOSGEP_ARANY = 
		(SELECT (a.ARANY_TARTOS * b.ARANYSZAM) 
		FROM '|| table_rate_m ||' a
		INNER JOIN '|| table_rate ||' b
		ON a.T08 = b.T08
		WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		AND a.T08 = '''|| V_AGAZAT_IMP(j) ||'''
		AND a.ARANY_TARTOS != ''1''
		AND b.T08 != ''841'')
		WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		AND T08 = '''|| V_AGAZAT_IMP(j) ||'''
		AND T08 != ''841''
		'
		;
		
	-- GYORSOSGEP
	EXECUTE IMMEDIATE'
		UPDATE '|| table_rate_m ||' 
		SET GYORSGEP_ARANY = 
		(SELECT (a.ARANY_GYORS * b.ARANYSZAM) 
		FROM '|| table_rate_m ||' a
		INNER JOIN '|| table_rate ||' b
		ON a.T08 = b.T08
		WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		AND a.T08 = '''|| V_AGAZAT_IMP(j) ||'''
		AND a.ARANY_TARTOS != ''1''
		AND b.T08 != ''841'')
		WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		AND T08 = '''|| V_AGAZAT_IMP(j) ||'''
		AND T08 != ''841''
		'
		;
	
	END LOOP;
	
-- 3/b. a 841-es szektor adatait külön át kell pakolni, mert több van belőle a RATE táblában (a RATE_CALC táblában pedig minden esetben '1'-es értéke van, ezért azzal nem kell JOIN-olni

	IF ''|| v_out_alszektor(z) ||'' = 'S1311' THEN

	-- TARTÓSGÉP
	EXECUTE IMMEDIATE'
	UPDATE '|| table_rate_m ||'
	SET TARTOSGEP_ARANY = 
	(SELECT a.ARANY_TARTOS
	FROM '|| table_rate_m ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND a.T08 = ''841''
	AND a.T03 = ''751'')
	WHERE T08 = ''841''
	AND T03 = ''751''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;
	
	-- GYORSGÉP
	EXECUTE IMMEDIATE'
	UPDATE '|| table_rate_m ||'
	SET GYORSGEP_ARANY = 
	(SELECT a.ARANY_GYORS 
	FROM '|| table_rate_m ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND a.T08 = ''841''
	AND a.T03 = ''751'')
	WHERE T08 = ''841''
	AND T03 = ''751''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;	
	
	ELSIF ''|| v_out_alszektor(z) ||'' = 'S1313' THEN
	
	-- TARTÓSGÉP 751
	EXECUTE IMMEDIATE'
	UPDATE '|| table_rate_m ||'
	SET TARTOSGEP_ARANY = 
	(SELECT a.ARANY_TARTOS
	FROM '|| table_rate_m ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND a.T08 = ''841''
	AND a.T03 = ''751'')
	WHERE T08 = ''841''
	AND T03 = ''751''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;
	
	-- TARTÓSGÉP 62
	EXECUTE IMMEDIATE'
	UPDATE '|| table_rate_m ||'
	SET TARTOSGEP_ARANY = 
	(SELECT a.ARANY_TARTOS
	FROM '|| table_rate_m ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND a.T08 = ''841''
	AND a.T03 = ''62'')
	WHERE T08 = ''841''
	AND T03 = ''62''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;
	
	-- GYORSGÉP 751
	EXECUTE IMMEDIATE'
	UPDATE '|| table_rate_m ||'
	SET GYORSGEP_ARANY = 
	(SELECT a.ARANY_GYORS 
	FROM '|| table_rate_m ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND a.T08 = ''841''
	AND a.T03 = ''751'')
	WHERE T08 = ''841''
	AND T03 = ''751''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;		

	-- GYORSGÉP 62
	EXECUTE IMMEDIATE'
	UPDATE '|| table_rate_m ||'
	SET GYORSGEP_ARANY = 
	(SELECT a.ARANY_GYORS 
	FROM '|| table_rate_m ||' a
	WHERE a.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	AND a.T08 = ''841''
	AND a.T03 = ''62'')
	WHERE T08 = ''841''
	AND T03 = ''62''
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;	

	
	END IF;
	
	
-- 4. ahol nem 1-es az arányszám, ott számolunk: az előzőleg kiszámolt arányszámok * GFCF tábla értéke (GEP)
	
sql_statement := 'SELECT * FROM '|| table_rate_m ||' WHERE ALSZEKTOR = '''|| v_out_alszektor(z) ||''' AND ARANY_TARTOS != ''1'' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;

	FOR a IN v_agazat_type.FIRST..v_agazat_type.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type(a).T08 ||''; 
	END LOOP;	
	
	
	-- TARTÓSGÉP
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
					
		EXECUTE IMMEDIATE'
		UPDATE '|| table_gfcf ||' 
		SET TARTOSGEP = 
		(SELECT (a.GEP * b.TARTOSGEP_ARANY)
		FROM '|| table_gfcf ||' a
		INNER JOIN '|| table_rate_m ||' b
		ON a.AGAZAT = b.T08 
		AND a.ALSZEKTOR = b.ALSZEKTOR
		WHERE b.ARANY_TARTOS != ''1''
		AND b.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		AND b.T08 = '|| V_AGAZAT_IMP(j) ||'
		AND b.T08 != ''841'')
		WHERE AGAZAT = '|| V_AGAZAT_IMP(j) ||'
		AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		'
		;

	END LOOP;
	
		-- GYORSGÉP
	FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
					
		EXECUTE IMMEDIATE'
		UPDATE '|| table_gfcf ||' 
		SET GYORSGEP = 
		(SELECT (a.GEP * b.GYORSGEP_ARANY)
		FROM '|| table_gfcf ||' a
		INNER JOIN '|| table_rate_m ||' b
		ON a.AGAZAT = b.T08 
		AND a.ALSZEKTOR = b.ALSZEKTOR
		WHERE b.ARANY_TARTOS != ''1''
		AND b.ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		AND b.T08 = '|| V_AGAZAT_IMP(j) ||'
		AND b.T08 != ''841'')
		WHERE AGAZAT = '|| V_AGAZAT_IMP(j) ||'
		AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
		'
		;

	END LOOP;
	

-- 841-es átadása
IF ''|| v_out_alszektor(z) ||'' = 'S1311' THEN
	
	-- TARTÓSGÉP
	EXECUTE IMMEDIATE'
	UPDATE '|| table_gfcf ||' 
	SET TARTOSGEP = 
	(SELECT (a.GEP * b.TARTOSGEP_ARANY)
	FROM '|| table_gfcf ||' a
	INNER JOIN '|| table_rate_m ||' b
	ON a.AGAZAT = b.T08 
	AND a.ALSZEKTOR = b.ALSZEKTOR
	WHERE b.T08 = ''841''	
	AND b.T03 = ''751''
	AND a.ALSZEKTOR = '''|| v_out_alszektor(z) ||''')
	WHERE AGAZAT = ''841''	
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;	

	-- GYORSGÉP
	EXECUTE IMMEDIATE'
	UPDATE '|| table_gfcf ||' 
	SET GYORSGEP = 
	(SELECT (a.GEP * b.GYORSGEP_ARANY)
	FROM '|| table_gfcf ||' a
	INNER JOIN '|| table_rate_m ||' b
	ON a.AGAZAT = b.T08 
	AND a.ALSZEKTOR = b.ALSZEKTOR
	WHERE b.T08 = ''841''	
	AND b.T03 = ''751''
	AND a.ALSZEKTOR = '''|| v_out_alszektor(z) ||''')
	WHERE AGAZAT = ''841''	
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;	
	
ELSIF ''|| v_out_alszektor(z) ||'' = 'S1313' THEN
	
	-- TARTÓSGÉP 751
	EXECUTE IMMEDIATE'
	UPDATE '|| table_gfcf ||' 
	SET TARTOSGEP = 
	(SELECT (a.GEP * b.TARTOSGEP_ARANY)
	FROM '|| table_gfcf ||' a
	INNER JOIN '|| table_rate_m ||' b
	ON a.AGAZAT = b.T08 
	AND a.ALSZEKTOR = b.ALSZEKTOR
	WHERE b.T08 = ''841''	
	AND b.T03 = ''751''
	AND a.ALSZEKTOR = '''|| v_out_alszektor(z) ||''')
	WHERE AGAZAT = ''841''	
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;	
	

	-- GYORSGÉP 751
	EXECUTE IMMEDIATE'
	UPDATE '|| table_gfcf ||' 
	SET GYORSGEP = 
	(SELECT (a.GEP * b.GYORSGEP_ARANY)
	FROM '|| table_gfcf ||' a
	INNER JOIN '|| table_rate_m ||' b
	ON a.AGAZAT = b.T08 
	AND a.ALSZEKTOR = b.ALSZEKTOR
	WHERE b.T08 = ''841''	
	AND b.T03 = ''751''
	AND a.ALSZEKTOR = '''|| v_out_alszektor(z) ||''')
	WHERE AGAZAT = ''841''	
	AND ALSZEKTOR = '''|| v_out_alszektor(z) ||'''
	'
	;	
	


END IF;	

END LOOP;
	
END MACHINE_DIVIDE;

BEGIN

v_out_alszektor(1) := 'S1311';
v_out_alszektor(2) := 'S1313';
--v_out_alszektor(3) := 'S1314'; -- TB

END;
