/*

create or replace PACKAGE CFC_RATE AUTHID CURRENT_USER AS 
TYPE t_ar_list IS TABLE OF VARCHAR2(30 CHAR) INDEX BY PLS_INTEGER;
procedure rate_calculator(T03_TABLE_NAME VARCHAR2, T08_TABLE_NAME VARCHAR2, T03_TABLE_NAME_LT VARCHAR2, T08_TABLE_NAME_LT VARCHAR2, T03_TABLE_NAME_AR VARCHAR2, T08_TABLE_NAME_AR VARCHAR2, T03_11 VARCHAR2, T03_12 VARCHAR2, T08_1 VARCHAR2, T03_21 VARCHAR2, T03_22 VARCHAR2, T08_2 VARCHAR2, T03_31 VARCHAR2, T03_32 VARCHAR2, T03_33 VARCHAR2, T03_34 VARCHAR2, T03_35 VARCHAR2, T03_36 VARCHAR2, T03_37 VARCHAR2, T03_38 VARCHAR2, T03_39 VARCHAR2, T03_40 VARCHAR2, T03_41 VARCHAR2, T03_42 VARCHAR2, T03_43 VARCHAR2, T03_44 VARCHAR2, T03_45 VARCHAR2, T03_46 VARCHAR2, T03_47 VARCHAR2, T03_48 VARCHAR2, T03_49 VARCHAR2, T03_50 VARCHAR2, T03_51 VARCHAR2, T08_3 VARCHAR2, T03_61 VARCHAR2, T03_62 VARCHAR2, T03_63 VARCHAR2, T03_64 VARCHAR2, T03_65 VARCHAR2, T03_66 VARCHAR2, T08_6 VARCHAR2);


END CFC_RATE;



-------
*/


create or replace PACKAGE BODY CFC_RATE AS 
v_ar_list t_ar_list; 
v_out_schema VARCHAR(10) := 'PKD'; -- PKD séma -- mindenhova kell 


procedure rate_calculator(T03_TABLE_NAME VARCHAR2, T08_TABLE_NAME VARCHAR2, T03_TABLE_NAME_LT VARCHAR2, T08_TABLE_NAME_LT VARCHAR2, T03_TABLE_NAME_AR VARCHAR2, T08_TABLE_NAME_AR VARCHAR2, T03_11 VARCHAR2, T03_12 VARCHAR2, T08_1 VARCHAR2, T03_21 VARCHAR2, T03_22 VARCHAR2, T08_2 VARCHAR2, T03_31 VARCHAR2, T03_32 VARCHAR2, T03_33 VARCHAR2, T03_34 VARCHAR2, T03_35 VARCHAR2, T03_36 VARCHAR2, T03_37 VARCHAR2, T03_38 VARCHAR2, T03_39 VARCHAR2, T03_40 VARCHAR2, T03_41 VARCHAR2, T03_42 VARCHAR2, T03_43 VARCHAR2, T03_44 VARCHAR2, T03_45 VARCHAR2, T03_46 VARCHAR2, T03_47 VARCHAR2, T03_48 VARCHAR2, T03_49 VARCHAR2, T03_50 VARCHAR2, T03_51 VARCHAR2, T08_3 VARCHAR2, T03_61 VARCHAR2, T03_62 VARCHAR2, T03_63 VARCHAR2, T03_64 VARCHAR2, T03_65 VARCHAR2, T03_66 VARCHAR2, T08_6 VARCHAR2) AS

TYPE t_rate IS TABLE OF rate_calc%ROWTYPE; 
v_rate t_rate; 

TYPE t_rate_0 IS TABLE OF rate_calc%ROWTYPE; 
v_rate_0 t_rate_0; 

TYPE t_rate_d IS TABLE OF rate_calc%ROWTYPE; 
v_rate_d t_rate_d; 

TYPE t_rate_all IS TABLE OF GFCF_2016_AR%ROWTYPE; 
v_rate_all t_rate_all; 


type t_collection IS TABLE OF NUMBER(10) INDEX BY BINARY_INTEGER;
l_cell t_collection;
l_idx NUMBER;

v NUMERIC;
z NUMERIC;

BEGIN

SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| T08_TABLE_NAME ||'';
	
		IF v=0 THEN
			
				EXECUTE IMMEDIATE'
				CREATE TABLE '|| T08_TABLE_NAME ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR1" VARCHAR2(26 BYTE), "ALSZEKTOR2" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"ALAGAZAT" VARCHAR2(26 BYTE), "Y1780" NUMBER(18,11), "Y1781" NUMBER(19,12), "Y1782" NUMBER(18,11), "Y1783" NUMBER(18,11), 
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
				CREATE TABLE '|| T08_TABLE_NAME_LT ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR1" VARCHAR2(26 BYTE), "ALSZEKTOR2" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"ALAGAZAT" VARCHAR2(26 BYTE), "Y1780" NUMBER(18,11), "Y1781" NUMBER(19,12), "Y1782" NUMBER(18,11), "Y1783" NUMBER(18,11), 
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
				CREATE TABLE '|| T08_TABLE_NAME_AR ||'
				   (	"SZEKTOR" VARCHAR2(26 BYTE), 
					"ALSZEKTOR1" VARCHAR2(26 BYTE), "ALSZEKTOR2" VARCHAR2(26 BYTE), "ESZKOZCSP" VARCHAR2(26 BYTE), "AGAZAT" VARCHAR2(5 BYTE), 
					"ALAGAZAT" VARCHAR2(26 BYTE), 
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
SELECT * BULK COLLECT INTO v_rate FROM rate_calc WHERE T08 != NVL(''|| T08_1 ||'', 0) AND T08 != NVL(''|| T08_2 ||'', 0) AND T08 != NVL(''|| T08_3 ||'', 0) AND T08 != NVL(''|| T08_6 ||'', 0) AND ARANYSZAM = '1' ;

-- az új táblába tesszük a T08-as ágazatok listáját

	FOR c IN v_rate.FIRST..v_rate.LAST LOOP	
		EXECUTE IMMEDIATE'
			INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES 
			('|| v_rate(c).T08 ||')
			'
			;
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;


	FOR c IN v_rate.FIRST..v_rate.LAST LOOP	
	
		FOR d IN l_cell.FIRST..l_cell.LAST LOOP
										
			EXECUTE IMMEDIATE'
			UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
			(SELECT Y'|| l_cell(d) ||'  FROM '|| T03_TABLE_NAME ||' a
			WHERE a.AGAZAT = '|| v_rate(c).T03 ||')
			WHERE AGAZAT = '|| v_rate(c).T08 ||' AND SZEKTOR IS NULL
			'
			;
									
		l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
END LOOP;	


-- 2. lépés: ahol az arányszám 0, azokat egy listába tesszük

SELECT * BULK COLLECT INTO v_rate_0 FROM rate_calc WHERE ARANYSZAM = '0' ;

v_rate_0.extend(1);
IF v_rate_0(1).T08 = '0' THEN

-- az új táblába tesszük a T08-as ágazatok listáját
	FOR c IN v_rate_0.FIRST..v_rate_0.LAST LOOP	
		EXECUTE IMMEDIATE'
			INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES 
			('|| v_rate_0(c).T08 ||')
			'
			;
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

FOR c IN v_rate_0.FIRST..v_rate_0.LAST LOOP	
	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
		''0''
		WHERE AGAZAT = '|| v_rate_0(c).T08 ||' AND SZEKTOR IS NULL
		'
		;
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
END LOOP;	

END IF;


-- 3. lépés: ahol az arányszám 0 és 1 közötti, azokat egy listába tesszük
SELECT * BULK COLLECT INTO v_rate_d FROM rate_calc WHERE ARANYSZAM NOT IN ('0', '1');

-- az új táblába tesszük a T08-as ágazatok listáját
	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		EXECUTE IMMEDIATE'
			INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES 
			('|| v_rate_d(c).T08 ||')
			'
			;
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||' * b.ARANYSZAM
		FROM '|| T03_TABLE_NAME ||' a, RATE_CALC b
		WHERE a.AGAZAT = '|| v_rate_d(c).T03 ||' AND b.T08 = '|| v_rate_d(c).T08 ||')
		WHERE AGAZAT = '|| v_rate_d(c).T08 ||' AND SZEKTOR IS NULL
		'
		;
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
END LOOP;	




-- 4. lépés: a kivételek, azaz amelyeket össze kell adni

IF ''|| T08_1 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES ('''|| T08_1 ||''')';

	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||' + b.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME ||' a, '|| T03_TABLE_NAME ||' b
		WHERE a.AGAZAT = '''|| T03_11 ||''' AND b.AGAZAT = '''|| T03_12 ||''')
		WHERE AGAZAT = '''|| T08_1 ||''' AND SZEKTOR IS NULL
		'
		;
		
		
		l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
			
END IF;
	

IF ''|| T08_2 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES ('''|| T08_2 ||''')';


-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
						
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||' + b.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME ||' a, '|| T03_TABLE_NAME ||' b
		WHERE a.AGAZAT = '''|| T03_21 ||''' AND b.AGAZAT = '''|| T03_22 ||''')
		WHERE AGAZAT = '''|| T08_2 ||''' AND SZEKTOR IS NULL
		'
		;
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
						

END IF;


-- extra cucc, önkormányzatnál 21 T03-as ágazatot kell a 841-es T08-ba összeadni
	
IF ''|| T08_3 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES ('''|| T08_3 ||''')';

	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT NVL(a.Y'|| l_cell(d) ||', 0) + NVL(b.Y'|| l_cell(d) ||', 0) + NVL(c.Y'|| l_cell(d) ||', 0) + NVL(d.Y'|| l_cell(d) ||', 0) + NVL(e.Y'|| l_cell(d) ||', 0) + NVL(f.Y'|| l_cell(d) ||', 0) + NVL(g.Y'|| l_cell(d) ||', 0) + NVL(h.Y'|| l_cell(d) ||', 0) + NVL(i.Y'|| l_cell(d) ||', 0) + NVL(j.Y'|| l_cell(d) ||', 0) + NVL(k.Y'|| l_cell(d) ||', 0) + NVL(l.Y'|| l_cell(d) ||', 0) + NVL(m.Y'|| l_cell(d) ||', 0) + NVL(n.Y'|| l_cell(d) ||', 0) + NVL(o.Y'|| l_cell(d) ||', 0) + NVL(p.Y'|| l_cell(d) ||', 0) + NVL(q.Y'|| l_cell(d) ||', 0) + NVL(r.Y'|| l_cell(d) ||', 0) + NVL(s.Y'|| l_cell(d) ||', 0) + NVL(t.Y'|| l_cell(d) ||', 0) + NVL(u.Y'|| l_cell(d) ||', 0)
		FROM '|| T03_TABLE_NAME ||' a, '|| T03_TABLE_NAME ||' b, '|| T03_TABLE_NAME ||' c, '|| T03_TABLE_NAME ||' d, '|| T03_TABLE_NAME ||' e, '|| T03_TABLE_NAME ||' f, '|| T03_TABLE_NAME ||' g, '|| T03_TABLE_NAME ||' h, '|| T03_TABLE_NAME ||' i, '|| T03_TABLE_NAME ||' j, '|| T03_TABLE_NAME ||' k, '|| T03_TABLE_NAME ||' l, '|| T03_TABLE_NAME ||' m, '|| T03_TABLE_NAME ||' n, '|| T03_TABLE_NAME ||' o, '|| T03_TABLE_NAME ||' p, '|| T03_TABLE_NAME ||' q, '|| T03_TABLE_NAME ||' r, '|| T03_TABLE_NAME ||' s, '|| T03_TABLE_NAME ||' t, '|| T03_TABLE_NAME ||' u			
		WHERE a.AGAZAT = '''|| T03_31 ||''' AND b.AGAZAT = '''|| T03_32 ||''' AND c.AGAZAT = '''|| T03_33 ||''' AND d.AGAZAT = '''|| T03_34 ||''' AND e.AGAZAT = '''|| T03_35 ||''' AND f.AGAZAT = '''|| T03_36 ||''' AND g.AGAZAT = '''|| T03_37 ||''' AND h.AGAZAT = '''|| T03_38 ||''' AND i.AGAZAT = '''|| T03_39 ||''' AND j.AGAZAT = '''|| T03_40 ||''' AND k.AGAZAT = '''|| T03_41 ||''' AND l.AGAZAT = '''|| T03_42 ||''' AND m.AGAZAT = '''|| T03_43 ||''' AND n.AGAZAT = '''|| T03_44 ||''' AND o.AGAZAT = '''|| T03_45 ||''' AND p.AGAZAT = '''|| T03_46 ||''' AND q.AGAZAT = '''|| T03_47 ||''' AND r.AGAZAT = '''|| T03_48 ||''' AND s.AGAZAT = '''|| T03_49 ||''' AND t.AGAZAT = '''|| T03_50 ||''' AND u.AGAZAT = '''|| T03_51 ||''')  
		WHERE AGAZAT = '''|| T08_3 ||''' AND SZEKTOR IS NULL
		'
		;
		
		
		l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
			
END IF;


-- extra cucc, kormányzatnál 6 T03-as ágazatot kell a 841-es T08-ba összeadni
	
IF ''|| T08_6 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES ('''|| T08_6 ||''')';

	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT NVL(a.Y'|| l_cell(d) ||', 0) + NVL(b.Y'|| l_cell(d) ||', 0) + NVL(c.Y'|| l_cell(d) ||', 0) + NVL(d.Y'|| l_cell(d) ||', 0) + NVL(e.Y'|| l_cell(d) ||', 0) + NVL(f.Y'|| l_cell(d) ||', 0)
		FROM '|| T03_TABLE_NAME ||' a, '|| T03_TABLE_NAME ||' b, '|| T03_TABLE_NAME ||' c, '|| T03_TABLE_NAME ||' d, '|| T03_TABLE_NAME ||' e, '|| T03_TABLE_NAME ||' f
		WHERE a.AGAZAT = '''|| T03_61 ||''' AND b.AGAZAT = '''|| T03_62 ||''' AND c.AGAZAT = '''|| T03_63 ||''' AND d.AGAZAT = '''|| T03_64 ||''' AND e.AGAZAT = '''|| T03_65 ||''' AND f.AGAZAT = '''|| T03_66 ||''')  
		WHERE AGAZAT = '''|| T08_6 ||''' AND SZEKTOR IS NULL
		'
		;
		
		
		l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
			
END IF;


/*
-- a későbbi GFCF importálás miatt a többi ágazatot is be kell tenni a táblába, NULL értékekkel? Ez eldöntendő.
		
SELECT * BULK COLLECT INTO v_rate_all FROM GFCF_2016_AR WHERE AGAZAT NOT IN (SELECT T08 FROM RATE_CALC);

	FOR c IN v_rate_all.FIRST..v_rate_all.LAST LOOP	
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| T08_TABLE_NAME ||' (AGAZAT) VALUES 
		('|| v_rate_all(c).AGAZAT ||')
		'
		;
	
	END LOOP;
*/
	
-- 5. lépés: a 01 és 09 közöttieket 0-val kezdődőre kell állítani	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';
	
-- átmásoljuk a szektor és eszköcsoport értékeket

	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET SZEKTOR = (SELECT SZEKTOR FROM '|| T03_TABLE_NAME ||' WHERE AGAZAT = ''01'') WHERE SZEKTOR IS NULL';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALSZEKTOR1 = (SELECT ALSZEKTOR1 FROM '|| T03_TABLE_NAME ||' WHERE AGAZAT = ''01'')  WHERE ALSZEKTOR1 IS NULL';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ESZKOZCSP = (SELECT ESZKOZCSP FROM '|| T03_TABLE_NAME ||' WHERE AGAZAT = ''01'')  WHERE ESZKOZCSP IS NULL';
	
	

-- LIFETIME átalakító

SELECT * BULK COLLECT INTO v_rate_d FROM rate_calc WHERE T08 != NVL(''|| T08_1 ||'', 0) AND T08 != NVL(''|| T08_2 ||'', 0) AND T08 != NVL(''|| T08_3 ||'', 0) AND T08 != NVL(''|| T08_6 ||'', 0);

-- 1. lépés az új táblába tesszük a T08-as ágazatok listáját
	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		EXECUTE IMMEDIATE'
			INSERT INTO '|| T08_TABLE_NAME_LT ||' (AGAZAT) VALUES 
			('|| v_rate_d(c).T08 ||')
			'
			;
	END LOOP;

-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_LT ||' SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME_LT ||' a, RATE_CALC b
		WHERE a.AGAZAT = '|| v_rate_d(c).T03 ||' AND b.T08 = '|| v_rate_d(c).T08 ||')
		WHERE AGAZAT = '|| v_rate_d(c).T08 ||' AND SZEKTOR IS NULL
		'
		;
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
			
END LOOP;	
	
	
-- 2. lépés: a kivételek

IF ''|| T08_1 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_LT ||' (AGAZAT) VALUES ('''|| T08_1 ||''')';
	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_LT ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME_LT ||' a
		WHERE a.AGAZAT = '''|| T03_11 ||''')
		WHERE AGAZAT = '''|| T08_1 ||''' AND SZEKTOR IS NULL
		'
		;
				
	
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
	
END IF;
	
	

IF ''|| T08_2 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_LT ||' (AGAZAT) VALUES ('''|| T08_2 ||''')';


-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
					
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_LT ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME_LT ||' a
		WHERE a.AGAZAT = '''|| T03_21 ||''')
		WHERE AGAZAT = '''|| T08_2 ||''' AND SZEKTOR IS NULL
		'
		;
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
	
END IF;



-- extra cucc, önkormányzatnál 21 T03-as ágazatot kell a 841-es T08-ba összeadni

IF ''|| T08_3 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_LT ||' (AGAZAT) VALUES ('''|| T08_3 ||''')';
	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_LT ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME_LT ||' a
		WHERE a.AGAZAT = '''|| T03_31 ||''')
		WHERE AGAZAT = '''|| T08_3 ||''' AND SZEKTOR IS NULL
		'
		;
				
	
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
	
END IF;


-- extra cucc, kormányzatnál 6 T03-as ágazatot kell a 841-es T08-ba összeadni

IF ''|| T08_6 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_LT ||' (AGAZAT) VALUES ('''|| T08_6 ||''')';
	
-- az összes éven végigmegyünk
FOR m IN 1780..2015 LOOP 
	l_cell(m) := m;
END LOOP;
		
l_idx := l_cell.FIRST;

	
	FOR d IN l_cell.FIRST..l_cell.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_LT ||' b SET Y'|| l_cell(d) ||'  =
		(SELECT a.Y'|| l_cell(d) ||'
		FROM '|| T03_TABLE_NAME_LT ||' a
		WHERE a.AGAZAT = '''|| T03_61 ||''')
		WHERE AGAZAT = '''|| T08_6 ||''' AND SZEKTOR IS NULL
		'
		;
				
	
		
	l_idx := l_cell.NEXT(l_idx);
	
	END LOOP;
	
END IF;

/*
-- a későbbi GFCF importálás miatt a többi ágazatot is be kell tenni a táblába, NULL értékekkel? Ez eldöntendő.
		
SELECT * BULK COLLECT INTO v_rate_all FROM GFCF_2016_AR WHERE AGAZAT NOT IN (SELECT T08 FROM RATE_CALC);

	FOR c IN v_rate_all.FIRST..v_rate_all.LAST LOOP	
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| T08_TABLE_NAME_LT ||' (AGAZAT) VALUES 
		('|| v_rate_all(c).AGAZAT ||')
		'
		;
	
	END LOOP;
*/

	-- 3. lépés: a 01 és 09 közöttieket 0-val kezdődőre kell állítani	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';
	
-- átmásoljuk a szektor és eszköcsoport értékeket

	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET SZEKTOR = (SELECT SZEKTOR FROM '|| T03_TABLE_NAME_LT ||' WHERE AGAZAT = ''01'') WHERE SZEKTOR IS NULL';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALSZEKTOR1 = (SELECT ALSZEKTOR1 FROM '|| T03_TABLE_NAME_LT ||' WHERE AGAZAT = ''01'') WHERE ALSZEKTOR1 IS NULL';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ESZKOZCSP = (SELECT ESZKOZCSP FROM '|| T03_TABLE_NAME_LT ||' WHERE AGAZAT = ''01'') WHERE ESZKOZCSP IS NULL';
	
	



-- ÁRINDEX átalakító


SELECT * BULK COLLECT INTO v_rate_d FROM rate_calc WHERE T08 != NVL(''|| T08_1 ||'', 0) AND T08 != NVL(''|| T08_2 ||'', 0) AND T08 != NVL(''|| T08_3 ||'', 0) AND T08 != NVL(''|| T08_6 ||'', 0);

-- 1. lépés: az új táblába tesszük a T08-as ágazatok listáját
	FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
		EXECUTE IMMEDIATE'
			INSERT INTO '|| T08_TABLE_NAME_AR ||' (AGAZAT) VALUES 
			('|| v_rate_d(c).T08 ||')
			'
			;
	END LOOP;

		
-- az összes éven végigmegyünk

FOR c IN v_rate_d.FIRST..v_rate_d.LAST LOOP	
	
	FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_AR ||' SET '|| v_ar_list(d) ||'  =
		(SELECT a.'|| v_ar_list(d) ||'
		FROM '|| T03_TABLE_NAME_AR ||' a, RATE_CALC b
		WHERE a.AGAZAT = '|| v_rate_d(c).T03 ||' AND b.T08 = '|| v_rate_d(c).T08 ||')
		WHERE AGAZAT = '|| v_rate_d(c).T08 ||' AND SZEKTOR IS NULL
		'
		;
		
	
	END LOOP;
			
END LOOP;	


-- 2. lépés: a kivételek

IF ''|| T08_1 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_AR ||' (AGAZAT) VALUES ('''|| T08_1 ||''')';
	
-- az összes éven végigmegyünk
	
	FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_AR ||' b SET '|| v_ar_list(d) ||'  =
		(SELECT a.'|| v_ar_list(d) ||'
		FROM '|| T03_TABLE_NAME_AR ||' a
		WHERE a.AGAZAT = '''|| T03_11 ||''')
		WHERE AGAZAT = '''|| T08_1 ||''' AND SZEKTOR IS NULL
		'
		;
				

	
	END LOOP;
	
END IF;
	
	

IF ''|| T08_2 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_AR ||' (AGAZAT) VALUES ('''|| T08_2 ||''')';


-- az összes éven végigmegyünk
	
	FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
					
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_AR ||' b SET '|| v_ar_list(d) ||'  =
		(SELECT a.'|| v_ar_list(d) ||'
		FROM '|| T03_TABLE_NAME_AR ||' a
		WHERE a.AGAZAT = '''|| T03_21 ||''')
		WHERE AGAZAT = '''|| T08_2 ||''' AND SZEKTOR IS NULL
		'
		;
		
	
	END LOOP;
	
END IF;



-- extra cucc, önkormányzatnál 21 T03-as ágazatot kell a 84-es T08-ba összeadni

IF ''|| T08_3 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_AR ||' (AGAZAT) VALUES ('''|| T08_3 ||''')';
	
-- az összes éven végigmegyünk
	
	FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_AR ||' b SET '|| v_ar_list(d) ||'  =
		(SELECT a.'|| v_ar_list(d) ||'
		FROM '|| T03_TABLE_NAME_AR ||' a
		WHERE a.AGAZAT = '''|| T03_31 ||''')
		WHERE AGAZAT = '''|| T08_3 ||''' AND SZEKTOR IS NULL
		'
		;
			
	END LOOP;
	
END IF;


-- extra cucc, kormányzatnál 6 T03-as ágazatot kell a 841-es T08-ba összeadni

IF ''|| T08_6 ||'' IS NOT NULL THEN
	EXECUTE IMMEDIATE'
	INSERT INTO '|| T08_TABLE_NAME_AR ||' (AGAZAT) VALUES ('''|| T08_6 ||''')';
	
-- az összes éven végigmegyünk
	
	FOR d IN v_ar_list.FIRST..v_ar_list.LAST LOOP
			
		EXECUTE IMMEDIATE'
		UPDATE '|| T08_TABLE_NAME_AR ||' b SET '|| v_ar_list(d) ||'  =
		(SELECT a.'|| v_ar_list(d) ||'
		FROM '|| T03_TABLE_NAME_AR ||' a
		WHERE a.AGAZAT = '''|| T03_61 ||''')
		WHERE AGAZAT = '''|| T08_6 ||''' AND SZEKTOR IS NULL
		'
		;
			
	END LOOP;
	
END IF;

/*
-- a későbbi GFCF importálás miatt a többi ágazatot is be kell tenni a táblába, NULL értékekkel? Ez eldöntendő.
		
SELECT * BULK COLLECT INTO v_rate_all FROM GFCF_2016_AR WHERE AGAZAT NOT IN (SELECT T08 FROM RATE_CALC);

	FOR c IN v_rate_all.FIRST..v_rate_all.LAST LOOP	
		
		EXECUTE IMMEDIATE'
		INSERT INTO '|| T08_TABLE_NAME_AR ||' (AGAZAT) VALUES 
		('|| v_rate_all(c).AGAZAT ||')
		'
		;
	
	END LOOP;
*/


	-- 3. lépés: a 01 és 09 közöttieket 0-val kezdődőre kell állítani	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''01'' WHERE AGAZAT = ''1'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''02'' WHERE AGAZAT = ''2'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''03'' WHERE AGAZAT = ''3'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''04'' WHERE AGAZAT = ''4'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''05'' WHERE AGAZAT = ''5'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''06'' WHERE AGAZAT = ''6'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''07'' WHERE AGAZAT = ''7'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''08'' WHERE AGAZAT = ''8'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET AGAZAT = ''09'' WHERE AGAZAT = ''9'' ';
	
-- átmásoljuk a szektor és eszköcsoport értékeket

	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET SZEKTOR = (SELECT SZEKTOR FROM '|| T03_TABLE_NAME_LT ||' WHERE AGAZAT = ''01'') WHERE SZEKTOR IS NULL';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALSZEKTOR1 = (SELECT ALSZEKTOR1 FROM '|| T03_TABLE_NAME_LT ||' WHERE AGAZAT = ''01'') WHERE ALSZEKTOR1 IS NULL';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ESZKOZCSP = (SELECT ESZKOZCSP FROM '|| T03_TABLE_NAME_LT ||' WHERE AGAZAT = ''01'') WHERE ESZKOZCSP IS NULL';
	
	/*--ONK
	EXECUTE IMMEDIATE' 
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''ONK'' WHERE AGAZAT = ''841'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''ONK'' WHERE AGAZAT = ''841'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''ONK'' WHERE AGAZAT = ''841'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''GAT'' WHERE AGAZAT = ''842'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''GAT'' WHERE AGAZAT = ''842'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''GAT'' WHERE AGAZAT = ''842'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''UTA'' WHERE AGAZAT = ''843'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''UTA'' WHERE AGAZAT = ''843'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''UTA'' WHERE AGAZAT = ''843'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''VIZ'' WHERE AGAZAT = ''844'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''VIZ'' WHERE AGAZAT = ''844'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''VIZ'' WHERE AGAZAT = ''844'' ';
*/
	
	
	 -- KORM + ÖNKORM
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''KVI_ONK'' WHERE AGAZAT = ''841'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''KVI_ONK'' WHERE AGAZAT = ''841'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''KVI_ONK'' WHERE AGAZAT = ''841'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''GAT'' WHERE AGAZAT = ''842'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''GAT'' WHERE AGAZAT = ''842'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''GAT'' WHERE AGAZAT = ''842'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''UTA'' WHERE AGAZAT = ''843'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''UTA'' WHERE AGAZAT = ''843'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''UTA'' WHERE AGAZAT = ''843'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''VIZ'' WHERE AGAZAT = ''844'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''VIZ'' WHERE AGAZAT = ''844'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''VIZ'' WHERE AGAZAT = ''844'' ';
	
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_AR ||' SET ALAGAZAT = ''HM'' WHERE AGAZAT = ''845'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME ||' SET ALAGAZAT = ''HM'' WHERE AGAZAT = ''845'' ';
	EXECUTE IMMEDIATE'
	UPDATE '|| T08_TABLE_NAME_LT ||' SET ALAGAZAT = ''HM'' WHERE AGAZAT = ''845'' ';
	


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