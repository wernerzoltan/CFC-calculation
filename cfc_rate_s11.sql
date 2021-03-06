/*
create or replace PACKAGE CFC_RATE_S11 AUTHID CURRENT_USER AS 
TYPE t_ar_list IS TABLE OF VARCHAR2(30 CHAR) INDEX BY PLS_INTEGER;
TYPE t_y_list IS TABLE OF VARCHAR2(30 CHAR) INDEX BY PLS_INTEGER;
procedure rate_calculator_s11(SZEKTOR VARCHAR2, ALSZEKTOR VARCHAR2, T03_TABLE_NAME_AR VARCHAR2, T08_TABLE_NAME_AR VARCHAR2, T03_TABLE_NAME_LT VARCHAR2, T08_TABLE_NAME_LT VARCHAR2,
T03_TABLE_NAME_INV2 VARCHAR2, T08_TABLE_NAME_INV2 VARCHAR2);

END CFC_RATE_S11;
-------
*/


create or replace PACKAGE BODY CFC_RATE_S11 AS 
v_ar_list t_ar_list; 
v_y_list t_y_list; 
v_out_schema VARCHAR2(10) := 'PKD19'; -- PKD séma -- mindenhova kell 


procedure rate_calculator_s11(SZEKTOR VARCHAR2, ALSZEKTOR VARCHAR2, T03_TABLE_NAME_AR VARCHAR2, T08_TABLE_NAME_AR VARCHAR2, T03_TABLE_NAME_LT VARCHAR2, T08_TABLE_NAME_LT VARCHAR2,
T03_TABLE_NAME_INV2 VARCHAR2, T08_TABLE_NAME_INV2 VARCHAR2) AS


TYPE t_eszkozcsp IS TABLE OF VARCHAR2(50); 
v_eszkozcsp t_eszkozcsp; 

TYPE t_agazat IS TABLE OF VARCHAR2(50); 
v_agazat t_agazat; 

TYPE t_rate IS TABLE OF c_imp_rate_calc%ROWTYPE; 
v_rate t_rate; 

TYPE t_rate_0 IS TABLE OF c_calc_temp%ROWTYPE; 
v_rate_0 t_rate_0; 

TYPE t_rate_d IS TABLE OF VARCHAR2(50); 
v_rate_d t_rate_d; 

rate_calc VARCHAR2(50) := 'c_imp_rate_calc';
rate_temp VARCHAR2(50) := 'c_calc_temp';
sql_statement VARCHAR2(300);
LT_INPUT VARCHAR2(5);

type t_collection IS TABLE OF NUMBER(10) INDEX BY BINARY_INTEGER;
l_cell t_collection;
l_idx NUMBER;

v NUMERIC;
z NUMERIC;

BEGIN

	sql_statement := 'SELECT * FROM PKD19.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' ORDER BY T08, T03';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate;

	sql_statement := 'SELECT DISTINCT T08 FROM PKD19.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' '; 
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate_d;
	
	sql_statement := 'SELECT DISTINCT ESZKOZCSP FROM PKD19.'|| T03_TABLE_NAME_LT ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' ';
	EXECUTE IMMEDIATE sql_statement  BULK COLLECT INTO v_eszkozcsp;

-- ÁRINDEX átalakító
SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME_AR ||'';
	
		IF z=0 THEN
			
			EXECUTE IMMEDIATE'
				CREATE TABLE PKD19.'|| T08_TABLE_NAME_AR ||'
				   ("SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR" VARCHAR2(26 BYTE), "ALSZEKTOR2" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"EGYEB" VARCHAR2(26 BYTE), 
					"Y1995_1999" NUMBER(19,16), 
					"Y1996_1999" NUMBER(19,16), 
					"Y1997_1999" NUMBER(19,16), 
					"Y1998_1999" NUMBER(19,16), 
					"Y1999_1999" NUMBER(19,16), 
					"Y2000_1999" NUMBER(19,16), 
					"Y2001_1999" NUMBER(19,16), 
					"Y2002_1999" NUMBER(19,16), 
					"Y2003_1999" NUMBER(19,16), 
					"Y2004_1999" NUMBER(19,16), 
					"Y2005_1999" NUMBER(19,16), 
					"Y2006_1999" NUMBER(19,16), 
					"Y2007_1999" NUMBER(19,16), 
					"Y2008_1999" NUMBER(19,16), 
					"Y2009_1999" NUMBER(19,16), 
					"Y2010_1999" NUMBER(19,16), 
					"Y2011_1999" NUMBER(19,16), 
					"Y2012_1999" NUMBER(19,16), 
					"Y2013_1999" NUMBER(19,16), 
					"Y2014_1999" NUMBER(19,16), 
					"Y2015_1999" NUMBER(19,16), 
					"Y2016_1999" NUMBER(19,16)
				   )';
      
		END IF;

PKD19.TRUNCATE_TABLE(''|| T08_TABLE_NAME_AR ||'');	

-- 1. lépés az új táblába tesszük a T08-as ágazatok listáját
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD19.'|| T08_TABLE_NAME_AR ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| SZEKTOR || ''', '''|| ALSZEKTOR ||''', '|| v_rate_d(c) ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
	
	END LOOP;
	
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';	
	
-- 2. lépés: arányszámolás

PKD19.TRUNCATE_TABLE(''|| rate_temp ||'');

	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP      	 
		
		EXECUTE IMMEDIATE'
		INSERT INTO PKD19.'|| rate_temp ||' (T08, T03)
		SELECT T08, T03 from PKD19.'|| rate_calc ||'
		WHERE T08 = '''|| v_rate_d(c) ||'''	AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
		'
		;
			
	END LOOP;

-- az összes éven végigmegyünk
	FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP

		FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP

			FOR b IN v_rate.FIRST..v_rate.LAST LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE PKD19.'|| rate_temp ||'
				SET ERTEK = 
				(SELECT 
					CASE c.'|| v_y_list(d) ||'
						WHEN 0 THEN a.'|| v_ar_list(d) ||' * b.ARANYSZAM
						ELSE a.'|| v_ar_list(d) ||' * b.ARANYSZAM * c.'|| v_y_list(d) ||'
					END AS ERTEK 
				FROM PKD19.'|| T03_TABLE_NAME_AR ||' a 
				INNER JOIN PKD19.'|| rate_calc ||' b
				ON a.AGAZAT = b.T03
				INNER JOIN PKD19.'|| T03_TABLE_NAME_INV2 ||' c
				ON a.AGAZAT = c.AGAZAT
				WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T03 = '''|| v_rate(b).T03 ||''' AND b.T08 = '''|| v_rate(b).T08 ||'''
				AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND a.AGAZAT = '''|| v_rate(b).T03 ||'''
				AND c.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND c.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND c.AGAZAT = '''|| v_rate(b).T03 ||''' 
				AND c.AGAZAT IS NOT NULL
				),
				
				ERTEK_INV2 = (SELECT 
					CASE c.'|| v_y_list(d) ||'
						WHEN 0 THEN 0
						ELSE b.ARANYSZAM * c.'|| v_y_list(d) ||'
					END AS ERTEK 
				FROM PKD19.'|| rate_calc ||' b
				INNER JOIN PKD19.'|| T03_TABLE_NAME_INV2 ||' c
				ON b.T03 = c.AGAZAT
				WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T03 = '''|| v_rate(b).T03 ||''' AND b.T08 = '''|| v_rate(b).T08 ||'''
				AND c.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND c.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND c.AGAZAT = '''|| v_rate(b).T03 ||'''
				)
				
				WHERE T08 = '''|| v_rate(b).T08 ||''' AND T03 = '''|| v_rate(b).T03 ||'''
				'
				;
				
				COMMIT;
				
			-- 3. lépés: a T08-as táblába beírjuk a SUM / súlyozott átlag értékeket	
		
				-- EXECUTE IMMEDIATE'
				-- UPDATE '|| T08_TABLE_NAME_AR ||'
				-- SET '|| v_ar_list(d) ||' = 
				-- (SELECT (SUM(NVL(a.ERTEK, 0)) / (SUM(b.ARANYSZAM) * (SELECT SUM('|| v_y_list(d) ||') FROM '|| T03_TABLE_NAME_INV2 ||' WHERE AGAZAT IN (SELECT T03 FROM '|| rate_calc ||' WHERE T08 = '''|| v_rate(b).T08 ||''' AND SZEKTOR = '''|| ALSZEKTOR ||''')))) 
				-- FROM '|| rate_temp ||' a 
				-- INNER JOIN '|| rate_calc ||' b
				-- ON a.T08 = b.T08
				-- WHERE a.T08 = '''|| v_rate(b).T08 ||''' AND b.ALSZEKTOR = '''|| ALSZEKTOR ||''')
				-- WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				-- '
				-- ;
							
			-- 3. lépés: a T08-as táblába beírjuk a SUM / (súlyozott átlag * INV2) értékeket
			
			
				-- EXECUTE IMMEDIATE'
				-- UPDATE '|| T08_TABLE_NAME_AR ||'
				-- SET '|| v_ar_list(d) ||' = 
				-- (SELECT (SELECT SUM(NVL(a.ERTEK, 0)) FROM '|| rate_temp ||' a WHERE a.T08 = '''|| v_rate(b).T08 ||''') / (SELECT (SELECT SUM(NVL(b.ARANYSZAM, 0)) FROM '|| rate_calc ||' b WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T08 = '''|| v_rate(b).T08 ||''') * 
				-- (SELECT 
					-- CASE SUM(NVL('|| v_y_list(d) ||', 0)) 
						-- WHEN 0 THEN 1 
						-- ELSE SUM('|| v_y_list(d) ||') 
					-- END AS a 
				-- FROM '|| T03_TABLE_NAME_INV2 ||' WHERE AGAZAT IN (SELECT T03 FROM '|| rate_calc ||' WHERE T08 = '''|| v_rate(b).T08 ||''' AND SZEKTOR = '''|| ALSZEKTOR ||''')) FROM dual) FROM dual)
				-- WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				-- '
				-- ;
				
				EXECUTE IMMEDIATE'
				UPDATE PKD19.'|| T08_TABLE_NAME_AR ||'
				SET '|| v_ar_list(d) ||' = 
				(SELECT (SELECT (SUM(NVL(a.ERTEK, 0))) FROM PKD19.'|| rate_temp ||' a WHERE a.T08 = '''|| v_rate(b).T08 ||''') / (SELECT CASE  (SUM(NVL(a.ERTEK_INV2, 0))) WHEN 0 THEN 1 ELSE (SUM(NVL(a.ERTEK_INV2, 0))) END AS a FROM PKD19.'|| rate_temp ||' a WHERE a.T08 = '''|| v_rate(b).T08 ||''') from dual) 
				WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				'
				;	
				
					
			END LOOP;
			
		END LOOP;
	
	END LOOP;
	

-- LT átalakító
SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME_LT ||'';
	
		IF z=0 THEN
			
				EXECUTE IMMEDIATE'
				CREATE TABLE PKD19.'|| T08_TABLE_NAME_LT ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR" VARCHAR2(26 BYTE), "ALSZEKTOR2" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"EGYEB" VARCHAR2(26 BYTE), "Y1780" NUMBER, "Y1781" NUMBER, "Y1782" NUMBER,"Y1783" NUMBER,
					"Y1784" NUMBER,
					"Y1785" NUMBER,
					"Y1786" NUMBER,
					"Y1787" NUMBER,
					"Y1788" NUMBER,
					"Y1789" NUMBER,
					"Y1790" NUMBER,
					"Y1791" NUMBER,
					"Y1792" NUMBER,
					"Y1793" NUMBER,
					"Y1794" NUMBER,
					"Y1795" NUMBER,
					"Y1796" NUMBER,
					"Y1797" NUMBER,
					"Y1798" NUMBER,
					"Y1799" NUMBER,
					"Y1800" NUMBER,
					"Y1801" NUMBER,
					"Y1802" NUMBER,
					"Y1803" NUMBER,
					"Y1804" NUMBER,
					"Y1805" NUMBER,
					"Y1806" NUMBER,
					"Y1807" NUMBER,
					"Y1808" NUMBER,
					"Y1809" NUMBER,
					"Y1810" NUMBER,
					"Y1811" NUMBER,
					"Y1812" NUMBER,
					"Y1813" NUMBER,
					"Y1814" NUMBER,
					"Y1815" NUMBER,
					"Y1816" NUMBER,
					"Y1817" NUMBER,
					"Y1818" NUMBER,
					"Y1819" NUMBER,
					"Y1820" NUMBER,
					"Y1821" NUMBER,
					"Y1822" NUMBER,
					"Y1823" NUMBER,
					"Y1824" NUMBER,
					"Y1825" NUMBER,
					"Y1826" NUMBER,
					"Y1827" NUMBER,
					"Y1828" NUMBER,
					"Y1829" NUMBER,
					"Y1830" NUMBER,
					"Y1831" NUMBER,
					"Y1832" NUMBER,
					"Y1833" NUMBER,
					"Y1834" NUMBER,
					"Y1835" NUMBER,
					"Y1836" NUMBER,
					"Y1837" NUMBER,
					"Y1838" NUMBER,
					"Y1839" NUMBER,
					"Y1840" NUMBER,
					"Y1841" NUMBER,
					"Y1842" NUMBER,
					"Y1843" NUMBER,
					"Y1844" NUMBER,
					"Y1845" NUMBER,
					"Y1846" NUMBER,
					"Y1847" NUMBER,
					"Y1848" NUMBER,
					"Y1849" NUMBER,
					"Y1850" NUMBER,
					"Y1851" NUMBER,
					"Y1852" NUMBER,
					"Y1853" NUMBER,
					"Y1854" NUMBER,
					"Y1855" NUMBER,
					"Y1856" NUMBER,
					"Y1857" NUMBER,
					"Y1858" NUMBER,
					"Y1859" NUMBER,
					"Y1860" NUMBER,
					"Y1861" NUMBER,
					"Y1862" NUMBER,
					"Y1863" NUMBER,
					"Y1864" NUMBER,
					"Y1865" NUMBER,
					"Y1866" NUMBER,
					"Y1867" NUMBER,
					"Y1868" NUMBER,
					"Y1869" NUMBER,
					"Y1870" NUMBER,
					"Y1871" NUMBER,
					"Y1872" NUMBER,
					"Y1873" NUMBER,
					"Y1874" NUMBER,
					"Y1875" NUMBER,
					"Y1876" NUMBER,
					"Y1877" NUMBER,
					"Y1878" NUMBER,
					"Y1879" NUMBER,
					"Y1880" NUMBER,
					"Y1881" NUMBER,
					"Y1882" NUMBER,
					"Y1883" NUMBER,
					"Y1884" NUMBER,
					"Y1885" NUMBER,
					"Y1886" NUMBER,
					"Y1887" NUMBER,
					"Y1888" NUMBER,
					"Y1889" NUMBER,
					"Y1890" NUMBER,
					"Y1891" NUMBER,
					"Y1892" NUMBER,
					"Y1893" NUMBER,
					"Y1894" NUMBER,
					"Y1895" NUMBER,
					"Y1896" NUMBER,
					"Y1897" NUMBER,
					"Y1898" NUMBER,
					"Y1899" NUMBER,
					"Y1900" NUMBER,
					"Y1901" NUMBER,
					"Y1902" NUMBER, 
					"Y1903" NUMBER,
					"Y1904" NUMBER,
					"Y1905" NUMBER,
					"Y1906" NUMBER,
					"Y1907" NUMBER,
					"Y1908" NUMBER,
					"Y1909" NUMBER,
					"Y1910" NUMBER,
					"Y1911" NUMBER,
					"Y1912" NUMBER,
					"Y1913" NUMBER,
					"Y1914" NUMBER,
					"Y1915" NUMBER,
					"Y1916" NUMBER,
					"Y1917" NUMBER,
					"Y1918" NUMBER,
					"Y1919" NUMBER,
					"Y1920" NUMBER,
					"Y1921" NUMBER,
					"Y1922" NUMBER,
					"Y1923" NUMBER,
					"Y1924" NUMBER,
					"Y1925" NUMBER,
					"Y1926" NUMBER,
					"Y1927" NUMBER,
					"Y1928" NUMBER,
					"Y1929" NUMBER,
					"Y1930" NUMBER,
					"Y1931" NUMBER,
					"Y1932" NUMBER,
					"Y1933" NUMBER,
					"Y1934" NUMBER,
					"Y1935" NUMBER,
					"Y1936" NUMBER,
					"Y1937" NUMBER,
					"Y1938" NUMBER,
					"Y1939" NUMBER,
					"Y1940" NUMBER,
					"Y1941" NUMBER,
					"Y1942" NUMBER,
					"Y1943" NUMBER,
					"Y1944" NUMBER,
					"Y1945" NUMBER,
					"Y1946" NUMBER,
					"Y1947" NUMBER,
					"Y1948" NUMBER,
					"Y1949" NUMBER,
					"Y1950" NUMBER,
					"Y1951" NUMBER,
					"Y1952" NUMBER,
					"Y1953" NUMBER,
					"Y1954" NUMBER,
					"Y1955" NUMBER,
					"Y1956" NUMBER,
					"Y1957" NUMBER,
					"Y1958" NUMBER,
					"Y1959" NUMBER,
					"Y1960" NUMBER,
					"Y1961" NUMBER,
					"Y1962" NUMBER,
					"Y1963" NUMBER,
					"Y1964" NUMBER,
					"Y1965" NUMBER,
					"Y1966" NUMBER,
					"Y1967" NUMBER,
					"Y1968" NUMBER,
					"Y1969" NUMBER,
					"Y1970" NUMBER,
					"Y1971" NUMBER,
					"Y1972" NUMBER,
					"Y1973" NUMBER,
					"Y1974" NUMBER, 
					"Y1975" NUMBER,
					"Y1976" NUMBER,
					"Y1977" NUMBER, 
					"Y1978" NUMBER, 
					"Y1979" NUMBER, 
					"Y1980" NUMBER, 
					"Y1981" NUMBER, 
					"Y1982" NUMBER,
					"Y1983" NUMBER, 
					"Y1984" NUMBER, 
					"Y1985" NUMBER, 
					"Y1986" NUMBER, 
					"Y1987" NUMBER,
					"Y1988" NUMBER,
					"Y1989" NUMBER, 
					"Y1990" NUMBER,
					"Y1991" NUMBER,
					"Y1992" NUMBER,
					"Y1993" NUMBER,
					"Y1994" NUMBER,
					"Y1995" NUMBER, 
					"Y1996" NUMBER,
					"Y1997" NUMBER,
					"Y1998" NUMBER, 
					"Y1999" NUMBER,
					"Y2000" NUMBER,
					"Y2001" NUMBER,
					"Y2002" NUMBER, 
					"Y2003" NUMBER,
					"Y2004" NUMBER, 
					"Y2005" NUMBER,
					"Y2006" NUMBER, 
					"Y2007" NUMBER, 
					"Y2008" NUMBER,
					"Y2009" NUMBER, 
					"Y2010" NUMBER,
					"Y2011" NUMBER,
					"Y2012" NUMBER,
					"Y2013" NUMBER, 
					"Y2014" NUMBER, 
					"Y2015" NUMBER, 
					"Y2016" NUMBER
				   )';
      
		END IF;

PKD19.TRUNCATE_TABLE(''|| T08_TABLE_NAME_LT ||'');	

-- 1. lépés: T03-as táblában az 1891-es év adatait átmásoljuk 1890-be

	sql_statement := 'SELECT DISTINCT AGAZAT FROM '|| T03_TABLE_NAME_LT ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||'''  ';
	EXECUTE IMMEDIATE sql_statement  BULK COLLECT INTO v_agazat;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR b IN v_agazat.FIRST..v_agazat.LAST LOOP
	
			EXECUTE IMMEDIATE'
			UPDATE PKD19.'|| T03_TABLE_NAME_LT ||' 
			SET Y1890 = (SELECT Y1891 FROM PKD19.'|| T03_TABLE_NAME_LT ||' 
			WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''')
			WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' 
			
			'
			;
	
		END LOOP;
	
	END LOOP;


-- 2. lépés az új táblába tesszük a T08-as ágazatok listáját
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD19.'|| T08_TABLE_NAME_LT ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| SZEKTOR || ''', '''|| ALSZEKTOR ||''', '|| v_rate_d(c) ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
	
	END LOOP;
	
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';	
	
-- 3. lépés: arányszámolás

PKD19.TRUNCATE_TABLE(''|| rate_temp ||'');

	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP      	 
		
		EXECUTE IMMEDIATE'
		INSERT INTO PKD19.'|| rate_temp ||' (T08, T03)
		SELECT T08, T03 from PKD19.'|| rate_calc ||'
		WHERE T08 = '''|| v_rate_d(c) ||'''	AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
		'
		;
			
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1890..2015 LOOP --1890
	l_cell(m) := m;
END LOOP;

l_idx := l_cell.FIRST;
	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP

		FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
			FOR b IN v_rate.FIRST..v_rate.LAST LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE PKD19.'|| rate_temp ||'
				SET ERTEK = 
				(SELECT 
					CASE c.Y'|| l_cell(d) ||'
						WHEN 0 THEN a.Y'|| l_cell(d) ||' * b.ARANYSZAM
						ELSE a.Y'|| l_cell(d) ||' * b.ARANYSZAM * c.Y'|| l_cell(d) ||'
					END AS ERTEK 
				FROM PKD19.'|| T03_TABLE_NAME_LT ||' a 
				INNER JOIN PKD19.'|| rate_calc ||' b
				ON a.AGAZAT = b.T03
				INNER JOIN PKD19.'|| T03_TABLE_NAME_INV2 ||' c
				ON a.AGAZAT = c.AGAZAT
				WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T03 = '''|| v_rate(b).T03 ||''' AND b.T08 = '''|| v_rate(b).T08 ||'''
				AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND a.AGAZAT = '''|| v_rate(b).T03 ||'''
				AND c.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND c.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND c.AGAZAT = '''|| v_rate(b).T03 ||'''
				),
				
				ERTEK_INV2 = (SELECT 
					CASE c.Y'|| l_cell(d) ||'
						WHEN 0 THEN 0
						ELSE b.ARANYSZAM * c.Y'|| l_cell(d) ||'
					END AS ERTEK 
				FROM PKD19.'|| rate_calc ||' b
				INNER JOIN PKD19.'|| T03_TABLE_NAME_INV2 ||' c
				ON b.T03 = c.AGAZAT
				WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T03 = '''|| v_rate(b).T03 ||''' AND b.T08 = '''|| v_rate(b).T08 ||'''
				AND c.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND c.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND c.AGAZAT = '''|| v_rate(b).T03 ||'''
				)
				
				WHERE T08 = '''|| v_rate(b).T08 ||''' AND T03 = '''|| v_rate(b).T03 ||'''
				'
				;
		

-- a T08-as táblába beírjuk a SUM / súlyozott átlag értékeket	
		
				-- EXECUTE IMMEDIATE'
				-- UPDATE '|| T08_TABLE_NAME_LT ||'
				-- SET Y'|| l_cell(d) ||' = 
				-- (SELECT ROUND(SUM(NVL(a.ERTEK, 0)) / SUM(NVL(b.ARANYSZAM, 0)) * SUM(INV2))) ----!!!!!
				-- FROM '|| rate_temp ||' a 
				-- INNER JOIN '|| rate_calc ||' b
				-- ON a.T08 = b.T08
				-- WHERE a.T08 = '''|| v_rate(b).T08 ||''' AND b.ALSZEKTOR = '''|| ALSZEKTOR ||''')
				-- WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				-- '
				-- ;
				
			-- l_idx := l_cell.NEXT(l_idx);				

			-- 3. lépés: a T08-as táblába beírjuk a SUM(ERTEK) / SUM(ERTEK_INV2) értékeket	
				-- EXECUTE IMMEDIATE'
				-- UPDATE '|| T08_TABLE_NAME_LT ||'
				-- SET Y'|| l_cell(d) ||' = 
				-- (SELECT ROUND((SELECT SUM(NVL(a.ERTEK, 0)) FROM '|| rate_temp ||' a WHERE a.T08 = '''|| v_rate(b).T08 ||''') / (SELECT (SELECT SUM(NVL(b.ARANYSZAM, 0)) FROM '|| rate_calc ||' b WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T08 = '''|| v_rate(b).T08 ||''') * 
				-- (SELECT 
					-- CASE SUM(NVL(Y'|| l_cell(d) ||', 0)) 
						-- WHEN 0 THEN 1 
						-- ELSE SUM(Y'|| l_cell(d) ||') 
					-- END AS a 
				-- FROM '|| T03_TABLE_NAME_INV2 ||' WHERE AGAZAT IN (SELECT T03 FROM '|| rate_calc ||' WHERE T08 = '''|| v_rate(b).T08 ||''' AND SZEKTOR = '''|| ALSZEKTOR ||''')) FROM dual)) FROM dual)
				-- WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				-- '
				-- ;		

				-- 3. lépés: a T08-as táblába beírjuk a SUM(ERTEK) / SUM(ERTEK_INV2) értékeket	
				EXECUTE IMMEDIATE'
				UPDATE PKD19.'|| T08_TABLE_NAME_LT ||'
				SET Y'|| l_cell(d) ||' = 
				(SELECT ROUND((SELECT (SELECT (SUM(NVL(a.ERTEK, 0))) FROM PKD19.'|| rate_temp ||' a WHERE a.T08 = '''|| v_rate(b).T08 ||''') / (SELECT CASE  (SUM(NVL(a.ERTEK_INV2, 0))) WHEN 0 THEN 1 ELSE (SUM(NVL(a.ERTEK_INV2, 0))) END AS a FROM PKD19.'|| rate_temp ||' a WHERE a.T08 = '''|| v_rate(b).T08 ||''') from dual)) FROM dual)
				WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				'
				;
				
				
			l_idx := l_cell.NEXT(l_idx);	
			
			END LOOP;
				
		END LOOP;
		
	END LOOP;
	

-- INV2 átalakító
SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME_INV2 ||'';
	
		IF z=0 THEN
			
				EXECUTE IMMEDIATE'
				CREATE TABLE PKD19.'|| T08_TABLE_NAME_INV2 ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR" VARCHAR2(26 BYTE), "ALSZEKTOR2" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"EGYEB" VARCHAR2(26 BYTE), "Y1780" NUMBER,"Y1781" NUMBER,"Y1782" NUMBER,"Y1783" NUMBER,
					"Y1784" NUMBER,
					"Y1785" NUMBER,
					"Y1786" NUMBER,
					"Y1787" NUMBER,
					"Y1788" NUMBER,
					"Y1789" NUMBER,
					"Y1790" NUMBER,
					"Y1791" NUMBER,
					"Y1792" NUMBER,
					"Y1793" NUMBER,
					"Y1794" NUMBER,
					"Y1795" NUMBER,
					"Y1796" NUMBER,
					"Y1797" NUMBER,
					"Y1798" NUMBER,
					"Y1799" NUMBER,
					"Y1800" NUMBER,
					"Y1801" NUMBER,
					"Y1802" NUMBER,
					"Y1803" NUMBER,
					"Y1804" NUMBER,
					"Y1805" NUMBER,
					"Y1806" NUMBER,
					"Y1807" NUMBER,
					"Y1808" NUMBER,
					"Y1809" NUMBER,
					"Y1810" NUMBER,
					"Y1811" NUMBER,
					"Y1812" NUMBER,
					"Y1813" NUMBER,
					"Y1814" NUMBER,
					"Y1815" NUMBER,
					"Y1816" NUMBER,
					"Y1817" NUMBER,
					"Y1818" NUMBER,
					"Y1819" NUMBER,
					"Y1820" NUMBER,
					"Y1821" NUMBER,
					"Y1822" NUMBER,
					"Y1823" NUMBER,
					"Y1824" NUMBER,
					"Y1825" NUMBER,
					"Y1826" NUMBER,
					"Y1827" NUMBER,
					"Y1828" NUMBER,
					"Y1829" NUMBER,
					"Y1830" NUMBER,
					"Y1831" NUMBER,
					"Y1832" NUMBER,
					"Y1833" NUMBER,
					"Y1834" NUMBER,
					"Y1835" NUMBER,
					"Y1836" NUMBER,
					"Y1837" NUMBER,
					"Y1838" NUMBER,
					"Y1839" NUMBER,
					"Y1840" NUMBER,
					"Y1841" NUMBER,
					"Y1842" NUMBER,
					"Y1843" NUMBER,
					"Y1844" NUMBER,
					"Y1845" NUMBER,
					"Y1846" NUMBER,
					"Y1847" NUMBER,
					"Y1848" NUMBER,
					"Y1849" NUMBER,
					"Y1850" NUMBER,
					"Y1851" NUMBER,
					"Y1852" NUMBER,
					"Y1853" NUMBER,
					"Y1854" NUMBER,
					"Y1855" NUMBER,
					"Y1856" NUMBER,
					"Y1857" NUMBER,
					"Y1858" NUMBER,
					"Y1859" NUMBER,
					"Y1860" NUMBER,
					"Y1861" NUMBER,
					"Y1862" NUMBER,
					"Y1863" NUMBER,
					"Y1864" NUMBER,
					"Y1865" NUMBER,
					"Y1866" NUMBER,
					"Y1867" NUMBER,
					"Y1868" NUMBER,
					"Y1869" NUMBER,
					"Y1870" NUMBER,
					"Y1871" NUMBER,
					"Y1872" NUMBER,
					"Y1873" NUMBER,
					"Y1874" NUMBER,
					"Y1875" NUMBER,
					"Y1876" NUMBER,
					"Y1877" NUMBER,
					"Y1878" NUMBER,
					"Y1879" NUMBER,
					"Y1880" NUMBER,
					"Y1881" NUMBER,
					"Y1882" NUMBER,
					"Y1883" NUMBER,
					"Y1884" NUMBER,
					"Y1885" NUMBER,
					"Y1886" NUMBER,
					"Y1887" NUMBER,
					"Y1888" NUMBER,
					"Y1889" NUMBER,
					"Y1890" NUMBER,
					"Y1891" NUMBER,
					"Y1892" NUMBER,
					"Y1893" NUMBER,
					"Y1894" NUMBER,
					"Y1895" NUMBER,
					"Y1896" NUMBER,
					"Y1897" NUMBER,
					"Y1898" NUMBER,
					"Y1899" NUMBER,
					"Y1900" NUMBER,
					"Y1901" NUMBER,
					"Y1902" NUMBER, 
					"Y1903" NUMBER,
					"Y1904" NUMBER,
					"Y1905" NUMBER,
					"Y1906" NUMBER,
					"Y1907" NUMBER,
					"Y1908" NUMBER,
					"Y1909" NUMBER,
					"Y1910" NUMBER,
					"Y1911" NUMBER,
					"Y1912" NUMBER,
					"Y1913" NUMBER,
					"Y1914" NUMBER,
					"Y1915" NUMBER,
					"Y1916" NUMBER,
					"Y1917" NUMBER,
					"Y1918" NUMBER,
					"Y1919" NUMBER,
					"Y1920" NUMBER,
					"Y1921" NUMBER,
					"Y1922" NUMBER,
					"Y1923" NUMBER,
					"Y1924" NUMBER,
					"Y1925" NUMBER,
					"Y1926" NUMBER,
					"Y1927" NUMBER,
					"Y1928" NUMBER,
					"Y1929" NUMBER,
					"Y1930" NUMBER,
					"Y1931" NUMBER,
					"Y1932" NUMBER,
					"Y1933" NUMBER,
					"Y1934" NUMBER,
					"Y1935" NUMBER,
					"Y1936" NUMBER,
					"Y1937" NUMBER,
					"Y1938" NUMBER,
					"Y1939" NUMBER,
					"Y1940" NUMBER,
					"Y1941" NUMBER,
					"Y1942" NUMBER,
					"Y1943" NUMBER,
					"Y1944" NUMBER,
					"Y1945" NUMBER,
					"Y1946" NUMBER,
					"Y1947" NUMBER,
					"Y1948" NUMBER,
					"Y1949" NUMBER,
					"Y1950" NUMBER,
					"Y1951" NUMBER,
					"Y1952" NUMBER,
					"Y1953" NUMBER,
					"Y1954" NUMBER,
					"Y1955" NUMBER,
					"Y1956" NUMBER,
					"Y1957" NUMBER,
					"Y1958" NUMBER,
					"Y1959" NUMBER,
					"Y1960" NUMBER,
					"Y1961" NUMBER,
					"Y1962" NUMBER,
					"Y1963" NUMBER,
					"Y1964" NUMBER,
					"Y1965" NUMBER,
					"Y1966" NUMBER,
					"Y1967" NUMBER,
					"Y1968" NUMBER,
					"Y1969" NUMBER,
					"Y1970" NUMBER,
					"Y1971" NUMBER,
					"Y1972" NUMBER,
					"Y1973" NUMBER,
					"Y1974" NUMBER, 
					"Y1975" NUMBER,
					"Y1976" NUMBER,
					"Y1977" NUMBER, 
					"Y1978" NUMBER, 
					"Y1979" NUMBER, 
					"Y1980" NUMBER, 
					"Y1981" NUMBER, 
					"Y1982" NUMBER,
					"Y1983" NUMBER, 
					"Y1984" NUMBER, 
					"Y1985" NUMBER, 
					"Y1986" NUMBER, 
					"Y1987" NUMBER,
					"Y1988" NUMBER,
					"Y1989" NUMBER, 
					"Y1990" NUMBER,
					"Y1991" NUMBER,
					"Y1992" NUMBER,
					"Y1993" NUMBER,
					"Y1994" NUMBER,
					"Y1995" NUMBER, 
					"Y1996" NUMBER,
					"Y1997" NUMBER,
					"Y1998" NUMBER, 
					"Y1999" NUMBER,
					"Y2000" NUMBER,
					"Y2001" NUMBER,
					"Y2002" NUMBER, 
					"Y2003" NUMBER,
					"Y2004" NUMBER, 
					"Y2005" NUMBER,
					"Y2006" NUMBER, 
					"Y2007" NUMBER, 
					"Y2008" NUMBER,
					"Y2009" NUMBER, 
					"Y2010" NUMBER,
					"Y2011" NUMBER,
					"Y2012" NUMBER,
					"Y2013" NUMBER, 
					"Y2014" NUMBER, 
					"Y2015" NUMBER,
					"Y2016" NUMBER
				   )';
      
		END IF;

PKD19.TRUNCATE_TABLE(''|| T08_TABLE_NAME_INV2 ||'');	

-- 1. lépés az új táblába tesszük a T08-as ágazatok listáját
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD19.'|| T08_TABLE_NAME_INV2 ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| SZEKTOR || ''', '''|| ALSZEKTOR ||''', '|| v_rate_d(c) ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
	
	END LOOP;
	
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE' UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';	
	
-- 2. lépés: arányszámolás

PKD19.TRUNCATE_TABLE(''|| rate_temp ||'');

	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP      	 
		
		EXECUTE IMMEDIATE'
		INSERT INTO PKD19.'|| rate_temp ||' (T08, T03)
		SELECT T08, T03 from PKD19.'|| rate_calc ||'
		WHERE T08 = '''|| v_rate_d(c) ||'''	AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
		'
		;
			
	END LOOP;

-- az összes éven végigmegyünk

FOR m IN 1890..2015 LOOP 
	l_cell(m) := m;
END LOOP;

l_idx := l_cell.FIRST;
	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP

		FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
			FOR b IN v_rate.FIRST..v_rate.LAST LOOP
	
				EXECUTE IMMEDIATE'
				UPDATE PKD19.'|| rate_temp ||'
				SET ERTEK = 
				(SELECT a.Y'|| l_cell(d) ||' * b.ARANYSZAM
				FROM PKD19.'|| T03_TABLE_NAME_INV2 ||' a 
				INNER JOIN PKD19.'|| rate_calc ||' b
				ON a.AGAZAT = b.T03
				WHERE b.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.T03 = '''|| v_rate(b).T03 ||''' AND b.T08 = '''|| v_rate(b).T08 ||'''
				AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND a.AGAZAT = '''|| v_rate(b).T03 ||'''
				)
				WHERE T08 = '''|| v_rate(b).T08 ||''' AND T03 = '''|| v_rate(b).T03 ||'''
				'
				;


-- a T08-as táblába beírjuk az egyes ágazatok SUM értékeit
		
				EXECUTE IMMEDIATE'
				UPDATE PKD19.'|| T08_TABLE_NAME_INV2 ||'
				SET Y'|| l_cell(d) ||' = 
				(SELECT SUM(NVL(a.ERTEK, 0))
				FROM PKD19.'|| rate_temp ||' a 
				WHERE a.T08 = '''|| v_rate(b).T08 ||''')
				WHERE AGAZAT = '''|| v_rate(b).T08 ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				'
				;				
				
			l_idx := l_cell.NEXT(l_idx);				
				
			END LOOP;
				
		END LOOP;
		
	END LOOP;

END rate_calculator_s11;

BEGIN

v_ar_list(1) := 'Y1995_1999' ; 
v_ar_list(2) :=	'Y1996_1999' ; 
v_ar_list(3) :=	'Y1997_1999' ; 
v_ar_list(4) :=	'Y1998_1999' ; 
v_ar_list(5) :=	'Y1999_1999' ; 
v_ar_list(6) :=	'Y2000_1999' ; 
v_ar_list(7) :=	'Y2001_1999' ; 
v_ar_list(8) :=	'Y2002_1999' ; 
v_ar_list(9) :=	'Y2003_1999' ; 
v_ar_list(10) :=	'Y2004_1999' ; 
v_ar_list(11) :=	'Y2005_1999' ; 
v_ar_list(12) :=	'Y2006_1999' ; 
v_ar_list(13) :=	'Y2007_1999' ; 
v_ar_list(14) :=	'Y2008_1999' ; 
v_ar_list(15) :=	'Y2009_1999' ; 
v_ar_list(16) :=	'Y2010_1999' ; 
v_ar_list(17) :=	'Y2011_1999' ; 
v_ar_list(18) :=	'Y2012_1999' ; 
v_ar_list(19) :=	'Y2013_1999' ; 
v_ar_list(20) :=	'Y2014_1999' ; 
v_ar_list(21) :=	'Y2015_1999' ; 
v_ar_list(22) :=	'Y2016_1999' ; 

v_y_list(1) := 'Y1995' ; 
v_y_list(2) :=	'Y1996' ; 
v_y_list(3) :=	'Y1997' ; 
v_y_list(4) :=	'Y1998' ; 
v_y_list(5) :=	'Y1999' ; 
v_y_list(6) :=	'Y2000' ; 
v_y_list(7) :=	'Y2001' ; 
v_y_list(8) :=	'Y2002' ; 
v_y_list(9) :=	'Y2003' ; 
v_y_list(10) :=	'Y2004' ; 
v_y_list(11) :=	'Y2005' ; 
v_y_list(12) :=	'Y2006' ; 
v_y_list(13) :=	'Y2007' ; 
v_y_list(14) :=	'Y2008' ; 
v_y_list(15) :=	'Y2009' ; 
v_y_list(16) :=	'Y2010' ; 
v_y_list(17) :=	'Y2011' ; 
v_y_list(18) :=	'Y2012' ; 
v_y_list(19) :=	'Y2013' ; 
v_y_list(20) :=	'Y2014' ; 
v_y_list(21) :=	'Y2015' ; 
v_y_list(22) :=	'Y2016' ; 

END;