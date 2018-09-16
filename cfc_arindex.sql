/*

create or replace PACKAGE CFC_ARINDEX AUTHID CURRENT_USER AS 
TYPE t_out_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkcsp_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkcsp_d IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_szektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_alszektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_table IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_ar_table IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_year IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_year_pre IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER;
TYPE T_AGAZAT_IMP IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER;

procedure CFC_ARINDEX;

END CFC_ARINDEX;

*/


create or replace PACKAGE BODY CFC_ARINDEX AS 
V_AGAZAT_IMP T_AGAZAT_IMP;
v_out_eszkcsp_c t_out_eszkcsp_c;
v_out_eszkcsp_d t_out_eszkcsp_d;
v_out_szektor t_out_szektor;
v_out_alszektor t_out_alszektor;
v_in_eszkcsp t_in_eszkcsp;
v_out_table t_out_table;
v_ar_table t_ar_table;
v_in_year t_in_year;
v_in_year_pre t_in_year_pre;

sql_statement VARCHAR2(500);

procedure CFC_ARINDEX AS

v NUMERIC;

BEGIN

-- Szükséges a későbbi, CFC_OUTPUT eljárás során kialakítandó tábláknál a 81-es ágazat miatt (a 01-es ágazatból veszünk értékeket) a 01-es árindex értékeit a 81-es ágazatba átmaásolni már a bázis árindex táblában

	FOR a IN 1..v_out_alszektor.COUNT LOOP 

		FOR b IN 1..v_out_eszkcsp_c.COUNT LOOP

		
			sql_statement := 'SELECT COUNT(*) FROM '|| v_ar_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''81'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 0 THEN
		
	
			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_ar_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1995_1999, Y1996_1999, Y1997_1999, Y1998_1999, Y1999_1999, Y2000_1999, Y2001_1999, Y2002_1999, Y2003_1999, Y2004_1999, Y2005_1999, Y2006_1999, Y2007_1999, Y2008_1999, Y2009_1999, Y2010_1999, Y2011_1999, Y2012_1999, Y2013_1999, Y2014_1999, Y2015_1999, Y2016_1999)
			SELECT SZEKTOR, ALSZEKTOR1, ESZKOZCSP, ''81'', Y1995_1999, Y1996_1999, Y1997_1999, Y1998_1999, Y1999_1999, Y2000_1999, Y2001_1999, Y2002_1999, Y2003_1999, Y2004_1999, Y2005_1999, Y2006_1999, Y2007_1999, Y2008_1999, Y2009_1999, Y2010_1999, Y2011_1999, Y2012_1999, Y2013_1999, Y2014_1999, Y2015_1999, Y2016_1999
			FROM '|| v_ar_table(1) ||' 
			WHERE AGAZAT = ''01''
			AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
			AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||'''
			'
			;
		END IF;
		
		END LOOP;
	
	END LOOP;
	



	EXECUTE IMMEDIATE'
	TRUNCATE TABLE '|| v_out_table(1) ||'
	'
	;
	

FOR a IN 1..v_out_alszektor.COUNT LOOP 

	-- lánc tábla kialakítása
	EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
		SELECT SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT,
		Y1996_1999 / Y1995_1999, 
		Y1997_1999 / Y1996_1999, 
		Y1998_1999 / Y1997_1999, 
		Y1999_1999 / Y1998_1999, 
		Y2000_1999 / Y1999_1999, 
		Y2001_1999 / Y2000_1999, 
		Y2002_1999 / Y2001_1999, 
		Y2003_1999 / Y2002_1999, 
		Y2004_1999 / Y2003_1999, 
		Y2005_1999 / Y2004_1999, 
		Y2006_1999 / Y2005_1999, 
		Y2007_1999 / Y2006_1999, 
		Y2008_1999 / Y2007_1999, 
		Y2009_1999 / Y2008_1999, 
		Y2010_1999 / Y2009_1999, 
		Y2011_1999 / Y2010_1999, 
		Y2012_1999 / Y2011_1999, 
		Y2013_1999 / Y2012_1999, 
		Y2014_1999 / Y2013_1999, 
		Y2015_1999 / Y2014_1999, 
		Y2016_1999 / Y2015_1999
		
		FROM '|| v_ar_table(1) ||' 
		WHERE ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
		
	'
	;
	
	FOR b IN 1..v_out_eszkcsp_c.COUNT LOOP

		IF ''|| v_out_alszektor(a) ||'' = 'S1311' THEN
	
		-- hozzá kell adni két jegyű ágazatokat is
		
			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''361'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN
		
	
		
			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''36'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''361''
		
			'
			;

		END IF;
		
		
			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''421'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN		
		

			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''42'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''421''
		
		'
		;
		
		END IF;
		

			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''711'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN
		
		
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''71'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''711''
		
		'
		;
		
		END IF;

			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''821'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN

	
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''82'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''821''
		
		'
		;
		
		END IF;

			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''841'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN


		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''84'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''841''
		
		'
		;
		
		END IF;


			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''851'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN


		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''85'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''851''
		
		'
		;

		
		END IF;
		
			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1311'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''721'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 1 THEN


		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''72'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''721''
		
		'
		;
		
		END IF;
		
		END IF;
	

		
		IF ''|| v_out_alszektor(a) ||'' = 'S1313' THEN

		sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1313'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''361'' ';
		EXECUTE IMMEDIATE sql_statement INTO v;
		IF v = 1 THEN
		
		
			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''36'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''361''
		
		'
		;
		
		END IF;

		sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1313'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''841'' ';
		EXECUTE IMMEDIATE sql_statement INTO v;
		IF v = 1 THEN


		
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''84'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''841''
		
		'
		;

		END IF;
		
		END IF;
		
		IF ''|| v_out_alszektor(a) ||'' = 'S1314' THEN

		sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S1313'' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''841'' ';
		EXECUTE IMMEDIATE sql_statement INTO v;
		IF v = 1 THEN

		
		EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''84'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||'
			WHERE SZEKTOR = '''|| v_out_szektor(1) ||''' AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||''' AND AGAZAT = ''841''
		
		'
		;		
		
		END IF;
		
		END IF;
		
		
-- fegyver (AN114 és AN114a) esetében az AR_ALL_LANC értékeit felül kell írni 2013 és 2016 között a következő értékekkel

	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2013_2012 = ''0.99178371''
	WHERE SZEKTOR = ''AN114''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2013_2012 = ''1.017313949''
	WHERE SZEKTOR = ''AN114a''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2014_2013 = ''0.9518''
	WHERE SZEKTOR = ''AN114''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2014_2013 = ''1.0508''
	WHERE SZEKTOR = ''AN114a''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2015_2014 = ''0.993523577''
	WHERE SZEKTOR = ''AN114''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2015_2014 = ''1.009995876''
	WHERE SZEKTOR = ''AN114a''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2016_2015 = ''0.986593281''
	WHERE SZEKTOR = ''AN114''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE '|| v_out_table(1) ||' 
	SET Y2016_2015 = ''1.02876703''
	WHERE SZEKTOR = ''AN114a''
	'
	;
	

-- a 42-es ágazatot át kell másolni a 41-es ágazatba


		sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table(1) ||' WHERE ALSZEKTOR1 = ''S13131'' AND ESZKOZCSP = ''AN112'' AND AGAZAT = ''41'' ';
		EXECUTE IMMEDIATE sql_statement INTO v;
		IF v = 0 THEN

							
			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_table(1) ||' (SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
			SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''84'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015
			FROM '|| v_out_table(1) ||' 
			WHERE AGAZAT = ''42''
			AND ALSZEKTOR1 = '''|| v_out_alszektor(a) ||'''
			AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||'''
			'
			;
			
		END IF;	
					
	END LOOP;
	
END LOOP;

END CFC_ARINDEX;

BEGIN

v_out_szektor(1) := 'S13';

v_out_alszektor(1) := 'S1311';
v_out_alszektor(2) := 'S1313';
v_out_alszektor(3) := 'S1314'; -- TB

v_out_eszkcsp_c(1) := 'AN112';
v_out_eszkcsp_c(2) := 'AN1139';
v_out_eszkcsp_c(3) := 'AN1131';
v_out_eszkcsp_c(4) := 'AN1132';
v_out_eszkcsp_c(5) := 'AN11731b';
v_out_eszkcsp_c(6) := 'AN114';
v_out_eszkcsp_c(7) := 'AN114a';
v_out_eszkcsp_c(7) := 'AN1171';
/*
v_out_eszkcsp_d(1) := 'AN112';
v_out_eszkcsp_d(2) := 'AN1139';
v_out_eszkcsp_d(3) := 'AN1131';
v_out_eszkcsp_d(4) := 'AN1132';
v_out_eszkcsp_d(5) := 'AN11731b';
*/
v_ar_table(1) := 'AR_ALL_BAZIS_180904';

v_out_table(1) := 'AR_ALL_LANC_180904';


END;