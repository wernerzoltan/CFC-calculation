/*

create or replace PACKAGE CFC_RATE AUTHID CURRENT_USER AS 
TYPE t_ar_list IS TABLE OF VARCHAR2(30 CHAR) INDEX BY PLS_INTEGER;
procedure rate_calculator(SZEKTOR VARCHAR2, ALSZEKTOR VARCHAR2, T03_TABLE_NAME VARCHAR2, T08_TABLE_NAME VARCHAR2, T03_TABLE_NAME_LT VARCHAR2, 
T08_TABLE_NAME_LT VARCHAR2, T03_TABLE_NAME_AR VARCHAR2, T08_TABLE_NAME_AR VARCHAR2, T08_1 VARCHAR2, T08_2 VARCHAR2);


END CFC_RATE;



-------
*/
/*
DECLARE
  SZEKTOR VARCHAR2(200);
  ALSZEKTOR VARCHAR2(200);
  T03_TABLE_NAME VARCHAR2(200);
  T08_TABLE_NAME VARCHAR2(200);
  T03_TABLE_NAME_LT VARCHAR2(200);
  T08_TABLE_NAME_LT VARCHAR2(200);
  T03_TABLE_NAME_AR VARCHAR2(200);
  T08_TABLE_NAME_AR VARCHAR2(200);
  T08_1 VARCHAR2(200);
  T08_2 VARCHAR2(200);

BEGIN
  SZEKTOR := 'S12';
  ALSZEKTOR := 'S12';
  T03_TABLE_NAME := 'C_IMP_INV2_S11_T03';
  T08_TABLE_NAME := 'C_IMP_INV2_S12_T08';
  T03_TABLE_NAME_LT := 'C_IMP_LT_S11_T03';
  T08_TABLE_NAME_LT := 'C_IMP_LT_S12_T08';
  T03_TABLE_NAME_AR := 'C_IMP_AR_BAZIS_T03';
  T08_TABLE_NAME_AR := 'C_IMP_AR_BAZIS_T08_S12';
  T08_1 := NULL;
  T08_2 := NULL;


  CFC_RATE.RATE_CALCULATOR(
    SZEKTOR => SZEKTOR,
    ALSZEKTOR => ALSZEKTOR,
    T03_TABLE_NAME => T03_TABLE_NAME,
    T08_TABLE_NAME => T08_TABLE_NAME,
    T03_TABLE_NAME_LT => T03_TABLE_NAME_LT,
    T08_TABLE_NAME_LT => T08_TABLE_NAME_LT,
    T03_TABLE_NAME_AR => T03_TABLE_NAME_AR,
    T08_TABLE_NAME_AR => T08_TABLE_NAME_AR,
    T08_1 => T08_1
	T08_2 => T08_2

  );
--rollback; 
END;

*/

create or replace PACKAGE BODY CFC_RATE AS 
v_ar_list t_ar_list; 
v_out_schema VARCHAR2(10) := 'PKD'; -- PKD séma -- mindenhova kell 


procedure rate_calculator(SZEKTOR VARCHAR2, ALSZEKTOR VARCHAR2, T03_TABLE_NAME VARCHAR2, T08_TABLE_NAME VARCHAR2, T03_TABLE_NAME_LT VARCHAR2, 
T08_TABLE_NAME_LT VARCHAR2, T03_TABLE_NAME_AR VARCHAR2, T08_TABLE_NAME_AR VARCHAR2, T08_1 VARCHAR2, T08_2 VARCHAR2) AS

TYPE t_eszkozcsp IS TABLE OF VARCHAR2(50); 
v_eszkozcsp t_eszkozcsp; 

TYPE t_rate IS TABLE OF c_imp_rate_calc%ROWTYPE; 
v_rate t_rate; 

TYPE t_rate_0 IS TABLE OF c_imp_rate_calc%ROWTYPE; 
v_rate_0 t_rate_0; 

TYPE t_rate_d IS TABLE OF c_imp_rate_calc%ROWTYPE; 
v_rate_d t_rate_d; 

rate_calc VARCHAR2(50) := 'C_IMP_RATE_CALC';
sql_statement VARCHAR2(300);
LT_INPUT VARCHAR2(5);
LT_INPUT_2 VARCHAR2(5);

type t_collection IS TABLE OF NUMBER(10) INDEX BY BINARY_INTEGER;
l_cell t_collection;
l_idx NUMBER;

v NUMERIC;
z NUMERIC;

BEGIN

-- S1311 és S1313 esetén a 841-es T08-as ágazatba a 751-es T03-as ágazat értékei kerülnek LITFETIME és ÁRINDEX esetében
IF ''|| SZEKTOR ||'' = 'S13' THEN

	LT_INPUT := '751';

END IF;


-- S1313 esetén a 81-es T08-as ágazatba a 05-ös T03-as ágazat értékei kerülnek LITFETIME és ÁRINDEX esetében
IF ''|| ALSZEKTOR ||'' = 'S1313' THEN

	LT_INPUT_2 := '05';

END IF;




SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME ||'';
	
		IF v=0 THEN
			
				EXECUTE IMMEDIATE'
				CREATE TABLE PKD.'|| T08_TABLE_NAME ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR" VARCHAR2(26 BYTE),  "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"EGYEB" VARCHAR2(26 BYTE), "Y1780" NUMBER(18,11), "Y1781" NUMBER(19,12), "Y1782" NUMBER(18,11), "Y1783" NUMBER(18,11), 
					"Y1784" NUMBER(18,11), 
					"Y1785" NUMBER(18,11), 
					"Y1786" NUMBER(19,12), 
					"Y1787" NUMBER(19,12), 
					"Y1788" NUMBER(19,12), 
					"Y1789" NUMBER(18,12), 
					"Y1790" NUMBER(17,11), 
					"Y1791" NUMBER(17,11), 
					"Y1792" NUMBER(18,12), 
					"Y1793" NUMBER(18,12), 
					"Y1794" NUMBER(18,12), 
					"Y1795" NUMBER(18,12), 
					"Y1796" NUMBER(19,13), 
					"Y1797" NUMBER(19,13), 
					"Y1798" NUMBER(18,12), 
					"Y1799" NUMBER(19,13), 
					"Y1800" NUMBER(19,13), 
					"Y1801" NUMBER(19,13), 
					"Y1802" NUMBER(19,13), 
					"Y1803" NUMBER(18,12), 
					"Y1804" NUMBER(19,13), 
					"Y1805" NUMBER(19,13), 
					"Y1806" NUMBER(19,13), 
					"Y1807" NUMBER(19,13), 
					"Y1808" NUMBER(19,13), 
					"Y1809" NUMBER(19,13), 
					"Y1810" NUMBER(19,13), 
					"Y1811" NUMBER(18,12), 
					"Y1812" NUMBER(19,13), 
					"Y1813" NUMBER(19,13), 
					"Y1814" NUMBER(19,13), 
					"Y1815" NUMBER(18,13), 
					"Y1816" NUMBER(18,13), 
					"Y1817" NUMBER(18,13), 
					"Y1818" NUMBER(18,13), 
					"Y1819" NUMBER(18,13), 
					"Y1820" NUMBER(18,13), 
					"Y1821" NUMBER(18,13), 
					"Y1822" NUMBER(18,13), 
					"Y1823" NUMBER(18,13), 
					"Y1824" NUMBER(18,13), 
					"Y1825" NUMBER(18,13), 
					"Y1826" NUMBER(18,13), 
					"Y1827" NUMBER(18,13), 
					"Y1828" NUMBER(18,13), 
					"Y1829" NUMBER(17,12), 
					"Y1830" NUMBER(19,14), 
					"Y1831" NUMBER(19,14), 
					"Y1832" NUMBER(18,13), 
					"Y1833" NUMBER(19,14), 
					"Y1834" NUMBER(18,13), 
					"Y1835" NUMBER(18,13), 
					"Y1836" NUMBER(18,13), 
					"Y1837" NUMBER(18,13), 
					"Y1838" NUMBER(18,13), 
					"Y1839" NUMBER(18,13), 
					"Y1840" NUMBER(18,13), 
					"Y1841" NUMBER(18,13), 
					"Y1842" NUMBER(19,14), 
					"Y1843" NUMBER(18,13), 
					"Y1844" NUMBER(18,13), 
					"Y1845" NUMBER(17,12), 
					"Y1846" NUMBER(19,14), 
					"Y1847" NUMBER(19,14), 
					"Y1848" NUMBER(18,13), 
					"Y1849" NUMBER(18,13), 
					"Y1850" NUMBER(19,14), 
					"Y1851" NUMBER(19,14), 
					"Y1852" NUMBER(18,13), 
					"Y1853" NUMBER(18,13), 
					"Y1854" NUMBER(19,14), 
					"Y1855" NUMBER(18,13), 
					"Y1856" NUMBER(18,13), 
					"Y1857" NUMBER(17,12), 
					"Y1858" NUMBER(18,13), 
					"Y1859" NUMBER(18,13), 
					"Y1860" NUMBER(19,14), 
					"Y1861" NUMBER(18,13), 
					"Y1862" NUMBER(19,14), 
					"Y1863" NUMBER(19,14), 
					"Y1864" NUMBER(18,13), 
					"Y1865" NUMBER(18,13), 
					"Y1866" NUMBER(18,13), 
					"Y1867" NUMBER(18,13), 
					"Y1868" NUMBER(19,14), 
					"Y1869" NUMBER(19,14), 
					"Y1870" NUMBER(19,14), 
					"Y1871" NUMBER(18,13), 
					"Y1872" NUMBER(18,13), 
					"Y1873" NUMBER(18,13), 
					"Y1874" NUMBER(18,13), 
					"Y1875" NUMBER(18,13), 
					"Y1876" NUMBER(18,13), 
					"Y1877" NUMBER(18,13), 
					"Y1878" NUMBER(19,14), 
					"Y1879" NUMBER(18,13), 
					"Y1880" NUMBER(19,14), 
					"Y1881" NUMBER(19,14), 
					"Y1882" NUMBER(19,14), 
					"Y1883" NUMBER(18,13), 
					"Y1884" NUMBER(19,14), 
					"Y1885" NUMBER(18,13), 
					"Y1886" NUMBER(18,13), 
					"Y1887" NUMBER(18,13), 
					"Y1888" NUMBER(19,14), 
					"Y1889" NUMBER(19,14), 
					"Y1890" NUMBER(22,13), 
					"Y1891" NUMBER(23,14), 
					"Y1892" NUMBER(20,12), 
					"Y1893" NUMBER(21,13), 
					"Y1894" NUMBER(22,14), 
					"Y1895" NUMBER(22,14), 
					"Y1896" NUMBER(22,14), 
					"Y1897" NUMBER(21,13), 
					"Y1898" NUMBER(21,13), 
					"Y1899" NUMBER(22,14), 
					"Y1900" NUMBER(23,14), 
					"Y1901" NUMBER(21,14), 
					"Y1902" NUMBER(23,15), 
					"Y1903" NUMBER(21,14), 
					"Y1904" NUMBER(22,15), 
					"Y1905" NUMBER(22,15), 
					"Y1906" NUMBER(22,15), 
					"Y1907" NUMBER(22,15), 
					"Y1908" NUMBER(23,16), 
					"Y1909" NUMBER(23,16), 
					"Y1910" NUMBER(22,15), 
					"Y1911" NUMBER(22,15), 
					"Y1912" NUMBER(22,15), 
					"Y1913" NUMBER(23,16), 
					"Y1914" NUMBER(23,16), 
					"Y1915" NUMBER(23,16), 
					"Y1916" NUMBER(24,16), 
					"Y1917" NUMBER(23,16), 
					"Y1918" NUMBER(23,16), 
					"Y1919" NUMBER(23,16), 
					"Y1920" NUMBER(23,16), 
					"Y1921" NUMBER(23,16), 
					"Y1922" NUMBER(23,16), 
					"Y1923" NUMBER(23,16), 
					"Y1924" NUMBER(23,16), 
					"Y1925" NUMBER(23,16), 
					"Y1926" NUMBER(23,16), 
					"Y1927" NUMBER(23,16), 
					"Y1928" NUMBER(22,15), 
					"Y1929" NUMBER(23,16), 
					"Y1930" NUMBER(23,16), 
					"Y1931" NUMBER(23,16), 
					"Y1932" NUMBER(23,16), 
					"Y1933" NUMBER(22,15), 
					"Y1934" NUMBER(23,16), 
					"Y1935" NUMBER(23,16), 
					"Y1936" NUMBER(23,16), 
					"Y1937" NUMBER(23,16), 
					"Y1938" NUMBER(23,16), 
					"Y1939" NUMBER(22,15), 
					"Y1940" NUMBER(23,16), 
					"Y1941" NUMBER(22,15), 
					"Y1942" NUMBER(23,16), 
					"Y1943" NUMBER(23,16), 
					"Y1944" NUMBER(23,16), 
					"Y1945" NUMBER(22,15), 
					"Y1946" NUMBER(23,16), 
					"Y1947" NUMBER(23,16), 
					"Y1948" NUMBER(23,16), 
					"Y1949" NUMBER(23,16), 
					"Y1950" NUMBER(23,16), 
					"Y1951" NUMBER(22,15), 
					"Y1952" NUMBER(23,16), 
					"Y1953" NUMBER(23,16), 
					"Y1954" NUMBER(23,16), 
					"Y1955" NUMBER(23,16), 
					"Y1956" NUMBER(23,16), 
					"Y1957" NUMBER(23,16), 
					"Y1958" NUMBER(23,16), 
					"Y1959" NUMBER(23,16), 
					"Y1960" NUMBER(23,16), 
					"Y1961" NUMBER(23,16), 
					"Y1962" NUMBER(23,16), 
					"Y1963" NUMBER(23,16), 
					"Y1964" NUMBER(23,16), 
					"Y1965" NUMBER(23,16), 
					"Y1966" NUMBER(24,17), 
					"Y1967" NUMBER(24,17), 
					"Y1968" NUMBER(24,17), 
					"Y1969" NUMBER(23,16), 
					"Y1970" NUMBER(25,17), 
					"Y1971" NUMBER(25,17), 
					"Y1972" NUMBER(25,17), 
					"Y1973" NUMBER(24,16), 
					"Y1974" NUMBER(23,15), 
					"Y1975" NUMBER(24,16), 
					"Y1976" NUMBER(24,16), 
					"Y1977" NUMBER(23,15), 
					"Y1978" NUMBER(23,15), 
					"Y1979" NUMBER(23,15), 
					"Y1980" NUMBER(23,15), 
					"Y1981" NUMBER(23,15), 
					"Y1982" NUMBER(22,14), 
					"Y1983" NUMBER(23,15), 
					"Y1984" NUMBER(23,15), 
					"Y1985" NUMBER(23,15), 
					"Y1986" NUMBER(23,15), 
					"Y1987" NUMBER(24,16), 
					"Y1988" NUMBER(24,16), 
					"Y1989" NUMBER(23,15), 
					"Y1990" NUMBER(22,14), 
					"Y1991" NUMBER(22,14), 
					"Y1992" NUMBER(22,14), 
					"Y1993" NUMBER(22,14), 
					"Y1994" NUMBER(21,13), 
					"Y1995" NUMBER(23,15), 
					"Y1996" NUMBER(22,14), 
					"Y1997" NUMBER(22,14), 
					"Y1998" NUMBER(23,15), 
					"Y1999" NUMBER(20,12), 
					"Y2000" NUMBER(21,14), 
					"Y2001" NUMBER(22,15), 
					"Y2002" NUMBER(23,15), 
					"Y2003" NUMBER(22,15), 
					"Y2004" NUMBER(23,15), 
					"Y2005" NUMBER(22,14), 
					"Y2006" NUMBER(23,15), 
					"Y2007" NUMBER(23,15), 
					"Y2008" NUMBER(22,14), 
					"Y2009" NUMBER(23,15), 
					"Y2010" NUMBER(22,15), 
					"Y2011" NUMBER(22,15), 
					"Y2012" NUMBER(24,16), 
					"Y2013" NUMBER(23,15), 
					"Y2014" NUMBER(23,15), 
					"Y2015" NUMBER(24,16), 
					"Y2016" NUMBER(24,16)
				   )';
   
   
  END IF;
  
  
  SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME_LT ||'';
	
		IF z=0 THEN
			
				EXECUTE IMMEDIATE'
				CREATE TABLE PKD.'|| T08_TABLE_NAME_LT ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"EGYEB" VARCHAR2(26 BYTE), "Y1780" NUMBER(18,11), "Y1781" NUMBER(19,12), "Y1782" NUMBER(18,11), "Y1783" NUMBER(18,11), 
					"Y1784" NUMBER(18,11), 
					"Y1785" NUMBER(18,11), 
					"Y1786" NUMBER(19,12), 
					"Y1787" NUMBER(19,12), 
					"Y1788" NUMBER(19,12), 
					"Y1789" NUMBER(18,12), 
					"Y1790" NUMBER(17,11), 
					"Y1791" NUMBER(17,11), 
					"Y1792" NUMBER(18,12), 
					"Y1793" NUMBER(18,12), 
					"Y1794" NUMBER(18,12), 
					"Y1795" NUMBER(18,12), 
					"Y1796" NUMBER(19,13), 
					"Y1797" NUMBER(19,13), 
					"Y1798" NUMBER(18,12), 
					"Y1799" NUMBER(19,13), 
					"Y1800" NUMBER(19,13), 
					"Y1801" NUMBER(19,13), 
					"Y1802" NUMBER(19,13), 
					"Y1803" NUMBER(18,12), 
					"Y1804" NUMBER(19,13), 
					"Y1805" NUMBER(19,13), 
					"Y1806" NUMBER(19,13), 
					"Y1807" NUMBER(19,13), 
					"Y1808" NUMBER(19,13), 
					"Y1809" NUMBER(19,13), 
					"Y1810" NUMBER(19,13), 
					"Y1811" NUMBER(18,12), 
					"Y1812" NUMBER(19,13), 
					"Y1813" NUMBER(19,13), 
					"Y1814" NUMBER(19,13), 
					"Y1815" NUMBER(18,13), 
					"Y1816" NUMBER(18,13), 
					"Y1817" NUMBER(18,13), 
					"Y1818" NUMBER(18,13), 
					"Y1819" NUMBER(18,13), 
					"Y1820" NUMBER(18,13), 
					"Y1821" NUMBER(18,13), 
					"Y1822" NUMBER(18,13), 
					"Y1823" NUMBER(18,13), 
					"Y1824" NUMBER(18,13), 
					"Y1825" NUMBER(18,13), 
					"Y1826" NUMBER(18,13), 
					"Y1827" NUMBER(18,13), 
					"Y1828" NUMBER(18,13), 
					"Y1829" NUMBER(17,12), 
					"Y1830" NUMBER(19,14), 
					"Y1831" NUMBER(19,14), 
					"Y1832" NUMBER(18,13), 
					"Y1833" NUMBER(19,14), 
					"Y1834" NUMBER(18,13), 
					"Y1835" NUMBER(18,13), 
					"Y1836" NUMBER(18,13), 
					"Y1837" NUMBER(18,13), 
					"Y1838" NUMBER(18,13), 
					"Y1839" NUMBER(18,13), 
					"Y1840" NUMBER(18,13), 
					"Y1841" NUMBER(18,13), 
					"Y1842" NUMBER(19,14), 
					"Y1843" NUMBER(18,13), 
					"Y1844" NUMBER(18,13), 
					"Y1845" NUMBER(17,12), 
					"Y1846" NUMBER(19,14), 
					"Y1847" NUMBER(19,14), 
					"Y1848" NUMBER(18,13), 
					"Y1849" NUMBER(18,13), 
					"Y1850" NUMBER(19,14), 
					"Y1851" NUMBER(19,14), 
					"Y1852" NUMBER(18,13), 
					"Y1853" NUMBER(18,13), 
					"Y1854" NUMBER(19,14), 
					"Y1855" NUMBER(18,13), 
					"Y1856" NUMBER(18,13), 
					"Y1857" NUMBER(17,12), 
					"Y1858" NUMBER(18,13), 
					"Y1859" NUMBER(18,13), 
					"Y1860" NUMBER(19,14), 
					"Y1861" NUMBER(18,13), 
					"Y1862" NUMBER(19,14), 
					"Y1863" NUMBER(19,14), 
					"Y1864" NUMBER(18,13), 
					"Y1865" NUMBER(18,13), 
					"Y1866" NUMBER(18,13), 
					"Y1867" NUMBER(18,13), 
					"Y1868" NUMBER(19,14), 
					"Y1869" NUMBER(19,14), 
					"Y1870" NUMBER(19,14), 
					"Y1871" NUMBER(18,13), 
					"Y1872" NUMBER(18,13), 
					"Y1873" NUMBER(18,13), 
					"Y1874" NUMBER(18,13), 
					"Y1875" NUMBER(18,13), 
					"Y1876" NUMBER(18,13), 
					"Y1877" NUMBER(18,13), 
					"Y1878" NUMBER(19,14), 
					"Y1879" NUMBER(18,13), 
					"Y1880" NUMBER(19,14), 
					"Y1881" NUMBER(19,14), 
					"Y1882" NUMBER(19,14), 
					"Y1883" NUMBER(18,13), 
					"Y1884" NUMBER(19,14), 
					"Y1885" NUMBER(18,13), 
					"Y1886" NUMBER(18,13), 
					"Y1887" NUMBER(18,13), 
					"Y1888" NUMBER(19,14), 
					"Y1889" NUMBER(19,14), 
					"Y1890" NUMBER(22,13), 
					"Y1891" NUMBER(23,14), 
					"Y1892" NUMBER(20,12), 
					"Y1893" NUMBER(21,13), 
					"Y1894" NUMBER(22,14), 
					"Y1895" NUMBER(22,14), 
					"Y1896" NUMBER(22,14), 
					"Y1897" NUMBER(21,13), 
					"Y1898" NUMBER(21,13), 
					"Y1899" NUMBER(22,14), 
					"Y1900" NUMBER(23,14), 
					"Y1901" NUMBER(21,14), 
					"Y1902" NUMBER(23,15), 
					"Y1903" NUMBER(21,14), 
					"Y1904" NUMBER(22,15), 
					"Y1905" NUMBER(22,15), 
					"Y1906" NUMBER(22,15), 
					"Y1907" NUMBER(22,15), 
					"Y1908" NUMBER(23,16), 
					"Y1909" NUMBER(23,16), 
					"Y1910" NUMBER(22,15), 
					"Y1911" NUMBER(22,15), 
					"Y1912" NUMBER(22,15), 
					"Y1913" NUMBER(23,16), 
					"Y1914" NUMBER(23,16), 
					"Y1915" NUMBER(23,16), 
					"Y1916" NUMBER(24,16), 
					"Y1917" NUMBER(23,16), 
					"Y1918" NUMBER(23,16), 
					"Y1919" NUMBER(23,16), 
					"Y1920" NUMBER(23,16), 
					"Y1921" NUMBER(23,16), 
					"Y1922" NUMBER(23,16), 
					"Y1923" NUMBER(23,16), 
					"Y1924" NUMBER(23,16), 
					"Y1925" NUMBER(23,16), 
					"Y1926" NUMBER(23,16), 
					"Y1927" NUMBER(23,16), 
					"Y1928" NUMBER(22,15), 
					"Y1929" NUMBER(23,16), 
					"Y1930" NUMBER(23,16), 
					"Y1931" NUMBER(23,16), 
					"Y1932" NUMBER(23,16), 
					"Y1933" NUMBER(22,15), 
					"Y1934" NUMBER(23,16), 
					"Y1935" NUMBER(23,16), 
					"Y1936" NUMBER(23,16), 
					"Y1937" NUMBER(23,16), 
					"Y1938" NUMBER(23,16), 
					"Y1939" NUMBER(22,15), 
					"Y1940" NUMBER(23,16), 
					"Y1941" NUMBER(22,15), 
					"Y1942" NUMBER(23,16), 
					"Y1943" NUMBER(23,16), 
					"Y1944" NUMBER(23,16), 
					"Y1945" NUMBER(22,15), 
					"Y1946" NUMBER(23,16), 
					"Y1947" NUMBER(23,16), 
					"Y1948" NUMBER(23,16), 
					"Y1949" NUMBER(23,16), 
					"Y1950" NUMBER(23,16), 
					"Y1951" NUMBER(22,15), 
					"Y1952" NUMBER(23,16), 
					"Y1953" NUMBER(23,16), 
					"Y1954" NUMBER(23,16), 
					"Y1955" NUMBER(23,16), 
					"Y1956" NUMBER(23,16), 
					"Y1957" NUMBER(23,16), 
					"Y1958" NUMBER(23,16), 
					"Y1959" NUMBER(23,16), 
					"Y1960" NUMBER(23,16), 
					"Y1961" NUMBER(23,16), 
					"Y1962" NUMBER(23,16), 
					"Y1963" NUMBER(23,16), 
					"Y1964" NUMBER(23,16), 
					"Y1965" NUMBER(23,16), 
					"Y1966" NUMBER(24,17), 
					"Y1967" NUMBER(24,17), 
					"Y1968" NUMBER(24,17), 
					"Y1969" NUMBER(23,16), 
					"Y1970" NUMBER(25,17), 
					"Y1971" NUMBER(25,17), 
					"Y1972" NUMBER(25,17), 
					"Y1973" NUMBER(24,16), 
					"Y1974" NUMBER(23,15), 
					"Y1975" NUMBER(24,16), 
					"Y1976" NUMBER(24,16), 
					"Y1977" NUMBER(23,15), 
					"Y1978" NUMBER(23,15), 
					"Y1979" NUMBER(23,15), 
					"Y1980" NUMBER(23,15), 
					"Y1981" NUMBER(23,15), 
					"Y1982" NUMBER(22,14), 
					"Y1983" NUMBER(23,15), 
					"Y1984" NUMBER(23,15), 
					"Y1985" NUMBER(23,15), 
					"Y1986" NUMBER(23,15), 
					"Y1987" NUMBER(24,16), 
					"Y1988" NUMBER(24,16), 
					"Y1989" NUMBER(23,15), 
					"Y1990" NUMBER(22,14), 
					"Y1991" NUMBER(22,14), 
					"Y1992" NUMBER(22,14), 
					"Y1993" NUMBER(22,14), 
					"Y1994" NUMBER(21,13), 
					"Y1995" NUMBER(23,15), 
					"Y1996" NUMBER(22,14), 
					"Y1997" NUMBER(22,14), 
					"Y1998" NUMBER(23,15), 
					"Y1999" NUMBER(20,12), 
					"Y2000" NUMBER(21,14), 
					"Y2001" NUMBER(22,15), 
					"Y2002" NUMBER(23,15), 
					"Y2003" NUMBER(22,15), 
					"Y2004" NUMBER(23,15), 
					"Y2005" NUMBER(22,14), 
					"Y2006" NUMBER(23,15), 
					"Y2007" NUMBER(23,15), 
					"Y2008" NUMBER(22,14), 
					"Y2009" NUMBER(23,15), 
					"Y2010" NUMBER(22,15), 
					"Y2011" NUMBER(22,15), 
					"Y2012" NUMBER(24,16), 
					"Y2013" NUMBER(23,15), 
					"Y2014" NUMBER(23,15), 
					"Y2015" NUMBER(24,16), 
					"Y2016" NUMBER(24,16)
				   )';
   
   
  END IF;
  
  
   SELECT COUNT(*) INTO z FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME_AR ||'';
	
		IF z=0 THEN
			
				EXECUTE IMMEDIATE'
				CREATE TABLE PKD.'|| T08_TABLE_NAME_AR ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
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
  
  
-- INV2 átalakító

-- 1. lépés: ahol az arányszám 1, azokat egy listába tesszük

	IF ''|| ALSZEKTOR ||'' = 'S1311' THEN -- kormányzatnál 1 kivétel van

		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) '; 

	ELSIF ''|| ALSZEKTOR ||'' = 'S1313' THEN -- önkormányzatnál 2 kivétel van

		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) 
		AND T08 != NVL('|| T08_2 ||', 0) '; 
		
	ELSIF ''|| ALSZEKTOR ||'' = 'S11' THEN -- S11-nél 2 kivétel van (26 és 32)
	
		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) 
		AND T08 != NVL('|| T08_2 ||', 0)  AND ARANYSZAM = ''1'' '; 	
		

	ELSE 
	
		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ARANYSZAM = ''1'' '; 		
		
	END IF;
		
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate;

	sql_statement := 'SELECT DISTINCT ESZKOZCSP FROM PKD.'|| T03_TABLE_NAME ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' ';
	EXECUTE IMMEDIATE sql_statement  BULK COLLECT INTO v_eszkozcsp;
	

-- az új táblába tesszük a T08-as ágazatok listáját

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR c IN v_rate.FIRST..v_rate.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| T08_TABLE_NAME ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| v_rate(c).SZEKTOR ||''', '''|| v_rate(c).ALSZEKTOR ||''', '|| v_rate(c).T08 ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
	
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		FOR c IN v_rate.FIRST..v_rate.LAST LOOP	
	
			FOR d IN l_cell.FIRST..l_cell.LAST LOOP
										
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
				(SELECT Y'|| l_cell(d) ||'  FROM PKD.'|| T03_TABLE_NAME ||' a
				WHERE a.AGAZAT = '|| v_rate(c).T03 ||' AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
				WHERE AGAZAT = '|| v_rate(c).T08 ||' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
				'
				;
									
				l_idx := l_cell.NEXT(l_idx);
	
			END LOOP;
			
		END LOOP;	
		
	END LOOP;
	


-- 2. lépés: ahol az arányszám 0, azokat egy listába tesszük

	sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ARANYSZAM = ''0'' '; 

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate_0;

v_rate_0.extend(1);
IF v_rate_0(1).T08 = '0' THEN

-- az új táblába tesszük a T08-as ágazatok listáját

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		FOR c IN v_rate_0.FIRST..v_rate_0.LAST LOOP	
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| T08_TABLE_NAME ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| v_rate_0(c).SZEKTOR ||''', '''|| v_rate_0(c).ALSZEKTOR ||''', '|| v_rate_0(c).T08 ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
	
		END LOOP;
		
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		FOR c IN v_rate_0.FIRST..v_rate_0.LAST LOOP	
	
			FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
				''0''
				WHERE AGAZAT = '|| v_rate_0(c).T08 ||' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
				'
				;
				
				l_idx := l_cell.NEXT(l_idx);
	
			END LOOP;
		
		END LOOP;
			
	END LOOP;	

END IF;


-- 3. lépés: ahol az arányszám 0 és 1 közötti, azokat egy listába tesszük

	sql_statement := 'SELECT COUNT(*) FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ARANYSZAM NOT IN (''0'', ''1'')';	
	
	EXECUTE IMMEDIATE sql_statement INTO v;
	
	IF v > 0 THEN
	
	IF ALSZEKTOR = 'S11' THEN
	
	sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
	AND ARANYSZAM NOT IN (''0'', ''1'') AND T08 != NVL('|| T08_1 ||', 0) AND T08 != NVL('|| T08_2 ||', 0) '; 
		
	ELSE 
	
	sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
	AND ARANYSZAM NOT IN (''0'', ''1'')';
	
	END IF;
		
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate_d;


-- az új táblába tesszük a T08-as ágazatok listáját

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
			
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| T08_TABLE_NAME ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| v_rate_d(c).SZEKTOR ||''', '''|| v_rate_d(c).ALSZEKTOR ||''', '|| v_rate_d(c).T08 ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
		
	END LOOP;
		

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
	
			FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
				(SELECT a.Y'|| l_cell(d) ||' * b.ARANYSZAM
				FROM PKD.'|| T03_TABLE_NAME ||' a, PKD.'|| RATE_CALC ||' b
				WHERE a.AGAZAT = '|| v_rate_d(c).T03 ||' AND b.T08 = '|| v_rate_d(c).T08 ||' AND a.ALSZEKTOR = '''|| ALSZEKTOR ||'''  AND b.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
				AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
				WHERE AGAZAT = '|| v_rate_d(c).T08 ||' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
				'
				;
				
				 l_idx := l_cell.NEXT(l_idx);
				
			END LOOP;
	
		END LOOP;
			
	END LOOP;	

	END IF;


-- 4. lépés: a kivételek, azaz amelyeket össze kell adni / 1

IF ''|| T08_1 ||'' IS NOT NULL THEN
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| T08_TABLE_NAME ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) 
		VALUES ('''|| SZEKTOR ||''', '''|| ALSZEKTOR ||''', '''|| T08_1 ||''', '''|| v_eszkozcsp(a) ||''')';
		
	END LOOP;

	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
			(SELECT SUM(NVL(a.Y'|| l_cell(d) ||', 0))
			FROM PKD.'|| T03_TABLE_NAME ||' a
			WHERE a.AGAZAT IN (SELECT T03 FROM PKD.'|| rate_calc ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 = '''|| T08_1 ||''') 
			AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
			WHERE AGAZAT = '''|| T08_1 ||''' 
			AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
			'
			;
					
			l_idx := l_cell.NEXT(l_idx);
	
		END LOOP;
	
	END LOOP;
			
			
END IF;
	

IF ''|| T08_2 ||'' IS NOT NULL THEN -- a kivételek, azaz amelyeket össze kell adni / 2 

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| T08_TABLE_NAME ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) 
		VALUES ('''|| SZEKTOR ||''', '''|| ALSZEKTOR ||''', '''|| T08_2 ||''', '''|| v_eszkozcsp(a) ||''')';
		
	END LOOP;


-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
			(SELECT SUM(NVL(a.Y'|| l_cell(d) ||', 0))
			FROM PKD.'|| T03_TABLE_NAME ||' a
			WHERE a.AGAZAT IN (SELECT T03 FROM PKD.'|| rate_calc ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 = '''|| T08_2 ||''') 
			AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
			WHERE AGAZAT = '''|| T08_2 ||''' 
			AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
			'
			;
					
		l_idx := l_cell.NEXT(l_idx);
		
		END LOOP;
	
	END LOOP;
	
END IF;
	
	
-- 5. lépés: a 01 és 09 közöttieket 0-val kezdődőre kell állítani	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';
	



-- LIFETIME átalakító

	IF ''|| ALSZEKTOR ||'' = 'S1311' THEN -- önkormányzatnál 2 kivétel is van

		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) '; 

	ELSIF ''|| ALSZEKTOR ||'' = 'S1313' THEN -- önkormányzatnál 2 kivétel is van

		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) 
		AND T08 != NVL('|| T08_2 ||', 0) '; 	
		
	ELSIF ''|| ALSZEKTOR ||'' = 'S11' THEN -- S11-nél 2 kivétel van (26 és 32)
	
		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) 
		AND T08 != NVL('|| T08_2 ||', 0)  '; 	
		
	ELSE 
	
		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
		'; 		
	
		
	END IF;

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate_d;
	
	sql_statement := 'SELECT DISTINCT ESZKOZCSP FROM PKD.'|| T03_TABLE_NAME_LT ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' ';
	EXECUTE IMMEDIATE sql_statement  BULK COLLECT INTO v_eszkozcsp;


-- 1. lépés az új táblába tesszük a T08-as ágazatok listáját
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| T08_TABLE_NAME_LT ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| v_rate_d(c).SZEKTOR ||''', '''|| v_rate_d(c).ALSZEKTOR ||''', '|| v_rate_d(c).T08 ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
	
	END LOOP;
	

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP

		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
	
			FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET Y'|| l_cell(d) ||'  =
				(SELECT a.Y'|| l_cell(d) ||'
				FROM PKD.'|| T03_TABLE_NAME_LT ||' a, PKD.'|| RATE_CALC ||' b
				WHERE a.AGAZAT = '|| v_rate_d(c).T03 ||' AND b.T08 = '|| v_rate_d(c).T08 ||' AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' 
				AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.ALSZEKTOR = '''|| ALSZEKTOR ||''')
				WHERE AGAZAT = '|| v_rate_d(c).T08 ||' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				'
				;
				
				l_idx := l_cell.NEXT(l_idx);
	
			END LOOP;
		
		END LOOP;
			
	END LOOP;	
	
	
-- 2. lépés: a kivételek / 1 

IF ''|| T08_1 ||'' IS NOT NULL THEN
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| T08_TABLE_NAME_LT ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) 
		VALUES ('''|| SZEKTOR ||''', '''|| ALSZEKTOR ||''', '''|| T08_1 ||''', '''|| v_eszkozcsp(a) ||''')';
		
	END LOOP;
	
	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;


	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| T08_TABLE_NAME_LT ||' b SET Y'|| l_cell(d) ||'  =
			(SELECT a.Y'|| l_cell(d) ||'
			FROM PKD.'|| T03_TABLE_NAME_LT ||' a
			WHERE a.AGAZAT = '''|| LT_INPUT ||'''
			AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
			WHERE AGAZAT = '|| T08_1 ||'
			AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
			'
			;
				
			l_idx := l_cell.NEXT(l_idx);
		
		END LOOP;
	
	END LOOP;

END IF;
	
	
--2. lépés: a kivételek / 2 -- törölhető kódrészlet

IF ''|| T08_2 ||'' IS NOT NULL THEN 
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| T08_TABLE_NAME_LT ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) 
		VALUES ('''|| SZEKTOR ||''', '''|| ALSZEKTOR ||''', '''|| T08_2 ||''', '''|| v_eszkozcsp(a) ||''')';
		
	END LOOP;
	
	
--az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;


	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| T08_TABLE_NAME_LT ||' b SET Y'|| l_cell(d) ||'  =
			(SELECT a.Y'|| l_cell(d) ||'
			FROM PKD.'|| T03_TABLE_NAME_LT ||' a
			WHERE a.AGAZAT = '''|| LT_INPUT ||'''
			AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
			WHERE AGAZAT = '|| T08_2 ||'
			AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
			'
			;
				
			l_idx := l_cell.NEXT(l_idx);
		
		END LOOP;
	
	END LOOP;

END IF;


	-- 3. lépés: a 01 és 09 közöttieket 0-val kezdődőre kell állítani	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';
	

	


-- ÁRINDEX átalakító
	IF ''|| ALSZEKTOR ||'' = 'S1311' THEN -- kormányzatnál 1 kivétel van (841)

		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) '; 

	ELSIF ''|| ALSZEKTOR ||'' = 'S1313' THEN -- önkormányzatnál 2 kivétel is van (841, 81)

		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) 
		AND T08 != NVL('|| T08_2 ||', 0) '; 

	ELSIF ''|| ALSZEKTOR ||'' = 'S11' THEN -- S11-nél 2 kivétel van (26 és 32)
	
		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' AND T08 != NVL('|| T08_1 ||', 0) 
		AND T08 != NVL('|| T08_2 ||', 0)  '; 	
		
	ELSE
	
		sql_statement := 'SELECT * FROM PKD.'|| rate_calc ||' WHERE SZEKTOR = '''|| SZEKTOR ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
		'; 	
		
	END IF;

	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_rate_d;
	
	sql_statement := 'SELECT DISTINCT ESZKOZCSP FROM PKD.'|| T03_TABLE_NAME_AR ||' WHERE ALSZEKTOR = '''|| ALSZEKTOR ||''' ';
	EXECUTE IMMEDIATE sql_statement  BULK COLLECT INTO v_eszkozcsp;


-- 1. lépés az új táblába tesszük a T08-as ágazatok listáját
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP
	
		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		
			EXECUTE IMMEDIATE'
			INSERT INTO PKD.'|| T08_TABLE_NAME_AR ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) VALUES 
			('''|| v_rate_d(c).SZEKTOR ||''', '''|| v_rate_d(c).ALSZEKTOR ||''', '|| v_rate_d(c).T08 ||', '''|| v_eszkozcsp(a) ||''')
			'
			;
		
		END LOOP;
	
	END LOOP;

		
-- az összes éven végigmegyünk

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP

		FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
	
			FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
				EXECUTE IMMEDIATE'
				UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET '|| v_ar_list(d) ||'  =
				(SELECT a.'|| v_ar_list(d) ||'
				FROM PKD.'|| T03_TABLE_NAME_AR ||' a, PKD.'|| RATE_CALC ||' b
				WHERE a.AGAZAT = '|| v_rate_d(c).T03 ||' AND b.T08 = '|| v_rate_d(c).T08 ||' AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' 
				AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' AND b.ALSZEKTOR = '''|| ALSZEKTOR ||''')
				WHERE AGAZAT = '|| v_rate_d(c).T08 ||' AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||''' AND ALSZEKTOR = '''|| ALSZEKTOR ||'''
				'
				;
							
			END LOOP;
		
		END LOOP;
			
	END LOOP;	


-- 2. lépés: a kivételek / 1

IF ''|| T08_1 ||'' IS NOT NULL THEN
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| T08_TABLE_NAME_AR ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) 
		VALUES ('''|| SZEKTOR ||''', '''|| ALSZEKTOR ||''', '''|| T08_1 ||''', '''|| v_eszkozcsp(a) ||''')';
		
	END LOOP;
	
	
-- az összes éven végigmegyünk

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| T08_TABLE_NAME_AR ||' b SET '|| v_ar_list(d) ||'  =
			(SELECT a.'|| v_ar_list(d) ||'
			FROM PKD.'|| T03_TABLE_NAME_AR ||' a
			WHERE a.AGAZAT = '''|| LT_INPUT ||'''
			AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
			WHERE AGAZAT = '|| T08_1 ||'
			AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
			'
			;
	
		
		END LOOP;
	
	END LOOP;

END IF;
		

IF ''|| T08_2 ||'' IS NOT NULL THEN -- a kivételek / 2
	
	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	

		EXECUTE IMMEDIATE'
		INSERT INTO PKD.'|| T08_TABLE_NAME_AR ||' (SZEKTOR, ALSZEKTOR, AGAZAT, ESZKOZCSP) 
		VALUES ('''|| SZEKTOR ||''', '''|| ALSZEKTOR ||''', '''|| T08_2 ||''', '''|| v_eszkozcsp(a) ||''')';
		
	END LOOP;
	
	
-- az összes éven végigmegyünk

	FOR a IN v_eszkozcsp.FIRST..v_eszkozcsp.LAST LOOP	
	
		FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
			EXECUTE IMMEDIATE'
			UPDATE PKD.'|| T08_TABLE_NAME_AR ||' b SET '|| v_ar_list(d) ||'  =
			(SELECT a.'|| v_ar_list(d) ||'
			FROM PKD.'|| T03_TABLE_NAME_AR ||' a
			WHERE a.AGAZAT = '''|| LT_INPUT_2 ||'''
			AND a.ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND a.ESZKOZCSP = '''|| v_eszkozcsp(a) ||''')
			WHERE AGAZAT = '|| T08_2 ||'
			AND ALSZEKTOR = '''|| ALSZEKTOR ||''' 
			AND ESZKOZCSP = '''|| v_eszkozcsp(a) ||'''
			'
			;
	
		
		END LOOP;
	
	END LOOP;

END IF;


	-- 3. lépés: a 01 és 09 közöttieket 0-val kezdődőre kell állítani	
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';
	
	
	IF ''|| SZEKTOR ||'' = 'S13' THEN

		 -- KORM + ÖNKORM
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET EGYEB = ''KVI_ONK'' WHERE AGAZAT = ''841'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME ||' SET EGYEB = ''KVI_ONK'' WHERE AGAZAT = ''841'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET EGYEB = ''KVI_ONK'' WHERE AGAZAT = ''841'' AND SZEKTOR = ''S13'' ';
		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET EGYEB = ''GAT'' WHERE AGAZAT = ''842'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME ||' SET EGYEB = ''GAT'' WHERE AGAZAT = ''842'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET EGYEB = ''GAT'' WHERE AGAZAT = ''842'' AND SZEKTOR = ''S13'' ';
		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET EGYEB = ''UTA'' WHERE AGAZAT = ''843'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME ||' SET EGYEB = ''UTA'' WHERE AGAZAT = ''843'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET EGYEB = ''UTA'' WHERE AGAZAT = ''843'' AND SZEKTOR = ''S13'' ';
		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET EGYEB = ''VIZ'' WHERE AGAZAT = ''844'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME ||' SET EGYEB = ''VIZ'' WHERE AGAZAT = ''844'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET EGYEB = ''VIZ'' WHERE AGAZAT = ''844'' AND SZEKTOR = ''S13'' ';
		
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_AR ||' SET EGYEB = ''HM'' WHERE AGAZAT = ''845'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME ||' SET EGYEB = ''HM'' WHERE AGAZAT = ''845'' AND SZEKTOR = ''S13'' ';
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| T08_TABLE_NAME_LT ||' SET EGYEB = ''HM'' WHERE AGAZAT = ''845'' AND SZEKTOR = ''S13'' ';
		
	END IF;
	
	

END rate_calculator;

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

END;