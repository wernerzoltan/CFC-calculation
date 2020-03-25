/*

create or replace PACKAGE MACHINE_DIVIDE AUTHID CURRENT_USER AS 
TYPE T_SZEKTOR IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;
procedure MACHINE_DIVIDE(table_gfcf_out VARCHAR2, t_rate_m VARCHAR2, calc VARCHAR2);
END MACHINE_DIVIDE;

-------
*/


create or replace PACKAGE BODY MACHINE_DIVIDE AS 
V_SZEKTOR T_SZEKTOR;

procedure MACHINE_DIVIDE(table_gfcf_out VARCHAR2, t_rate_m VARCHAR2, calc VARCHAR2) AS

table_gfcf_inp VARCHAR2(30);
szektor VARCHAR2(30);
table_rate_m VARCHAR2(30);

sql_statement VARCHAR2(300);

v NUMERIC;

TYPE t_agazat_type IS TABLE OF VARCHAR2(20); 
v_agazat_type t_agazat_type; 
TYPE t_agazat_type_gfcf IS TABLE OF VARCHAR2(20);
v_agazat_type_gfcf t_agazat_type_gfcf; 

BEGIN
V_SZEKTOR(1) := 'S1311';
V_SZEKTOR(2) := 'S1313';
V_SZEKTOR(3) := 'S11';
V_SZEKTOR(4) := 'S12';
V_SZEKTOR(5) := 'S14';
V_SZEKTOR(6) := 'S15';
V_SZEKTOR(7) := 'S1311a';
V_SZEKTOR(8) := 'S1313a';
V_SZEKTOR(9) := 'S1314';


table_gfcf_inp := ''|| table_gfcf_out ||'';
table_rate_m := ''|| t_rate_m ||'';

IF calc = '0' THEN
-- 1. létrehozzuk a GEP mezőt: 
-- S1311: (belföldi gép + import gép) + (használt gép vásárlás * 0,07) + gép átvét * 0,07 + gép pü-i lízing - fegyver (csak a 841-es ágazatból kell a fegyvert levonni)
-- S11, S12, S14, S15, S1313: (belföldi gép + import gép) + (használt gép vásárlás * 0,07) + gép átvét * 0,07 + gép pü-i lízing
-- S1314: belföldi gép + import gép + használt gép vásárlás * 0,066509 + gép átvét * 0,040289 + gép pü-i lízing

	FOR a IN V_SZEKTOR.FIRST..8 LOOP -- S11, S12, S1311, S1313, S14, S15, S1311a, S1313a esetén
	
	sql_statement := 'SELECT AGAZAT FROM '|| table_gfcf_inp ||' WHERE alszektor = '''|| V_SZEKTOR(a) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_gfcf;
	
		FOR j IN 1..v_agazat_type_gfcf.COUNT LOOP  
	
			EXECUTE IMMEDIATE'
			UPDATE PKD19.'|| table_gfcf_inp ||'
			SET GEP =
			(SELECT (NVL(BELFOLDI_GEP, 0) + NVL(IMPORT_GEP, 0)) + (NVL(HASZN_GEP_VASARLAS, 0) * 0.07) + (NVL(GEP_ATVET, 0) * 0.07) + NVL(GEP_PENZUGYI_LIZING, 0)
			FROM PKD19.'|| table_gfcf_inp ||'
			WHERE alszektor = '''|| V_SZEKTOR(a) ||'''
			AND AGAZAT = '''|| v_agazat_type_gfcf(j) ||''')
			WHERE alszektor = '''|| V_SZEKTOR(a) ||'''
			AND AGAZAT = '''|| v_agazat_type_gfcf(j) ||'''
			'
			;	
	
		END LOOP;
		
	END LOOP;
				
	-- S1314 esetén

	sql_statement := 'SELECT AGAZAT FROM '|| table_gfcf_inp ||' WHERE alszektor = ''S1314'' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_gfcf;
	
		FOR j IN 1..v_agazat_type_gfcf.COUNT LOOP  
	
			EXECUTE IMMEDIATE'
			UPDATE PKD19.'|| table_gfcf_inp ||'
			SET GEP =
			(SELECT (NVL(BELFOLDI_GEP, 0) + NVL(IMPORT_GEP, 0)) + (NVL(HASZN_GEP_VASARLAS, 0) * 0.066509) + (NVL(GEP_ATVET, 0) * 0.066509) + NVL(GEP_PENZUGYI_LIZING, 0)
			FROM PKD19.'|| table_gfcf_inp ||'
			WHERE alszektor = ''S1314''
			AND AGAZAT = '''|| v_agazat_type_gfcf(j) ||''')
			WHERE alszektor = ''S1314''
			AND AGAZAT = '''|| v_agazat_type_gfcf(j) ||'''
			'
			;	
	
		END LOOP;
	
	
	-- 2. lépés: S1311 esetén a fegyvert ki kell vonni a 841-ből
		
		EXECUTE IMMEDIATE'
		UPDATE PKD19.'|| table_gfcf_inp ||'
		SET GEP =
		(SELECT NVL(GEP, 0) - (SELECT NVL(sum(FEGYVER), 0) FROM PKD19.'|| table_gfcf_inp ||' 
		WHERE AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'') 
		AND alszektor = ''S1311'')
		FROM '|| table_gfcf_inp ||' 
		WHERE alszektor = ''S1311''
		AND AGAZAT = ''841'')
		WHERE alszektor = ''S1311''
		AND AGAZAT = ''841''
		'
		;

END IF;

-- 3. lépés: az előzőleg beimportált arányszámok * GFCF tábla értéke (GEP)
IF calc = '1' THEN

FOR a IN V_SZEKTOR.FIRST..V_SZEKTOR.LAST LOOP

	sql_statement := 'SELECT AGAZAT FROM '|| table_rate_m ||' WHERE alszektor = '''|| V_SZEKTOR(a) ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;
		
	-- TARTÓSGÉP
	FOR j IN 1..v_agazat_type.COUNT LOOP  
					
		EXECUTE IMMEDIATE'
		UPDATE PKD19.'|| table_gfcf_inp ||' 
		SET TARTOSGEP = 
		(SELECT (NVL(a.GEP, 0) * NVL(b.TARTOSGEP, 0))
		FROM PKD19.'|| table_gfcf_inp ||' a
		INNER JOIN PKD19.'|| table_rate_m ||' b
		ON a.AGAZAT = b.AGAZAT 
		AND a.alszektor = b.alszektor
		--WHERE b.TARTOSGEP != ''1''
		WHERE b.alszektor = '''|| V_SZEKTOR(a) ||'''
		AND b.AGAZAT = '|| v_agazat_type(j) ||')
		--AND b.T08 != ''841'')
		WHERE AGAZAT = '|| v_agazat_type(j) ||'
		AND alszektor = '''|| V_SZEKTOR(a) ||'''
		'
		;

	END LOOP;
	
		-- GYORSGÉP
	FOR j IN 1..v_agazat_type.COUNT LOOP  
					
		EXECUTE IMMEDIATE'
		UPDATE PKD19.'|| table_gfcf_inp ||' 
		SET GYORSGEP = 
		(SELECT (NVL(a.GEP, 0) * NVL(b.GYORSGEP, 0))
		FROM PKD19.'|| table_gfcf_inp ||' a
		INNER JOIN PKD19.'|| table_rate_m ||' b
		ON a.AGAZAT = b.AGAZAT 
		AND a.alszektor = b.alszektor
		--WHERE b.TARTOSGEP != ''1''
		WHERE b.alszektor = '''|| V_SZEKTOR(a) ||'''
		AND b.AGAZAT = '|| v_agazat_type(j) ||')
		--AND b.AGAZAT != ''841'')
		WHERE AGAZAT = '|| v_agazat_type(j) ||'
		AND alszektor = '''|| V_SZEKTOR(a) ||'''
		'
		;

	END LOOP;
	
END LOOP;
	
-- S15 esetén a GEP = TARTOSGEP

	sql_statement := 'SELECT AGAZAT FROM '|| table_gfcf_inp ||' WHERE alszektor = ''S15'' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_gfcf;

	FOR j IN 1..v_agazat_type_gfcf.COUNT LOOP  

		EXECUTE IMMEDIATE'
		UPDATE PKD19.'|| table_gfcf_inp ||' 
		SET TARTOSGEP = (SELECT NVL(GEP, 0)
		FROM PKD19.'|| table_gfcf_inp ||' 
		WHERE alszektor = ''S15''
		AND AGAZAT = '|| v_agazat_type_gfcf(j) ||')
		WHERE alszektor = ''S15''
		AND AGAZAT = '|| v_agazat_type_gfcf(j) ||'
		'
		;
	
	END LOOP;
	
END IF;

END MACHINE_DIVIDE;

END;