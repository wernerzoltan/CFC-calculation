--Árindex betöltés
/*
create or replace PACKAGE CFC_ARINDEX_import AUTHID CURRENT_USER AS 
TYPE T_AGAZAT_IMP IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_szektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_alszektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkozcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;

procedure CFC_ARINDEX_import;

END CFC_ARINDEX_import;
*/


create or replace PACKAGE BODY CFC_ARINDEX_import AS 
V_AGAZAT_IMP T_AGAZAT_IMP;
TYPE t_agazat_type IS TABLE OF AR_ALL_LANC_180904%ROWTYPE; 
v_agazat_type t_agazat_type; 
v_out_szektor t_out_szektor;
v_out_alszektor t_out_alszektor;
v_out_eszkozcsp t_out_eszkozcsp;
sql_statement VARCHAR2(500);
v NUMERIC;

procedure CFC_ARINDEX_import AS



BEGIN



-- amelyek nincsenek benne az eddigi táblában:
-- S13 / S1313 
-- AN112

-- S13 esetén az alszektor miatt
FOR a IN 1..v_out_alszektor.COUNT LOOP

	FOR b IN 1..v_out_eszkozcsp.COUNT LOOP
	
	IF ''|| v_out_eszkozcsp(b) ||'' != 'AN1171' THEN
	
	sql_statement := 'SELECT COUNT(*) FROM AR_ALL_LANC_180904 WHERE ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	IF v != 0 THEN
	
	
	sql_statement := 'SELECT * FROM AR_ALL_LANC_180904 WHERE SZEKTOR = ''S13'' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;

	FOR a IN v_agazat_type.FIRST..v_agazat_type.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type(a).AGAZAT ||''; 
	END LOOP;
			
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
		
			EXECUTE IMMEDIATE'
			UPDATE AR_ALL_LANC_180904 
			SET Y2017_2016 = 
			(
			SELECT b.Y2017_2016
			FROM AR_ALL_LANC_180904 a
			INNER JOIN AR_2017 b
			ON a.AGAZAT = b.AGAZAT
			AND a.ESZKOZCSP = b.ESZKOZCSP 
			WHERE b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
			AND a.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
			AND a.ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
			AND a.AGAZAT = '''|| V_AGAZAT_IMP(j) ||'''
			)
			WHERE AGAZAT = '''|| V_AGAZAT_IMP(j) ||'''
			AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
			AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
			'
			;
			
		END LOOP;
	
	END IF;
	
	ELSE -- K+F esetén
	
	sql_statement := 'SELECT COUNT(*) FROM AR_ALL_LANC_180904 WHERE ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' AND SZEKTOR = ''S13'' ';
	EXECUTE IMMEDIATE sql_statement INTO v;
	IF v != 0 THEN
	
	
	sql_statement := 'SELECT * FROM AR_ALL_LANC_180904 WHERE SZEKTOR = ''S13'' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||''' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat_type;

	FOR a IN v_agazat_type.FIRST..v_agazat_type.LAST LOOP 
		V_AGAZAT_IMP(a) := ''|| v_agazat_type(a).AGAZAT ||''; 
	END LOOP;
			
	
		FOR j IN 1..V_AGAZAT_IMP.COUNT LOOP  
		
			EXECUTE IMMEDIATE'
			UPDATE AR_ALL_LANC_180904 
			SET Y2017_2016 = 
			(
			SELECT b.Y2017_2016
			FROM AR_ALL_LANC_180904 a
			INNER JOIN AR_2017 b
			ON a.AGAZAT = b.AGAZAT
			AND a.ESZKOZCSP = b.ESZKOZCSP 
			WHERE b.ESZKOZCSP = ''AN1171''
			AND a.ESZKOZCSP = ''AN1171''
			AND a.ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
			AND a.AGAZAT = '''|| V_AGAZAT_IMP(j) ||'''
			AND b.SZEKTOR = ''S13''
			)
			WHERE AGAZAT = '''|| V_AGAZAT_IMP(j) ||'''
			AND ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
			AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
			'
			;
			
		END LOOP;
	
	
	END IF;
	
	END IF;
	
	END LOOP;
	
END LOOP;



/*
	FOR b IN 1..v_out_eszkozcsp.COUNT LOOP -- S1311

		IF ''|| v_out_eszkozcsp(b) ||'' != 'AN1171' THEN
	
		EXECUTE IMMEDIATE'
		INSERT INTO AR_ALL_LANC_180904 (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT, Y2017_2016)
		SELECT ''S13'', ''S1311'', '''|| v_out_eszkozcsp(b) ||''', b.AGAZAT, b.ALAGAZAT, b.Y2017_2016
		FROM AR_ALL_LANC_180904 a
		RIGHT JOIN AR_2017 b
		ON a.AGAZAT = b.AGAZAT

		WHERE b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
		AND a.SZEKTOR IS NULL
		'
		;

		ELSE -- K+F esetén
		
		EXECUTE IMMEDIATE' 
		INSERT INTO AR_ALL_LANC_180904 (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT, Y2017_2016)
		SELECT ''S13'', ''S1311'', ''AN1171'', b.AGAZAT, b.ALAGAZAT, b.Y2017_2016
		FROM AR_ALL_LANC_180904 a
		RIGHT JOIN AR_2017 b
		ON a.AGAZAT = b.AGAZAT

		WHERE b.ESZKOZCSP = ''AN1171''
		AND b.SZEKTOR = ''S13''
		AND a.SZEKTOR IS NULL
		'
		;		
		
		END IF;
		
	END LOOP;
	*/

		FOR b IN 1..v_out_eszkozcsp.COUNT LOOP -- S1313

		IF ''|| v_out_eszkozcsp(b) ||'' != 'AN1171' THEN
	
		EXECUTE IMMEDIATE'
		INSERT INTO AR_ALL_LANC_180904 (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT, Y2017_2016)
		SELECT ''S13'', ''S1313'', '''|| v_out_eszkozcsp(b) ||''', b.AGAZAT, b.ALAGAZAT, b.Y2017_2016
		FROM AR_ALL_LANC_180904 a
		RIGHT JOIN AR_2017 b
		ON a.AGAZAT = b.AGAZAT

		WHERE b.ESZKOZCSP = '''|| v_out_eszkozcsp(b) ||'''
		AND a.SZEKTOR IS NULL
		'
		;

		ELSE -- K+F esetén
		
		EXECUTE IMMEDIATE' 
		INSERT INTO AR_ALL_LANC_180904 (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT, Y2017_2016)
		SELECT ''S13'', ''S1313'', ''AN1171'', b.AGAZAT, b.ALAGAZAT, b.Y2017_2016
		FROM AR_ALL_LANC_180904 a
		RIGHT JOIN AR_2017 b
		ON a.AGAZAT = b.AGAZAT

		WHERE b.ESZKOZCSP = ''AN1171''
		AND b.SZEKTOR = ''S13''
		AND a.SZEKTOR IS NULL
		'
		;		
		
		END IF;
		
	END LOOP;
	

*/
END CFC_ARINDEX_import;

BEGIN

v_out_szektor(1) := 'S13';

v_out_alszektor(1) := 'S1311';
v_out_alszektor(2) := 'S1313';
v_out_alszektor(3) := 'S1314';

v_out_eszkozcsp(1) := 'AN111';
v_out_eszkozcsp(2) := 'AN112';
v_out_eszkozcsp(3) := 'AN1123';
v_out_eszkozcsp(4) := 'AN1131';
v_out_eszkozcsp(5) := 'AN1132';
v_out_eszkozcsp(6) := 'AN1139';
v_out_eszkozcsp(7) := 'AN114';
v_out_eszkozcsp(8) := 'AN114a';
v_out_eszkozcsp(9) := 'AN11731a';
v_out_eszkozcsp(10) := 'AN11731b';
v_out_eszkozcsp(11) := 'AN1174';
v_out_eszkozcsp(12) := 'AN1171';



END;