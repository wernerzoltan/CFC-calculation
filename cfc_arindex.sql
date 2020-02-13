/*

create or replace PACKAGE CFC_ARINDEX AUTHID CURRENT_USER AS 
TYPE t_out_eszkcsp_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;

TYPE t_out_szektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_alszektor IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;


procedure CFC_ARINDEX(v_lanc VARCHAR2, v_bazis VARCHAR2);

END CFC_ARINDEX;

*/
-- C_IMP_AR_LANC_T08_KL_S13_ALAP
-- C_IMP_AR_BAZIS_T08_KL_S13_ALAP

create or replace PACKAGE BODY CFC_ARINDEX AS 
v_out_eszkcsp_c t_out_eszkcsp_c;

v_out_szektor t_out_szektor;
v_out_alszektor t_out_alszektor;

sql_statement VARCHAR2(500);

procedure CFC_ARINDEX(v_lanc VARCHAR2, v_bazis VARCHAR2) AS

v_ar_table VARCHAR2(30);
v_out_table VARCHAR2(30);
v NUMERIC;

BEGIN

v_ar_table := ''|| v_bazis ||'';
v_out_table := ''|| v_lanc ||'';

-- most már nem töröljük, mivel megvan
	
	SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = UPPER(''|| v_lanc ||'');
	
		IF v=1 THEN
	
	EXECUTE IMMEDIATE'
	TRUNCATE TABLE PKD.'|| v_out_table ||'
	'
	;
	
		ELSE 
		
	EXECUTE IMMEDIATE'
	CREATE TABLE PKD.'|| v_out_table ||'
	(	"SZEKTOR" VARCHAR2(26 BYTE), 
	"ALSZEKTOR" VARCHAR2(26 BYTE), 
	"ESZKOZCSP" VARCHAR2(26 BYTE), 
	"AGAZAT" VARCHAR2(5 BYTE), 
	"EGYEB" VARCHAR2(26 BYTE), 
	"Y1996_1995" NUMBER(19,16), 
	"Y1997_1996" NUMBER(19,16), 
	"Y1998_1997" NUMBER(19,16), 
	"Y1999_1998" NUMBER(19,16), 
	"Y2000_1999" NUMBER(19,16), 
	"Y2001_2000" NUMBER(19,16), 
	"Y2002_2001" NUMBER(19,16), 
	"Y2003_2002" NUMBER(19,16), 
	"Y2004_2003" NUMBER(19,16), 
	"Y2005_2004" NUMBER(19,16), 
	"Y2006_2005" NUMBER(19,16), 
	"Y2007_2006" NUMBER(19,16), 
	"Y2008_2007" NUMBER(19,16), 
	"Y2009_2008" NUMBER(19,16), 
	"Y2010_2009" NUMBER(19,16), 
	"Y2011_2010" NUMBER(19,16), 
	"Y2012_2011" NUMBER(19,16), 
	"Y2013_2012" NUMBER(19,16), 
	"Y2014_2013" NUMBER(19,16), 
	"Y2015_2014" NUMBER(19,16), 
	"Y2016_2015" NUMBER(19,16),
	"Y2017_2016" NUMBER(19,16),
	"Y2018_2017" NUMBER(19,16)
   )	
	';
	
	END IF;
		
	
	-- lánc tábla kialakítása -- csak 2016_1999-ig, onnantól átszedjük a GFCF_AR táblából az értéket
	EXECUTE IMMEDIATE'
	INSERT INTO PKD.'|| v_out_table ||' (SZEKTOR, ALSZEKTOR, ESZKOZCSP, AGAZAT, EGYEB, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015)
	SELECT SZEKTOR, ALSZEKTOR, ESZKOZCSP, AGAZAT, EGYEB,
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
--	Y2017_1999 / Y2016_1999

	
	FROM PKD.'|| v_ar_table ||' 
	'
	;
		
			
-- fegyver (AN114) esetében az AR_ALL_LANC értékeit felül kell írni 2013 és 2016 között a következő értékekkel

	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2013_2012 = ''0.99178371''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'')
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2013_2012 = ''1.017313949''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT = ''846''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2014_2013 = ''0.9518''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'')
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2014_2013 = ''1.0508''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT = ''846''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2015_2014 = ''0.993523577''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'')
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2015_2014 = ''1.009995876''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT = ''846''
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2016_2015 = ''0.986593281''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT IN (''841'', ''842'', ''843'', ''844'', ''845'')
	'
	;
	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||' 
	SET Y2016_2015 = ''1.02876703''
	WHERE SZEKTOR = ''AN114'' AND AGAZAT = ''846''
	'
	;
	

-- a 42-es ágazatot át kell másolni a 41-es ágazatba
	/*
FOR a IN 1..v_out_alszektor.COUNT LOOP 	
	
	FOR b IN 1..v_out_eszkcsp_c.COUNT LOOP 	

		IF  ''|| v_out_alszektor(a) ||'' LIKE 'S13%' THEN

			sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = ''S1311'' AND AGAZAT = ''41'' ';
			EXECUTE IMMEDIATE sql_statement INTO v;
			IF v = 0 THEN

							
				EXECUTE IMMEDIATE'
				INSERT INTO '|| v_out_table ||' (SZEKTOR, ALSZEKTOR, ESZKOZCSP, AGAZAT, Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015, Y2017_2016)
				SELECT '''|| v_out_szektor(1) ||''', '''|| v_out_alszektor(a) ||''', '''|| v_out_eszkcsp_c(b) ||''', ''41'', Y1996_1995, Y1997_1996, Y1998_1997, Y1999_1998, Y2000_1999, Y2001_2000, Y2002_2001, Y2003_2002, Y2004_2003, Y2005_2004, Y2006_2005, Y2007_2006, Y2008_2007, Y2009_2008, Y2010_2009, Y2011_2010, Y2012_2011, Y2013_2012, Y2014_2013, Y2015_2014, Y2016_2015, Y2017_2016
				FROM '|| v_out_table ||' 
				WHERE AGAZAT = ''42''
				AND ALSZEKTOR = '''|| v_out_alszektor(a) ||'''
				AND ESZKOZCSP = '''|| v_out_eszkcsp_c(b) ||'''
				'
				;
			END IF;
		
		END IF;	
				
	END LOOP;
	
END LOOP;
*/
END CFC_ARINDEX;

BEGIN

--v_out_szektor(1) := 'S13';

-- v_out_alszektor(1) := 'S14';

-- v_out_alszektor(1) := 'S1311';
-- v_out_alszektor(2) := 'S1313';
-- v_out_alszektor(3) := 'S1314'; -- TB
-- v_out_alszektor(4) := 'S11';
-- v_out_alszektor(5) := 'S12';
-- v_out_alszektor(6) := 'S14';
-- v_out_alszektor(7) := 'S15';


-- v_out_eszkcsp_c(1) := 'AN112';
-- v_out_eszkcsp_c(2) := 'AN1139t';
-- v_out_eszkcsp_c(3) := 'AN1131';
-- v_out_eszkcsp_c(4) := 'AN1139g';
-- v_out_eszkcsp_c(5) := 'AN1173a';
-- v_out_eszkcsp_c(6) := 'AN114';
-- v_out_eszkcsp_c(7) := 'AN114a';
-- v_out_eszkcsp_c(7) := 'AN1171';
-- v_out_eszkcsp_c(8) := 'AN1123';

-- S11-esek:
-- v_out_eszkcsp_c(1) := 'AN111';
-- v_out_eszkcsp_c(2) := 'AN112';
-- v_out_eszkcsp_c(3) := 'AN1131';
-- v_out_eszkcsp_c(4) := 'AN1139g';
-- v_out_eszkcsp_c(5) := 'AN1139t';
-- v_out_eszkcsp_c(6) := 'AN1173s';

-- S14-esek:
-- v_out_eszkcsp_c(1) := 'AN112';
-- v_out_eszkcsp_c(2) := 'AN1131';
-- v_out_eszkcsp_c(3) := 'AN1139g';
-- v_out_eszkcsp_c(4) := 'AN1139t';




END;