CREATE OR REPLACE PROCEDURE GEP_RATE AS 

v_szektor VARCHAR2(10) := 'S14';
v_alszektor VARCHAR2(10) := 'S14';
v_rate_table VARCHAR2(20) := 'C_IMP_RATE_CALC';
v_in_table VARCHAR2(20) := 'C_GEPEK_T03';
v_out_table VARCHAR2(20) := 'C_GEPEK_T08';
rate_temp VARCHAR2(50) := 'c_calc_temp';
sql_statement VARCHAR2(2000);
z NUMBER;

TYPE t_rate IS TABLE OF c_imp_rate_calc%ROWTYPE; 
v_rate t_rate; 

TYPE t_rate_d IS TABLE OF VARCHAR2(50); 
v_rate_d t_rate_d; 

BEGIN

SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ''|| v_out_table ||'';
	
	IF z=0 THEN
			
		EXECUTE IMMEDIATE'
		CREATE TABLE PKD.'|| v_out_table ||'
		("SZEKTOR" VARCHAR2(26 BYTE), 
		"ALSZEKTOR" VARCHAR2(26 BYTE), 
		"AGAZAT" VARCHAR2(5 BYTE), 
		"TARTOSGEP" NUMBER(19,16), 
		"GYORSGEP" NUMBER(19,16)				
		)';

   
  END IF;

	sql_statement := 'SELECT * FROM PKD.'|| v_rate_table ||' WHERE SZEKTOR = '''|| v_szektor ||''' AND ALSZEKTOR = '''|| v_alszektor ||''' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate;
	
	sql_statement := 'SELECT DISTINCT T08 FROM PKD.'|| v_rate_table ||' WHERE SZEKTOR = '''|| v_szektor ||''' AND ALSZEKTOR = '''|| v_alszektor ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate_d;

-- 1. lépés az új táblába tesszük a T08/T03-as ágazatok listáját
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| v_out_table ||' (SZEKTOR, ALSZEKTOR, AGAZAT) VALUES 
			('''|| v_szektor ||''', '''|| v_alszektor ||''', '|| v_rate_d(c) ||')
			'
			;
		
		END LOOP;
  
  
  	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';


--2. lépés: értéket számolunk TARTÓSGÉP

PKD.TRUNCATE_TABLE(''|| rate_temp ||'');

	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP      	 
		
		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| rate_temp ||' (T08, T03)
		SELECT T08, T03 from PKD.'|| v_rate_table ||'
		WHERE T08 = '''|| v_rate_d(c) ||'''	AND ALSZEKTOR = '''|| v_alszektor ||'''
		'
		;
			
	END LOOP;

	FOR c IN v_rate.FIRST..v_rate.LAST LOOP

		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| rate_temp ||' 
		SET ERTEK =
		(SELECT a.TARTOSGEP * b.ARANYSZAM
		FROM PKD.'|| v_in_table ||' a
		INNER JOIN PKD.'|| v_rate_table ||' b
		ON a.T03 = b.T03
		WHERE a.T03 = '|| v_rate(c).T03 ||' AND b.T03 = '|| v_rate(c).T03 ||' AND b.T08 = '|| v_rate(c).T08 ||' AND a.SZEKTOR = '''|| v_szektor ||''' AND b.SZEKTOR = '''|| v_szektor ||''' 
		)
		WHERE T08 = '|| v_rate(c).T08 ||' AND T03 = '|| v_rate(c).T03 ||'
		'
		;


-- a T08-as táblába beírjuk a SUM / súlyozott átlag értékeket	

		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_out_table ||'
		SET TARTOSGEP = 
		(SELECT (SUM(NVL(a.ERTEK, 0)) / SUM(b.ARANYSZAM))
		FROM PKD.'|| rate_temp ||' a 
		INNER JOIN PKD.'|| v_rate_table ||' b
		ON a.T08 = b.T08
		WHERE a.T08 = '''|| v_rate(c).T08 ||''' AND b.ALSZEKTOR = '''|| v_alszektor ||''')
		WHERE AGAZAT = '''|| v_rate(c).T08 ||''' AND ALSZEKTOR = '''|| v_alszektor ||'''
		'
		;	
		
	END LOOP;	

--2. lépés: értéket számolunk GYORSGÉP

PKD.TRUNCATE_TABLE(''|| rate_temp ||'');

	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP      	 
		
		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| rate_temp ||' (T08, T03)
		SELECT T08, T03 from PKD.'|| v_rate_table ||'
		WHERE T08 = '''|| v_rate_d(c) ||'''	AND ALSZEKTOR = '''|| v_alszektor ||'''
		'
		;
			
	END LOOP;

	FOR c IN v_rate.FIRST..v_rate.LAST LOOP

		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| rate_temp ||' 
		SET ERTEK =
		(SELECT a.GYORSGEP * b.ARANYSZAM
		FROM PKD.'|| v_in_table ||' a
		INNER JOIN PKD.'|| v_rate_table ||' b
		ON a.T03 = b.T03
		WHERE a.T03 = '|| v_rate(c).T03 ||' AND b.T03 = '|| v_rate(c).T03 ||' AND b.T08 = '|| v_rate(c).T08 ||' AND a.SZEKTOR = '''|| v_szektor ||''' AND b.SZEKTOR = '''|| v_szektor ||''' 
		)
		WHERE T08 = '|| v_rate(c).T08 ||' AND T03 = '|| v_rate(c).T03 ||'
		'
		;


-- a T08-as táblába beírjuk a SUM / súlyozott átlag értékeket	
		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_out_table ||'
		SET GYORSGEP = 
		(SELECT (SUM(NVL(a.ERTEK, 0)) / SUM(b.ARANYSZAM))
		FROM PKD.'|| rate_temp ||' a 
		INNER JOIN PKD.'|| v_rate_table ||' b
		ON a.T08 = b.T08
		WHERE a.T08 = '''|| v_rate(c).T08 ||''' AND b.ALSZEKTOR = '''|| v_alszektor ||''')
		WHERE AGAZAT = '''|| v_rate(c).T08 ||''' AND ALSZEKTOR = '''|| v_alszektor ||'''
		'
		;	
		
	END LOOP;
	
  
END;