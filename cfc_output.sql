/*

create or replace PACKAGE CFC_OUTPUT AUTHID CURRENT_USER AS 
TYPE t_out_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkcsp_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_eszkcsp_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_szektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_alszektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_table IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_ar_table IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_table_ja IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_table_vall IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_year IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_year_pre IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;
TYPE T_AGAZAT_IMP IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER;

procedure CFC_OUTPUT;

END CFC_OUTPUT;

*/



create or replace PACKAGE BODY CFC_OUTPUT AS 
V_AGAZAT_IMP T_AGAZAT_IMP;
v_out_eszkcsp t_out_eszkcsp;
v_out_eszkcsp_c t_out_eszkcsp_c;
v_out_nk_eszkcsp t_out_nk_eszkcsp;
v_out_nk_eszkcsp_c t_out_nk_eszkcsp_c;
v_out_szektor t_out_szektor;
v_out_alszektor t_out_alszektor;
v_in_eszkcsp t_in_eszkcsp;
v_out_table t_out_table;
v_ar_table t_ar_table;
v_in_table_ja t_in_table_ja;
v_in_year t_in_year;
v_in_year_pre t_in_year_pre;
v_in_table_vall t_in_table_vall;

sql_statement VARCHAR2(500);

procedure CFC_OUTPUT AS

TYPE t_agazat_type_1311 IS TABLE OF OUTPUT_S1311_ALAP%ROWTYPE; 
v_agazat_type_1311 t_agazat_type_1311; 
TYPE t_agazat_type_1313 IS TABLE OF OUTPUT_S1313_ALAP%ROWTYPE; 
v_agazat_type_1313 t_agazat_type_1313; 
TYPE t_agazat_type_1314 IS TABLE OF OUTPUT_S1314_ALAP%ROWTYPE; 
v_agazat_type_1314 t_agazat_type_1314; 

classic_imp BOOLEAN;
more_imp BOOLEAN;
v NUMERIC;

cfc_input_far VARCHAR2(50) := 'cfc_input_far'; -- nem klasszikus eszközök folyó áras értékei (Q)
cfc_input_var VARCHAR2(50) := 'cfc_input_var'; -- nem klasszikus eszközök változatlan áras értékei (V)

BEGIN

classic_imp := TRUE; -- ha a klasszikus eszközöket be akarjuk importálni, akkor TRUE
more_imp := TRUE; -- ha a nem klasszikus eszközöket be akarjuk importálni, akkor TRUE



IF classic_imp = TRUE THEN

IF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN
	sql_statement := 'SELECT * FROM OUTPUT_S1313_ALAP';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1313;
		
		FOR a IN v_agazat_type_1313.FIRST..v_agazat_type_1313.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_1313(a).AGAZAT ||''; 
		DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
		
ELSIF ''|| v_out_alszektor(1) ||'' = 'S1311' THEN
	sql_statement := 'SELECT * FROM OUTPUT_S1311_ALAP';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1311;
		
		FOR a IN v_agazat_type_1311.FIRST..v_agazat_type_1311.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_1311(a).AGAZAT ||''; 
		DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
		
ELSE 
	sql_statement := 'SELECT * FROM OUTPUT_S1314_ALAP';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1314;
		
		FOR a IN v_agazat_type_1314.FIRST..v_agazat_type_1314.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_1314(a).AGAZAT ||''; 
		DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
		
END IF;
	

-- 1. lépés: az OUTPUT táblákba átvesszük a vég táblákból az YSUM_AKT értékeket eszközcsoportonként és évenként
FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN 1..v_out_szektor.COUNT LOOP 

		IF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN
		
		EXECUTE IMMEDIATE'
		create table '|| v_out_table(b) ||''|| v_in_year(x) ||' as select * from OUTPUT_S1313_ALAP
		'
		;
		
		ELSIF ''|| v_out_alszektor(1) ||'' = 'S1311' THEN
		
		EXECUTE IMMEDIATE'
		create table '|| v_out_table(b) ||''|| v_in_year(x) ||' as select * from OUTPUT_S1311_ALAP
		'
		;
				
		ELSE 
		
		EXECUTE IMMEDIATE'
		create table '|| v_out_table(b) ||''|| v_in_year(x) ||' as select * from OUTPUT_S1314_ALAP
		'
		;
		
		END IF;
	
		FOR c IN 1..v_out_alszektor.COUNT LOOP 
	
			FOR a IN 1..v_out_eszkcsp.COUNT LOOP 
	
				FOR l IN 1..V_AGAZAT_IMP.COUNT LOOP

					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
					SET '|| v_out_eszkcsp(a) ||' = 
					(SELECT YSUM_AKT FROM '|| v_in_eszkcsp(b) ||''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||' a
					INNER JOIN '|| v_out_table(b) ||''|| v_in_year(x) ||' b
					ON a.AGAZAT = b.AGAZAT
					WHERE a.SZEKTOR = '''|| v_out_szektor(b) ||''' AND a.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND a.ESZKOZCSP = '''|| v_out_eszkcsp_c(a) ||''' AND a.OUTPUT = ''cfc'' AND b.AGAZAT = '''|| V_AGAZAT_IMP(l) ||''')
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''
					'
					;
				
				END LOOP;
				
			END LOOP;
		
		END LOOP;
	
	END LOOP;
	
END LOOP;
	
-- SUM mező kiszámítása

FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN 1..v_out_table.COUNT LOOP
	
		FOR l IN 1..V_AGAZAT_IMP.COUNT LOOP
		
			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
			SET SUM_CLASSIC = 
			(SELECT '|| v_out_eszkcsp(1) ||' + '|| v_out_eszkcsp(2) ||' + '|| v_out_eszkcsp(3) ||' + '|| v_out_eszkcsp(4) ||' + '|| v_out_eszkcsp(5) ||' as SUM_CLASSIC
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''
			)
			WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''
			'
			;
								
		END LOOP;

	END LOOP;
	
END LOOP;



-- 2. lépés:  3 jegyű ágazatok összevonása 2 jegyűvé 

IF ''|| v_out_alszektor(1) ||'' = 'S1311' THEN -- kormányzat esetén

FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN 1..v_out_table.COUNT LOOP

		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''42'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''421'', ''422'')
			'
			;
			
			
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''71'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''711'', ''712'')
			'
			;
		
		-- K+F
		EXECUTE IMMEDIATE' 
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''72'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''721'', ''722'')
			'
			;

		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''82'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''821'', ''822'')
			'
			;

			
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''84'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'')
			'
			;		

		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''85'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''851'', ''852'', ''853'')
			'
			;				
			
		EXECUTE IMMEDIATE'
			DELETE FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''421'', ''422'', ''711'', ''712'', ''721'', ''722'', ''821'', ''822'', ''841'', ''842'', ''843'', ''844'', ''845'', ''851'', ''852'', ''853'')
			'
			;
			
	END LOOP;
	
END LOOP;

ELSIF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN -- önkormányzat esetén

FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN 1..v_out_table.COUNT LOOP

		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''36'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''361'', ''362'')
			'
			;
			
			
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''84'', SUM(EPULET), SUM(TARTOSGEP), SUM(GYORSGEP), SUM(JARMU), SUM(SZOFTVER), SUM(SUM_CLASSIC)
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''841'', ''842'', ''843'', ''844'')
			'
			;

		
		EXECUTE IMMEDIATE'
			DELETE FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''361'', ''362'', ''841'', ''842'', ''843'', ''844'')
			'
			;
			
	END LOOP;
	
END LOOP;


ELSE  -- TB esetén

FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN 1..v_out_table.COUNT LOOP

		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT, EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC)
			SELECT ''84'', EPULET, TARTOSGEP, GYORSGEP, JARMU, SZOFTVER, SUM_CLASSIC
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''841'' 
			'
			;
									
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT)
			SELECT ''42''
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''421'' 
			'
			;
						
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT)
			SELECT ''71''
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''711'' 
			'
			;
						
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT)
			SELECT ''82''
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''821'' 
			'
			;

		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(b) ||''|| v_in_year(x) ||' (AGAZAT)
			SELECT ''85''
			FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''851'' 
			'
			;				
									
		EXECUTE IMMEDIATE'
			DELETE FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
			WHERE AGAZAT IN (''421'', ''422'', ''711'', ''712'', ''821'', ''822'', ''841'', ''842'', ''843'', ''844'', ''845'', ''851'', ''852'', ''853'')
			'
			;

	END LOOP;
	
END LOOP;
					
END IF;


-- 3. lépés: a 42-es ágazatot szétbontjuk 41-es ágazatra is átmásoljuk, és közben arányt számolunk:
-- 41-es ágazat aránya: 0,881445238991344
-- 42-es ágazat aránya: 0,118554761008656

FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN 1..v_out_table.COUNT LOOP

		EXECUTE IMMEDIATE'
		UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
		SET EPULET = (SELECT (EPULET * 0.881445238991344) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		TARTOSGEP = (SELECT (TARTOSGEP * 0.881445238991344) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		GYORSGEP = (SELECT (GYORSGEP * 0.881445238991344) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		JARMU = (SELECT (JARMU * 0.881445238991344) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		SZOFTVER = (SELECT (SZOFTVER * 0.881445238991344) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		SUM_CLASSIC = (SELECT (SUM_CLASSIC * 0.881445238991344) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42'')
		WHERE AGAZAT = ''41''
		'
		;
		
		EXECUTE IMMEDIATE'
		UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
		SET EPULET = (SELECT (EPULET * 0.118554761008656) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		TARTOSGEP = (SELECT (TARTOSGEP * 0.118554761008656) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		GYORSGEP = (SELECT (GYORSGEP * 0.118554761008656) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		JARMU = (SELECT (JARMU * 0.118554761008656) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		SZOFTVER = (SELECT (SZOFTVER * 0.118554761008656) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42''),
		SUM_CLASSIC = (SELECT (SUM_CLASSIC * 0.118554761008656) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''42'')
		WHERE AGAZAT = ''42''
		'
		;
		
	END LOOP;
	
END LOOP;
	

-- 4. lépés: eszközcsoportok ágazaton belüli arányának kiszámolása

IF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN
	sql_statement := 'SELECT * FROM OUTPUT_S1313_1995';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1313;
		
		FOR a IN v_agazat_type_1313.FIRST..v_agazat_type_1313.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_1313(a).AGAZAT ||''; 
		DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
	
	
ELSIF ''|| v_out_alszektor(1) ||'' = 'S1314' THEN
	sql_statement := 'SELECT * FROM OUTPUT_S1314_1995';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1314;
		
		FOR a IN v_agazat_type_1314.FIRST..v_agazat_type_1314.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_1314(a).AGAZAT ||''; 
		DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
	
ELSE 
	sql_statement := 'SELECT * FROM OUTPUT_S1311_1995';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1311;
		
		FOR a IN v_agazat_type_1311.FIRST..v_agazat_type_1311.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type_1311(a).AGAZAT ||''; 
		DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
		
END IF;


FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR b IN 1..v_out_table.COUNT LOOP
			
			FOR l IN 1..V_AGAZAT_IMP.COUNT LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET EPULET_A = (SELECT 
					CASE SUM_CLASSIC 
						WHEN 0 THEN 0
						WHEN NULL THEN NULL
						ELSE EPULET/SUM_CLASSIC*100
						END AS EPULET_A
					FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''),
				TARTOSGEP_A = (SELECT 						
					CASE SUM_CLASSIC 
						WHEN 0 THEN 0
						WHEN NULL THEN NULL
						ELSE TARTOSGEP/SUM_CLASSIC*100
						END AS TARTOSGEP_A
					FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''),
				GYORSGEP_A = (SELECT
					CASE SUM_CLASSIC 
						WHEN 0 THEN 0
						WHEN NULL THEN NULL
						ELSE GYORSGEP/SUM_CLASSIC*100
						END AS GYORSGEP_A
					FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''),
				JARMU_A = (SELECT
					CASE SUM_CLASSIC 
						WHEN 0 THEN 0
						WHEN NULL THEN NULL
						ELSE JARMU/SUM_CLASSIC*100
						END AS JARMU_A
					FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''),
				SZOFTVER_A = (SELECT 
					CASE SUM_CLASSIC 
						WHEN 0 THEN 0
						WHEN NULL THEN NULL
						ELSE SZOFTVER/SUM_CLASSIC*100
						END AS SZOFTVER_A
					FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''),
				SUM_CLASSIC_A = ''100''
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(l) ||'''
				'
				;
						
		END LOOP;
		
	END LOOP;
	
END LOOP;
	
	
	
	
-- át kell pakolni a az OUTPUT_S1311_1995_A - ……. és társai táblákba a SUM_CLASSIC_Q mezőkbe az CFC_INPUT_S1311 és CFC_INPUT_S1313 adatait

	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR b IN 1..v_out_table.COUNT LOOP
			
			FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_CLASSIC_Q =
				(SELECT a.Y'|| v_in_year(x) ||'		
				FROM '|| v_in_table_ja(b) ||' a
				WHERE a.AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
		
			END LOOP;
		
		END LOOP;
				
	END LOOP;
	

-- A 81-es ágazatba átvesszük a 01-es ágazat arány számait (_A értékeket), és azzal számolunk aztán tovább	
	IF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN

	FOR x IN 1..v_in_year.COUNT LOOP
	
		EXECUTE IMMEDIATE'
		UPDATE OUTPUT_S1313_'|| v_in_year(x) ||' 
		SET EPULET_A = (SELECT EPULET_A FROM OUTPUT_S1313_'|| v_in_year(x) ||' WHERE AGAZAT = ''01''),
		TARTOSGEP_A = (SELECT TARTOSGEP_A FROM OUTPUT_S1313_'|| v_in_year(x) ||' WHERE AGAZAT = ''01''),
		GYORSGEP_A = (SELECT GYORSGEP_A FROM OUTPUT_S1313_'|| v_in_year(x) ||' WHERE AGAZAT = ''01''),
		JARMU_A = (SELECT JARMU_A FROM OUTPUT_S1313_'|| v_in_year(x) ||' WHERE AGAZAT = ''01''),
		SZOFTVER_A = (SELECT SZOFTVER_A FROM OUTPUT_S1313_'|| v_in_year(x) ||' WHERE AGAZAT = ''01'')
		WHERE AGAZAT = ''81''
		'
		;
	
	END LOOP;
	
	END IF;

-- 	a _Q végű mezőkbe ki kell számítani az adatokat a SUM_CLASSIC_Q és az arányszámok alapján

	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR c IN 1..v_out_table.COUNT LOOP
	
			FOR b IN 1..v_out_eszkcsp.COUNT LOOP
			
				FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
		
						EXECUTE IMMEDIATE'
						UPDATE '|| v_out_table(c) ||''|| v_in_year(x) ||'
						SET '|| v_out_eszkcsp(b) ||'_Q =
						(SELECT ((a.'|| v_out_eszkcsp(b) ||'_A * 0.01) * a.SUM_CLASSIC_Q)
						FROM '|| v_out_table(c) ||''|| v_in_year(x) ||' a
						WHERE a.AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
						'
						;	
			
				END LOOP;
		
			END LOOP;
		
		END LOOP;
		
	END LOOP;
	
-- 2016 után épület esetében már nem számolunk az arány alapján, hanem a CFC.create_pim futása során létrehozott táblák YSUM_AKT értékeit vesszük át

	FOR x IN 22..v_in_year.COUNT LOOP
	
		FOR b IN 1..v_out_szektor.COUNT LOOP 
		
			FOR d IN 1..v_out_alszektor.COUNT LOOP 
	
				FOR c IN 1..v_out_table.COUNT LOOP
				
					FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
	
						EXECUTE IMMEDIATE'
						UPDATE '|| v_out_table(c) ||''|| v_in_year(x) ||'
						SET '|| v_out_eszkcsp(1) ||'_Q =
						(SELECT EPULET FROM '|| v_out_table(c) ||''|| v_in_year(x) ||'
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
						)
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
						'
						;
							
					END LOOP;
				
				END LOOP;
			
			END LOOP;
		
		END LOOP;
		
	END LOOP;
	
	
	-- SUM kiszámítása a _Q esetében
	
	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR a IN 1..v_out_table.COUNT LOOP
	
			FOR b IN 1..v_out_eszkcsp.COUNT LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET '|| v_out_eszkcsp(b) ||'_Q =
				(SELECT SUM('|| v_out_eszkcsp(b) ||'_Q)
				FROM '|| v_out_table(a) ||''|| v_in_year(x) ||')
				WHERE AGAZAT = ''SUM''
				'
				;					
	
			END LOOP;
	
		END LOOP;
	
	END LOOP;
	
	
	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR a IN 1..v_out_table.COUNT LOOP
	
			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
			SET SUM_CLASSIC_Q =
			(SELECT (NVL(JARMU_Q, 0) + NVL(EPULET_Q, 0) + NVL(TARTOSGEP_Q, 0) + NVL(GYORSGEP_Q, 0) + NVL(SZOFTVER_Q, 0)) as sum_v FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''SUM'')
			WHERE AGAZAT = ''SUM''
			'
			;
	
		END LOOP;
	
	END LOOP;


-- 5. lépés: változatlan ár kiszámítása, a _Q végű mezők / lánc árindex értékével

	FOR x IN 2..v_in_year.COUNT LOOP
	
		FOR c IN 1..v_out_table.COUNT LOOP
	
			FOR b IN 1..v_out_eszkcsp.COUNT LOOP
	
				FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
				
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(c) ||''|| v_in_year(x) ||'
					SET '|| v_out_eszkcsp(b) ||'_V =
					(SELECT (a.'|| v_out_eszkcsp(b) ||'_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||')
					FROM
					'|| v_out_table(c) ||''|| v_in_year(x) ||' a
					INNER JOIN
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||'''
					WHERE a.AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
					WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
						
				END LOOP;
			
			END LOOP;
	
		END LOOP;
		
	END LOOP;


-- változatlan SUM érték számítás

	FOR x IN 2..v_in_year.COUNT LOOP
	
		FOR b IN 1..v_out_table.COUNT LOOP
	
			FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_CLASSIC_V =
				(SELECT (NVL(JARMU_V, 0) + NVL(EPULET_V, 0) + NVL(TARTOSGEP_V, 0) + NVL(GYORSGEP_V, 0) + NVL(SZOFTVER_V, 0)) as sum_v FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
	
			END LOOP;
	
		END LOOP;
	
	END LOOP;

	-- SUM mező kiszámítása a SUM rekord esetében
	
	FOR x IN 2..v_in_year.COUNT LOOP
	
		FOR a IN 1..v_out_table.COUNT LOOP
	
			FOR b IN 1..v_out_eszkcsp.COUNT LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET '|| v_out_eszkcsp(b) ||'_V =
				(SELECT SUM('|| v_out_eszkcsp(b) ||'_V)
				FROM '|| v_out_table(a) ||''|| v_in_year(x) ||')
				WHERE AGAZAT = ''SUM''
				'
				;					
	
			END LOOP;
	
		END LOOP;
	
	END LOOP;
	
	
	FOR x IN 2..v_in_year.COUNT LOOP
	
		FOR a IN 1..v_out_table.COUNT LOOP
	
			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
			SET SUM_CLASSIC_V =
			(SELECT (NVL(JARMU_V, 0) + NVL(EPULET_V, 0) + NVL(TARTOSGEP_V, 0) + NVL(GYORSGEP_V, 0) + NVL(SZOFTVER_V, 0)) as sum_v FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'
			WHERE AGAZAT = ''SUM'')
			WHERE AGAZAT = ''SUM''
			'
			;
	
		END LOOP;
	
	END LOOP;

	--S1314 esetén a SUM_ALL_x értéke legyen a SUM_CLASSIC_x értéke
IF ''|| v_out_alszektor(1) ||'' = 'S1314' THEN

	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR a IN 1..v_out_table.COUNT LOOP
		
			FOR b IN 1..V_AGAZAT_IMP.COUNT LOOP
		
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET SUM_ALL_Q = (SELECT SUM_CLASSIC_Q FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''),
				SUM_ALL_V = (SELECT SUM_CLASSIC_V FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''
				'
				;
		
			END LOOP;
		
		END LOOP;

	END LOOP;

END IF;
		
	/*
-- S1313 esetén a 01-es ágazat arányaival számoljuk ki a 81-es ágazat értékeit

IF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN

	FOR x IN 1..v_in_year.COUNT LOOP
			

		EXECUTE IMMEDIATE'
		INSERT INTO OUTPUT_S1313_'|| v_in_year(x) ||' (AGAZAT, EPULET,TARTOSGEP,GYORSGEP,JARMU,SZOFTVER,BESOROLT_VALL,ORIGINALS,LAKAS,MEZO,EPULET_UTAK_KORR,MELIO,SUM_CLASSIC,SUM_ALL,EPULET_A,TARTOSGEP_A,GYORSGEP_A,JARMU_A,SZOFTVER_A,SUM_CLASSIC_A,EPULET_Q,TARTOSGEP_Q,GYORSGEP_Q,JARMU_Q,SZOFTVER_Q,ORIGINALS_Q,LAKAS_Q,MEZO_Q,EPULET_UTAK_KORR_Q,MELIO_Q,BESOROLT_VALL_Q,SUM_CLASSIC_Q,SUM_ALL_Q,EPULET_V,TARTOSGEP_V,GYORSGEP_V,JARMU_V,SZOFTVER_V,ORIGINALS_V,LAKAS_V,MEZO_V,EPULET_UTAK_KORR_V,BESOROLT_VALL_V,SUM_CLASSIC_V,SUM_ALL_V)
		(SELECT ''81a'', EPULET,TARTOSGEP,GYORSGEP,JARMU,SZOFTVER,BESOROLT_VALL,ORIGINALS,LAKAS,MEZO,EPULET_UTAK_KORR,MELIO,SUM_CLASSIC,SUM_ALL,EPULET_A,TARTOSGEP_A,GYORSGEP_A,JARMU_A,SZOFTVER_A,SUM_CLASSIC_A,EPULET_Q,TARTOSGEP_Q,GYORSGEP_Q,JARMU_Q,SZOFTVER_Q,ORIGINALS_Q,LAKAS_Q,MEZO_Q,EPULET_UTAK_KORR_Q,MELIO_Q,BESOROLT_VALL_Q,SUM_CLASSIC_Q,SUM_ALL_Q,EPULET_V,TARTOSGEP_V,GYORSGEP_V,JARMU_V,SZOFTVER_V,ORIGINALS_V,LAKAS_V,MEZO_V,EPULET_UTAK_KORR_V,BESOROLT_VALL_V,SUM_CLASSIC_V,SUM_ALL_V
		FROM OUTPUT_S1313_'|| v_in_year(x) ||' 
		WHERE AGAZAT = ''01'')
		'
		;
		
		EXECUTE IMMEDIATE'
		DELETE FROM OUTPUT_S1313_'|| v_in_year(x) ||'
		WHERE AGAZAT = ''81''
		'
		;
		
		EXECUTE IMMEDIATE'
		UPDATE OUTPUT_S1313_'|| v_in_year(x) ||'
		SET AGAZAT = ''81''
		WHERE AGAZAT = ''81a''
		'
		;
	
	END LOOP;
	
END IF;
*/

END IF;




------------
-- 6. lépés:  nem klasszikus eszközök importja

IF more_imp = TRUE THEN  

	-- Q értékek átemelése FÁR adattáblából
	
FOR c IN 1..v_out_alszektor.COUNT LOOP

	IF ''|| v_out_alszektor(c) ||'' != 'S1314' THEN -- S1311 és S1313 közös nem klasszikus eszközcsoportjai

		FOR x IN 1..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
												
				-- ORIGINALS
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET ORIGINALS_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1174'')
				WHERE AGAZAT = ''60''
				'
				;
				
				-- MELIORÁCIÓ
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET MELIO_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1123'' AND AGAZAT = ''84'')
				WHERE AGAZAT = ''84''
				'
				;
				
				-- UTAK
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET EPULET_UTAK_KORR_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN112b'')
				WHERE AGAZAT = ''84''
				'
				;
																
			END LOOP;
			
		END LOOP;
				
	END IF;
	
	
	IF ''|| v_out_alszektor(c) ||'' = 'S1311' THEN  -- S1311 nem klasszikus eszközcsoportjai
	
		FOR x IN 1..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				-- FEGYVER
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET FEGYVER_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN114'')
				WHERE AGAZAT = ''84''
				'
				;				
					
				-- OWNSOFT
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET OWNSOFT_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN11731a'')
				WHERE AGAZAT = ''84''
				'
				;	
				
				-- EPULET_PPP_KORR / 1
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET EPULET_PPP_KORR_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN112c'' AND AGAZAT = ''55'')
				WHERE AGAZAT = ''55''
				'
				;
								
				-- EPULET_PPP_KORR / 2
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET EPULET_PPP_KORR_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN112c'' AND AGAZAT = ''85'')
				WHERE AGAZAT = ''85''
				'
				;
						
			END LOOP;
			
		END LOOP;

		-- K+F esetén csak 2015-ig, 2016-tól a cfc.create_pim eljárás során létrehozott táblából vesszük az adatokat
		FOR x IN 1..21 LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET K_F_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1171'')
				WHERE AGAZAT = ''72''
				'
				;
		
			END LOOP;
		
		END LOOP;
		
		-- K+F 2016-tól
		FOR x IN 22..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET K_F_Q =
				(SELECT YSUM_AKT FROM '|| v_in_eszkcsp(a) ||'K_F_'|| v_in_year(x) ||'
				WHERE AGAZAT = ''SUM'')
				WHERE AGAZAT = ''72''
				'
				;
		
			END LOOP;
		
		END LOOP;
			
	END IF;
	
	IF ''|| v_out_alszektor(c) ||'' = 'S1313' THEN  -- S1313 nem klasszikus eszközcsoportjai
	
		FOR x IN 1..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				-- LAKÁS
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET LAKAS_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN111'')
				WHERE AGAZAT = ''68''
				'
				;

				-- MEZŐ
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET MEZO_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN115'')
				WHERE AGAZAT = ''01''
				'
				;
				
				-- MELIORÁCIÓ
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET MELIO_Q =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_far ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1123'' AND AGAZAT = ''39'')
				WHERE AGAZAT = ''39''
				'
				;
				
			END LOOP;
		
		END LOOP;
		
	END IF;
		
END LOOP;


	
-- 7. lépés: V értékek átemelése VÁR adattáblából
	
FOR c IN 1..v_out_alszektor.COUNT LOOP

	IF ''|| v_out_alszektor(c) ||'' != 'S1314' THEN -- S1311 és S1313 közös nem klasszikus eszközcsoportjai

		FOR x IN 1..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
												
				-- ORIGINALS
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET ORIGINALS_V =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_var ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1174'')
				WHERE AGAZAT = ''60''
				'
				;
				
				-- MELIORÁCIÓ
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET MELIO_V =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_var ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1123'' AND AGAZAT = ''84'')
				WHERE AGAZAT = ''84''
				'
				;				
				
			END LOOP;
			
		END LOOP;
		
	END IF;
	
	IF ''|| v_out_alszektor(c) ||'' = 'S1311' THEN -- S1311 nem klasszikus eszközcsoportjai
	
		FOR x IN 1..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
												
				-- OWNSOFT
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET OWNSOFT_V =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_var ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN11731a'')
				WHERE AGAZAT = ''84''
				'
				;	
				
			END LOOP;
			
		END LOOP;

		-- K+F esetén csak 2015-ig emeljük át, 2016-tól a 9. lépésben számoljuk a Q értékből
		FOR x IN 1..21 LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
												
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET K_F_V =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_var ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1171'')
				WHERE AGAZAT = ''72''
				'
				;
		
			END LOOP;
		
		END LOOP;
		
	END IF;

	IF ''|| v_out_alszektor(c) ||'' = 'S1313' THEN -- S1313 nem klasszikus eszközcsoportjai
	
		FOR x IN 1..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
	
				-- MELIORÁCIÓ
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET MELIO_V =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_var ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN1123'' AND AGAZAT = ''39'')
				WHERE AGAZAT = ''39''
				'
				;	

				-- MEZŐ
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
				SET MEZO_V =
				(SELECT Y'|| v_in_year(x) ||' 
				FROM '|| cfc_input_var ||'
				WHERE ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND ESZKOZCSP = ''AN115'')
				WHERE AGAZAT = ''01''
				'
				;
				
			END LOOP;
			
		END LOOP;
		
	END IF;
	
	
	

-- 8. lépés: a BESOROLT_VALL adatokat az S1311 és S1313 táblákba be kell illeszteni 2007-től

IF ''|| v_out_alszektor(c) ||'' != 'S1314' THEN 

IF ''|| v_out_alszektor(1) ||'' = 'S1313' THEN
	sql_statement := 'SELECT * FROM OUTPUT_S1313_1995';
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1313;

		FOR a IN v_agazat_type_1313.FIRST..v_agazat_type_1313.LAST LOOP 
			V_AGAZAT_IMP(a) := ''|| v_agazat_type_1313(a).AGAZAT ||''; 
			DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
	
ELSE 
	sql_statement := 'SELECT * FROM OUTPUT_S1311_1995'; 
	
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type_1311;

		FOR a IN v_agazat_type_1311.FIRST..v_agazat_type_1311.LAST LOOP 
			V_AGAZAT_IMP(a) := ''|| v_agazat_type_1311(a).AGAZAT ||''; 
			DBMS_OUTPUT.put_line(V_AGAZAT_IMP(a));
		END LOOP;
	
	
END IF;
	
	
		FOR x IN 13..v_in_year.COUNT LOOP -- csak 2007-től kell
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				FOR b IN 1..V_AGAZAT_IMP.COUNT LOOP
			
					FOR c IN 1..v_in_table_vall.COUNT LOOP
										
						-- Q értékek átemelése
						EXECUTE IMMEDIATE'
						UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
						SET BESOROLT_VALL_Q =
						(SELECT Y'|| v_in_year(x) ||'
						FROM '|| v_in_table_vall(c) ||'
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||''')
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''
						'
						;
						
						
						-- BESOROLT_VALL adatokból _V értékek számítása (BESOROLT_VALL_Q / (SUM_CLASSIC_Q / SUM_CLASSIC_V))
						EXECUTE IMMEDIATE'
						UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
						SET BESOROLT_VALL_V =
						(SELECT BESOROLT_VALL_Q / (SUM_CLASSIC_Q / SUM_CLASSIC_V)
						FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''
						AND BESOROLT_VALL_Q != ''0''
						AND SUM_CLASSIC_Q != ''0''
						AND SUM_CLASSIC_V != ''0''
						)
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''
						'
						;						

						
						--  BESOROLT_VALL adatokból _V értékek számítása, ahol az előzőleg kiszámolt érték 0
						EXECUTE IMMEDIATE'
						UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
						SET BESOROLT_VALL_V =
						(SELECT BESOROLT_VALL_Q / (SELECT SUM_CLASSIC_Q / SUM_CLASSIC_V FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' WHERE AGAZAT = ''SUM'')		
						FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''
						AND BESOROLT_VALL_Q != ''0''
						AND SUM_CLASSIC_Q = ''0'')
						WHERE AGAZAT = '''|| V_AGAZAT_IMP(b) ||'''
						AND BESOROLT_VALL_V IS NULL
						'
						;							
									
					
					END LOOP;
				
				END LOOP;
			/*
			-- SUM rekord kiszámítása
			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
			SET BESOROLT_VALL_Q = 
			(SELECT SUM(BESOROLT_VALL_Q) 
			FROM '|| v_out_table(a) ||''|| v_in_year(x) ||'),
			BESOROLT_VALL_V =
			(SELECT SUM(BESOROLT_VALL_V) 
			FROM '|| v_out_table(a) ||''|| v_in_year(x) ||')
			WHERE AGAZAT = ''SUM''
			'
			;
					*/
			END LOOP;
			
		END LOOP;

	END IF;
	
END LOOP;
	
-- 9. lépés: ahol nincsen a VAR táblában érték, azokat ki kell számolni a FAR értékek alapján - specifikusan a következő eszközökre (FEGYVER (S1311), EPULET_UTAK_KORR (S1311, S1313), EPULET_PPP_KORR (S1311), LAKAS (S1313)). K+F esetén 2016-tól számoljuk ezzel a módszerrel, 2015-ig a VAR táblából vesszük át az adatokat
  
FOR c IN 1..v_out_alszektor.COUNT LOOP 
	
	IF ''|| v_out_alszektor(c) ||'' = 'S1311' THEN 
		
		FOR x IN 2..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				FOR b IN 1..V_AGAZAT_IMP.COUNT LOOP
					
					-- FEGYVER
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
					SET FEGYVER_V =
					(SELECT a.FEGYVER_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||'
					FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' a
					INNER JOIN 
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT 
					WHERE a.AGAZAT = ''84'' AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = ''AN114'')
					WHERE AGAZAT = ''84''
					'
					;
					
					-- EPULET_PPP_KORR 55
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'					
					SET EPULET_PPP_KORR_V = 
					(SELECT a.EPULET_PPP_KORR_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||'
					FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' a
					INNER JOIN 
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT 
					WHERE a.AGAZAT = ''55'' AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = ''AN112'')
					WHERE AGAZAT = ''55''
					'
					;

					-- EPULET_PPP_KORR 85
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'					
					SET EPULET_PPP_KORR_V = 
					(SELECT a.EPULET_PPP_KORR_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||'
					FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' a
					INNER JOIN 
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT 
					WHERE a.AGAZAT = ''85'' AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = ''AN112'')
					WHERE AGAZAT = ''85''
					'
					;					
												
				END LOOP;
				
			END LOOP;
	
		END LOOP;
	
		-- K+F esetén 2016-tól számoljuk, 2015-ig a VAR táblából vesszük át az adatokat
		FOR x IN 22..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
					SET K_F_V =
					(SELECT a.K_F_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||'
					FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' a
					INNER JOIN 
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT 
					WHERE a.AGAZAT = ''72'' AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = ''AN1171'')
					WHERE AGAZAT = ''72''
					'
					;
						
			END LOOP;
			
		END LOOP;
	
	END IF;	
	
IF ''|| v_out_alszektor(c) ||'' = 'S1313' THEN 

	FOR x IN 2..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				FOR b IN 1..V_AGAZAT_IMP.COUNT LOOP
					
					-- LAKAS
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
					SET LAKAS_V = 
					(SELECT a.LAKAS_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||'
					FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' a
					INNER JOIN 
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT
					WHERE a.AGAZAT = ''68'' AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = ''AN112'')
					WHERE AGAZAT = ''68''
					'
					;
										
												
				END LOOP;
				
			END LOOP;
	
		END LOOP;

END IF;	

IF ''|| v_out_alszektor(c) ||'' != 'S1314' THEN 

		FOR x IN 2..v_in_year.COUNT LOOP
	
			FOR a IN 1..v_out_table.COUNT LOOP
			
				FOR b IN 1..V_AGAZAT_IMP.COUNT LOOP

					-- EPULET_UTAK_KORR
					EXECUTE IMMEDIATE'
					UPDATE '|| v_out_table(a) ||''|| v_in_year(x) ||'
					SET EPULET_UTAK_KORR_V = 
					(SELECT a.EPULET_UTAK_KORR_Q / b.Y'|| v_in_year(x) ||'_'|| v_in_year_pre(x) ||'
					FROM '|| v_out_table(a) ||''|| v_in_year(x) ||' a
					INNER JOIN 
					'|| v_ar_table(1) ||' b
					ON a.AGAZAT = b.AGAZAT 
					WHERE a.AGAZAT = ''84'' AND b.SZEKTOR = '''|| v_out_szektor(1) ||''' AND b.ALSZEKTOR1 = '''|| v_out_alszektor(c) ||''' AND b.ESZKOZCSP = ''AN112'')
					WHERE AGAZAT = ''84''
					'
					;

				END LOOP;
				
			END LOOP;
	
		END LOOP;
					
					
END IF;

END LOOP;
 
	
	/*
-- S1313 esetén a 01-es ágazat értékei kerüljenek át a 81-es ágazatba

FOR c IN 1..v_out_alszektor.COUNT LOOP 

IF ''|| v_out_alszektor(c) ||'' = 'S1313' THEN

	FOR x IN 1..v_in_year.COUNT LOOP

		EXECUTE IMMEDIATE'
		INSERT INTO OUTPUT_S1313_'|| v_in_year(x) ||' (AGAZAT, EPULET,TARTOSGEP,GYORSGEP,JARMU,SZOFTVER,BESOROLT_VALL,ORIGINALS,LAKAS,MEZO,EPULET_UTAK_KORR,MELIO,SUM_CLASSIC,SUM_ALL,EPULET_A,TARTOSGEP_A,GYORSGEP_A,JARMU_A,SZOFTVER_A,SUM_CLASSIC_A,EPULET_Q,TARTOSGEP_Q,GYORSGEP_Q,JARMU_Q,SZOFTVER_Q,ORIGINALS_Q,LAKAS_Q,MEZO_Q,EPULET_UTAK_KORR_Q,MELIO_Q,BESOROLT_VALL_Q,SUM_CLASSIC_Q,SUM_ALL_Q,EPULET_V,TARTOSGEP_V,GYORSGEP_V,JARMU_V,SZOFTVER_V,ORIGINALS_V,LAKAS_V,MEZO_V,EPULET_UTAK_KORR_V,BESOROLT_VALL_V,SUM_CLASSIC_V,SUM_ALL_V)
		(SELECT ''81a'', EPULET,TARTOSGEP,GYORSGEP,JARMU,SZOFTVER,BESOROLT_VALL,ORIGINALS,LAKAS,MEZO,EPULET_UTAK_KORR,MELIO,SUM_CLASSIC,SUM_ALL,EPULET_A,TARTOSGEP_A,GYORSGEP_A,JARMU_A,SZOFTVER_A,SUM_CLASSIC_A,EPULET_Q,TARTOSGEP_Q,GYORSGEP_Q,JARMU_Q,SZOFTVER_Q,ORIGINALS_Q,LAKAS_Q,MEZO_Q,EPULET_UTAK_KORR_Q,MELIO_Q,BESOROLT_VALL_Q,SUM_CLASSIC_Q,SUM_ALL_Q,EPULET_V,TARTOSGEP_V,GYORSGEP_V,JARMU_V,SZOFTVER_V,ORIGINALS_V,LAKAS_V,MEZO_V,EPULET_UTAK_KORR_V,BESOROLT_VALL_V,SUM_CLASSIC_V,SUM_ALL_V
		FROM OUTPUT_S1313_'|| v_in_year(x) ||' 
		WHERE AGAZAT = ''01'')
		'
		;
		
		EXECUTE IMMEDIATE'
		DELETE FROM OUTPUT_S1313_'|| v_in_year(x) ||'
		WHERE AGAZAT = ''81''
		'
		;
		
		EXECUTE IMMEDIATE'
		UPDATE OUTPUT_S1313_'|| v_in_year(x) ||'
		SET AGAZAT = ''81''
		WHERE AGAZAT = ''81a''
		'
		;
		
	END LOOP;
			
END IF;

END LOOP;
*/
-- 10. lépés: SUM számítás a nem klasszikus eszközökre csoportonként

FOR c IN 1..v_out_alszektor.COUNT LOOP 

IF ''|| v_out_alszektor(c) ||'' != 'S1314' THEN

	FOR x IN 1..v_in_year.COUNT LOOP 
	
		FOR b IN 1..v_out_table.COUNT LOOP

			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
			SET ORIGINALS_Q =
			(SELECT SUM(ORIGINALS_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			ORIGINALS_V =
			(SELECT SUM(ORIGINALS_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			EPULET_UTAK_KORR_Q =
			(SELECT SUM(EPULET_UTAK_KORR_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),	
			EPULET_UTAK_KORR_V =
			(SELECT SUM(EPULET_UTAK_KORR_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			MELIO_Q =
			(SELECT SUM(MELIO_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),	
			MELIO_V =
			(SELECT SUM(MELIO_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			BESOROLT_VALL_Q =
			(SELECT SUM(BESOROLT_VALL_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),	
			BESOROLT_VALL_V =
			(SELECT SUM(BESOROLT_VALL_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||')
			WHERE AGAZAT = ''SUM''
			'
			;
				
		END LOOP;
			
	END LOOP;
	
END IF;

IF 	''|| v_out_alszektor(c) ||'' = 'S1311' THEN

	FOR x IN 1..v_in_year.COUNT LOOP 
	
		FOR b IN 1..v_out_table.COUNT LOOP
	
			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
			SET EPULET_PPP_KORR_Q =
			(SELECT SUM(EPULET_PPP_KORR_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			EPULET_PPP_KORR_V =
			(SELECT SUM(EPULET_PPP_KORR_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			FEGYVER_Q =
			(SELECT SUM(FEGYVER_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			FEGYVER_V =
			(SELECT SUM(FEGYVER_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			OWNSOFT_Q =
			(SELECT SUM(OWNSOFT_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			OWNSOFT_V =
			(SELECT SUM(OWNSOFT_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			K_F_Q =
			(SELECT SUM(K_F_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			K_F_V =
			(SELECT SUM(K_F_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||')
			WHERE AGAZAT = ''SUM''
			'
			;
			
		END LOOP;
		
	END LOOP;
	
END IF;

IF 	''|| v_out_alszektor(c) ||'' = 'S1313' THEN

	FOR x IN 1..v_in_year.COUNT LOOP 
	
		FOR b IN 1..v_out_table.COUNT LOOP

			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
			SET LAKAS_Q =
			(SELECT SUM(LAKAS_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			LAKAS_V =
			(SELECT SUM(LAKAS_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			MEZO_Q =
			(SELECT SUM(MEZO_Q) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
			MEZO_V =
			(SELECT SUM(MEZO_V) FROM '|| v_out_table(b) ||''|| v_in_year(x) ||')
			WHERE AGAZAT = ''SUM''
			'
			;
			
		END LOOP;
		
	END LOOP;
	
END IF;

END LOOP;


-- SUM mező számítás a nem klasszikus eszközökre

FOR c IN 1..v_out_alszektor.COUNT LOOP 

IF ''|| v_out_alszektor(c) ||'' = 'S1311' THEN
	
	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR b IN 1..v_out_table.COUNT LOOP
	
			FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_ALL_Q =
				(SELECT NVL(JARMU_Q, 0) + NVL(EPULET_Q, 0) + NVL(TARTOSGEP_Q, 0) + NVL(GYORSGEP_Q, 0) + NVL(SZOFTVER_Q, 0) +  NVL(ORIGINALS_Q, 0) + NVL(EPULET_PPP_KORR_Q, 0) + NVL(FEGYVER_Q, 0) + NVL(OWNSOFT_Q, 0) + NVL(K_F_Q, 0) + NVL(EPULET_UTAK_KORR_Q, 0) + NVL(MELIO_Q, 0) + NVL(BESOROLT_VALL_Q, 0) as SUM_ALL_Q FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
				
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_ALL_V =
				(SELECT NVL(JARMU_V, 0) + NVL(EPULET_V, 0) + NVL(TARTOSGEP_V, 0) + NVL(GYORSGEP_V, 0) + NVL(SZOFTVER_V, 0) +  NVL(ORIGINALS_V, 0) + NVL(EPULET_PPP_KORR_V, 0) + NVL(FEGYVER_V, 0) + NVL(OWNSOFT_V, 0) + NVL(K_F_V, 0) + NVL(EPULET_UTAK_KORR_V, 0) + NVL(MELIO_V, 0) + NVL(BESOROLT_VALL_V, 0) as SUM_ALL_V FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
				/*
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_ALL_Q =
				(SELECT SUM(SUM_ALL_Q)
				FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
				SUM_ALL_V =
				(SELECT SUM(SUM_ALL_V)
				FROM '|| v_out_table(b) ||''|| v_in_year(x) ||')
				WHERE AGAZAT = ''SUM''
				'
				;
	*/
			END LOOP;
	
		END LOOP;
	
	END LOOP;
	
END IF;
	
	
IF ''|| v_out_alszektor(c) ||'' = 'S1313' THEN 

	FOR x IN 1..v_in_year.COUNT LOOP
	
		FOR b IN 1..v_out_table.COUNT LOOP
	
			FOR a IN 1..V_AGAZAT_IMP.COUNT LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_ALL_Q =
				(SELECT NVL(JARMU_Q, 0) + NVL(EPULET_Q, 0) + NVL(TARTOSGEP_Q, 0) + NVL(GYORSGEP_Q, 0) + NVL(SZOFTVER_Q, 0) +  NVL(ORIGINALS_Q, 0) + NVL(LAKAS_Q, 0) + NVL(MEZO_Q, 0) + NVL(EPULET_UTAK_KORR_Q, 0) +NVL(MELIO_Q, 0) + NVL(BESOROLT_VALL_Q, 0) as SUM_ALL_Q 
				FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
				
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_ALL_V =
				(SELECT NVL(JARMU_V, 0) + NVL(EPULET_V, 0) + NVL(TARTOSGEP_V, 0) + NVL(GYORSGEP_V, 0) + NVL(SZOFTVER_V, 0) +  NVL(ORIGINALS_V, 0) + NVL(LAKAS_V, 0) + NVL(MEZO_V, 0) + NVL(EPULET_UTAK_KORR_V, 0) +NVL(MELIO_V, 0) + NVL(BESOROLT_VALL_V, 0) as SUM_ALL_V 
				FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||''')
				WHERE AGAZAT = '''|| V_AGAZAT_IMP(a) ||'''
				'
				;
				/*
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_table(b) ||''|| v_in_year(x) ||'
				SET SUM_ALL_Q =
				(SELECT SUM(SUM_ALL_Q)
				FROM '|| v_out_table(b) ||''|| v_in_year(x) ||'),
				SUM_ALL_V =
				(SELECT SUM(SUM_ALL_V)
				FROM '|| v_out_table(b) ||''|| v_in_year(x) ||')
				WHERE AGAZAT = ''SUM''
				'
				;
	*/
			END LOOP;
	
		END LOOP;
	
	END LOOP;
	
END IF;
		
END LOOP;
	
END IF;
		
		
END CFC_OUTPUT;

BEGIN

-- klasszikus eszközcsoportok
v_out_eszkcsp(1) := 'EPULET'; --AN112
v_out_eszkcsp(2) := 'TARTOSGEP'; --AN1139
v_out_eszkcsp(3) := 'JARMU'; --AN1131
v_out_eszkcsp(4) := 'GYORSGEP'; --AN1132
v_out_eszkcsp(5) := 'SZOFTVER'; --AN1132

v_out_eszkcsp_c(1) := 'AN112';
v_out_eszkcsp_c(2) := 'AN1139';
v_out_eszkcsp_c(3) := 'AN1131';
v_out_eszkcsp_c(4) := 'AN1132';
v_out_eszkcsp_c(5) := 'AN11731b';


-- nem klasszikus eszközcsoportok, S1311 és 1313 közösek
v_out_nk_eszkcsp(1) := 'ORIGINALS'; --AN1174
v_out_nk_eszkcsp(2) := 'MELIO'; --AN1123
v_out_nk_eszkcsp(3) := 'EPULET_UTAK_KORR'; --AN1123
v_out_nk_eszkcsp(4) := 'K_F'; --AN1171
v_out_nk_eszkcsp(5) := 'FEGYVER'; --AN114
v_out_nk_eszkcsp(6) := 'OWNSOFT'; --AN114
v_out_nk_eszkcsp(7) := 'EPULET_PPP_KORR / 1'; --AN112c
v_out_nk_eszkcsp(8) := 'EPULET_PPP_KORR / 2'; --AN112c
v_out_nk_eszkcsp(9) := 'LAKAS'; --AN111


v_out_nk_eszkcsp_c(1) := 'AN1174';
v_out_nk_eszkcsp_c(2) := 'AN1123';
v_out_nk_eszkcsp_c(3) := 'AN112b';
v_out_nk_eszkcsp_c(4) := 'AN1171';
v_out_nk_eszkcsp_c(5) := 'AN114';
v_out_nk_eszkcsp_c(6) := 'AN11731a';
v_out_nk_eszkcsp_c(7) := 'AN112c';
v_out_nk_eszkcsp_c(8) := 'AN112c';
v_out_nk_eszkcsp_c(9) := 'AN111';


v_out_szektor(1) := 'S13';

v_out_alszektor(1) := 'S1311';
--v_out_alszektor(1) := 'S1313';
--v_out_alszektor(1) := 'S1314'; -- TB

v_in_eszkcsp(1) := 'KORM_KOZP_';
--v_in_eszkcsp(1) := 'KORM_ONK_';
--v_in_eszkcsp(1) := 'KORM_TB_';

v_out_table(1) := 'OUTPUT_S1311_';
--v_out_table(1) := 'OUTPUT_S1313_';
--v_out_table(1) := 'OUTPUT_S1314_'; -- TB

--v_ar_table(1) := 'AR_ALL_LANC';
v_ar_table(1) := 'AR_ALL_LANC_180904';

v_in_table_ja(1) := 'CFC_INPUT_S1311';
--v_in_table_ja(1) := 'CFC_INPUT_S1313';
--v_in_table_ja(1) := 'CFC_INPUT_S1314'; -- TB

v_in_table_vall(1) := 'CFC_KOZP_VALL';
--v_in_table_vall(1) := 'CFC_ONK_VALL';


v_in_year(1) := '1995';
v_in_year(2) := '1996';
v_in_year(3) := '1997';
v_in_year(4) := '1998';
v_in_year(5) := '1999';
v_in_year(6) := '2000';
v_in_year(7) := '2001';
v_in_year(8) := '2002';
v_in_year(9) := '2003';
v_in_year(10) := '2004';
v_in_year(11) := '2005';
v_in_year(12) := '2006';
v_in_year(13) := '2007';
v_in_year(14) := '2008';
v_in_year(15) := '2009';
v_in_year(16) := '2010';
v_in_year(17) := '2011';
v_in_year(18) := '2012';
v_in_year(19) := '2013';
v_in_year(20) := '2014';
v_in_year(21) := '2015';
v_in_year(22) := '2016';

v_in_year_pre(1) := '1994';
v_in_year_pre(2) := '1995';
v_in_year_pre(3) := '1996';
v_in_year_pre(4) := '1997';
v_in_year_pre(5) := '1998';
v_in_year_pre(6) := '1999';
v_in_year_pre(7) := '2000';
v_in_year_pre(8) := '2001';
v_in_year_pre(9) := '2002';
v_in_year_pre(10) := '2003';
v_in_year_pre(11) := '2004';
v_in_year_pre(12) := '2005';
v_in_year_pre(13) := '2006';
v_in_year_pre(14) := '2007';
v_in_year_pre(15) := '2008';
v_in_year_pre(16) := '2009';
v_in_year_pre(17) := '2010';
v_in_year_pre(18) := '2011';
v_in_year_pre(19) := '2012';
v_in_year_pre(20) := '2013';
v_in_year_pre(21) := '2014';
v_in_year_pre(22) := '2015';



END;


