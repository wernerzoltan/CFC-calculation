create or replace PROCEDURE CFC_main (running_method NUMBER, version_to_run VARCHAR2, schema_year NUMBER, inv2_run_from NUMBER, update_year NUMBER,  update_max_year NUMBER, v_alszektor VARCHAR2, v_eszkozcsp VARCHAR2, output_year VARCHAR2, pk_up_max_year NUMBER) AUTHID CURRENT_USER  AS

-- running_method: milyen folyamatrészt futtatunk
-- version_to_run: CFC importálás során milyen módra futunk
-- schema_year: séma évszáma, a GFCF tábla import évszámát ebből számoljuk ki automatikusan
-- inv2_run_from: évszám, amelyik évtől futtatjuk az INV2-t
-- update_year: v5-ös futás esetén a felülírandó évszám
-- update_max_year: v5-ös futás esetén melyik évig futtatjuk a PIM futást
-- output_year: OUTPUT futási éve. Ha az összes évre, akkor ALL érték kell
-- pk_up_max_year: a PK adatbázisba feltöltendő adatok max. évszáma (azaz melyik évig töltjük fel adatokkal)

sql_statement VARCHAR2(1000);
is_data exception;
procName VARCHAR2(20);
act_year NUMBER;
gfcf_imp BOOLEAN;
gfcf_imp_alt BOOLEAN;
pim_run BOOLEAN;
sector_unite BOOLEAN;
v_gfcf_table VARCHAR2(30);
v_gfcf_table_out VARCHAR2(30);
v_gfcf_mod_table VARCHAR2(30);
v_gfcf_ar_table VARCHAR2(30);
v_inv2_table VARCHAR2(30);
v_lifetime_table VARCHAR2(50);
v_arindex_1999 VARCHAR2(50);
v_arindex_lanc VARCHAR2(50);
v NUMERIC;
v1 NUMERIC;
szekt VARCHAR2(10);
alszekt VARCHAR2(10);
eszkoz VARCHAR2(50);
v_szektor_name VARCHAR2(50);
szekt_atad VARCHAR2(10);
alszekt_atad VARCHAR2(10);
v_gfcf_name VARCHAR2(50);
table_rate_m VARCHAR2(30);
table_rate VARCHAR2(30);
v_compare VARCHAR2(30);
output_run BOOLEAN;
upload_to_PK BOOLEAN;
view1 VARCHAR2(50);
view2 VARCHAR2(50);
view3 VARCHAR2(50);
output1 VARCHAR2(50);
output2 VARCHAR2(50);
output3 VARCHAR2(50);

gfcf_year_plus VARCHAR2(10);
elozetes_vegleges VARCHAR2(20);
gfcf_year NUMBER; 			 						-- a GFCF tábla import évszáma: forrása: schema_year
evszam NUMBER;  
schema_name VARCHAR2(5);

BEGIN

schema_name := 'PKD'|| SUBSTR(TO_CHAR(schema_year), 3) ||'';
DBMS_OUTPUT.PUT_LINE(schema_name);

IF 			running_method = 1 THEN gfcf_imp_alt := TRUE;	-- futtatjuk-e a GFCF importot, ha igen: TRUE, ha nem: FALSE
	ELSIF	running_method = 2 THEN pim_run := TRUE;		-- futtatjuk-e a PIM futást, ha igen: TRUE, ha nem: FALSE -- EGYEDI OUTPUT
	ELSIF	running_method = 3 THEN sector_unite := TRUE;	-- ha több szektorra futtatunk, akkor a végén összevonjuk-e a különböző táblákat egybe. Ha igen: TRUE, ha nem: FALSE -- FÉLOUTPUT
		ELSIF	running_method = 23 THEN pim_run := TRUE;
		ELSIF	running_method = 23 THEN sector_unite := TRUE;
	ELSIF	running_method = 4 THEN output_run := TRUE;		-- OUTPUT tábla futtatása - OUTPUT
	ELSIF	running_method = 5 THEN upload_to_PK := TRUE;
END IF;

-- IF 			version_to_run = 'v1' THEN gfcf_year := schema_year - 3; -- éles
	-- ELSIF	version_to_run = 'v2' THEN gfcf_year := schema_year - 2; -- éles
	-- ELSIF	version_to_run = 'v3' THEN gfcf_year := schema_year - 2; -- éles	
	-- ELSIF	version_to_run = 'v4' THEN gfcf_year := schema_year - 1; -- éles	

IF 			version_to_run = 'v1' THEN gfcf_year := schema_year - 2; -- teszt
	ELSIF	version_to_run = 'v2' THEN gfcf_year := schema_year - 2; -- teszt
	ELSIF	version_to_run = 'v3' THEN gfcf_year := schema_year - 2; -- teszt	
	ELSIF	version_to_run = 'v4' THEN gfcf_year := schema_year - 1; -- teszt	
	
	ELSIF	version_to_run = 'v5' AND update_year != 0 THEN gfcf_year := update_year;
	ELSIF	version_to_run = 'v5' AND update_year = 0 THEN DBMS_OUTPUT.PUT_LINE('v5 futás esetén meg kell adni a felülírandó évszámot is az update_year változóban');	
END IF;

evszam := inv2_run_from;
gfcf_year_plus := gfcf_year + 1;


-- INPUT ADATOK:
-- GFCF input táblák:								-- csak a gfcf_imp_alt futtatásnál használjuk, pim_run futtatásnál akár kikommentelhető
v_gfcf_table := 'C_IMP_GFCF_'|| gfcf_year ||'_ALAP';
v_gfcf_ar_table := 'C_IMP_GFCF_'|| gfcf_year_plus ||'_AR';

--GFCF módosított táblák:							-- csak a gfcf_imp_alt futtatásnál használjuk, pim_run futtatásnál akár kikommentelhető
v_gfcf_table_out := 'C_IMP_GFCF_'|| gfcf_year ||'';
v_gfcf_mod_table := 'C_IMP_GFCF_'|| gfcf_year ||'_MOD';

-- INV2 tábla:										-- gfcf_imp_alt és pim_run futtatásnál egyaránt használjuk
v_inv2_table := 'C_IMP_INV2_T08'; -- TELJES 

 -- LIFETIME tábla									-- pim_run futtatásnál használjuk csak, addig amíg a LT adataiban nem áll be változás
v_lifetime_table := 'C_IMP_LT_T08'; -- TELJES 

-- ÁRINDEX tábla									-- gfcf_imp_alt és pim_run futtatásnál egyaránt használjuk
v_arindex_1999 := 'C_IMP_AR_BAZIS_T08'; --  TELJES (S13 és S15-re)
v_arindex_lanc := 'C_IMP_AR_LANC_T08'; --  TELJES (S13 és S15-re)


-- EGYÉB táblák										-- csak a gfcf_imp_alt futtatásnál használjuk, pim_run futtatásnál akár kikommentelhető
table_rate_m := 'C_IMP_RATE_MACHINE'; -- RATE_MACHINE tábla neve
v_compare := 'C_IMP_COMPARE'; -- COMPARE tábla neve


-- TÁJÉK OUTPUT TÁBLÁK
view1 := 'OUTPUT_AG_ESZKOZ_VEKTOR';
view2 := 'OUTPUT_AG_ESZKOZ_VEKTOR';
view3 := 'OUTPUT_SZEKTOR_ESZKOZ_VEKTOR';
output1 := 'YH_GPK009_95AEV_V01';
output2 := 'YH_GPK010_95AEV_V01';
output3 := 'YH_GPK015_95AEV_V01';

DBMS_OUTPUT.PUT_LINE(v_gfcf_table);
DBMS_OUTPUT.PUT_LINE(v_gfcf_ar_table);
DBMS_OUTPUT.PUT_LINE(v_gfcf_table_out);


		CASE v_alszektor
			WHEN 'S1' THEN szekt := 'S1';
			WHEN 'S11' THEN szekt := 'S11';
			WHEN 'S12' THEN szekt := 'S12';
			WHEN 'S13' THEN szekt := 'S13';
			WHEN 'S14' THEN szekt := 'S14';
			WHEN 'S15' THEN szekt := 'S15';
			WHEN 'S1311' THEN szekt := 'S13';
			WHEN 'S1313' THEN szekt := 'S13';
			WHEN 'S1314' THEN szekt := 'S13';
			WHEN 'S1311a' THEN szekt := 'S13';
			WHEN 'S1313a' THEN szekt := 'S13';		
		END CASE;	

		CASE v_alszektor
			WHEN 'S1' THEN alszekt:= 'S1';
			WHEN 'S11' THEN alszekt:= 'S11';
			WHEN 'S12' THEN alszekt:= 'S12';
			WHEN 'S13' THEN alszekt:= 'S13';
			WHEN 'S14' THEN alszekt:= 'S14';
			WHEN 'S15' THEN alszekt:= 'S15';
			WHEN 'S1311' THEN alszekt := 'S1311';
			WHEN 'S1313' THEN alszekt := 'S1313';
			WHEN 'S1314' THEN alszekt := 'S1314';
			WHEN 'S1311a' THEN alszekt := 'S1311a';
			WHEN 'S1313a' THEN alszekt := 'S1313a';
		END CASE;	

		CASE v_eszkozcsp --GFCF táblában lévő fejléc megnevezések
			WHEN 'AN111' THEN eszkoz := 'LAKAS'; --S11,S1313,S14
			WHEN 'AN112' THEN eszkoz := 'EPULET'; --S11,S12,S1311,S1311a,S1313,S1313a,S1314,S14,S15
			WHEN 'AN114' THEN eszkoz := 'FEGYVER'; --S1311
			WHEN 'AN1123' THEN eszkoz := 'FOLDJAVITAS'; --S11,S1311,S1313,S14
			WHEN 'AN1171' THEN eszkoz := 'K_F'; --S11,S1311,S1311a,S15
			WHEN 'AN1174' THEN eszkoz := 'ORIGINALS'; --S1311a, S1313a
			WHEN 'AN1173o' THEN eszkoz := 'OWNSOFT'; --S11,S12,S1311,S14
			WHEN 'AN1139t' THEN eszkoz := 'TARTOSGEP'; --S11,S12,S1311,S1311a,S1313,S1313a,S1314,S14,S15
			WHEN 'AN1139g' THEN eszkoz := 'GYORSGEP'; --S11,S12,S1311,S1311a,S1313,S1313a,S1314,S14,
			WHEN 'AN1131' THEN eszkoz := 'JARMU';  --S11,S12,S1311,S1311a,S1313,S1313a,S1314,S14,S15
			WHEN 'AN1173s' THEN eszkoz := 'SZOFTVER'; -- --S11,S12,S1311,S1311a,S1313,S1313a,S1314
			WHEN 'AN1139k' THEN eszkoz := 'KISERTEKU'; 
			WHEN 'AN1131w' THEN eszkoz := 'WIZZ'; --S11
			WHEN 'AN1174t' THEN eszkoz := 'TCF'; --S11
			WHEN 'AN1174a' THEN eszkoz := 'EGYEB_ORIG'; --S11
			WHEN 'AN112n' THEN eszkoz := 'NOE6'; --S11
			WHEN 'AN115' THEN eszkoz := 'MEZO'; --S11,S1313,S14
			WHEN 'CLASSIC' THEN eszkoz := 'CLASSIC'; -- 5 klasszikus eszköz (AN112, AN1131, AN1139t, AN1139g, AN1173s)
			WHEN 'EGYEB' THEN eszkoz := 'EGYEB'; -- 5 klasszikus eszközön és lakás, mezőn kívül az összes (AN114, AN1123,AN1171, AN1174, AN1131w, AN1173o, AN1174t,AN1174a,AN112n)
		END CASE;

		CASE v_eszkozcsp -- GFCF_AR táblában lévő fejléc megnevezések
			WHEN 'AN111' THEN v_gfcf_name := 'EPITES'; -- lakás esetében az EPULET-et használjuk
			WHEN 'AN112' THEN v_gfcf_name := 'EPULET';
			WHEN 'AN112x' THEN v_gfcf_name := 'EPULET_BESOROLT';		
			WHEN 'AN112u' THEN v_gfcf_name := 'EPULET_UTAK_KORR';
			WHEN 'AN112p' THEN v_gfcf_name := 'EPULET_PPP_KORR';
			WHEN 'AN114' THEN v_gfcf_name := 'FEGYVER';
			WHEN 'AN1123' THEN v_gfcf_name := 'FOLDJAVITAS';
			WHEN 'AN1171' THEN v_gfcf_name := 'K_F';
			WHEN 'AN1174' THEN v_gfcf_name := 'ORIGINALS';
			WHEN 'AN1173o' THEN v_gfcf_name := 'OWNSOFT';	
			WHEN 'AN1173s' THEN v_gfcf_name := 'SZOFTVER'; 		
			WHEN 'AN1173sx' THEN v_gfcf_name := 'SZOFTVER_besorolt'; 				
			WHEN 'AN1139d' THEN v_gfcf_name := 'EGYEB'; 
			WHEN 'AN1139t' THEN v_gfcf_name := 'TARTOSGEP';  
			WHEN 'AN1139g' THEN v_gfcf_name := 'GYORSGEP';  
			WHEN 'AN1139tx' THEN v_gfcf_name := 'tgep_besorolt';
			WHEN 'AN1139gx' THEN v_gfcf_name := 'gygep_besorolt';	
			WHEN 'AN1131' THEN v_gfcf_name := 'JARMU'; 
			WHEN 'AN1131x' THEN v_gfcf_name := 'JARMU_besorolt'; 
			WHEN 'AN1139k' THEN v_gfcf_name := 'KISERTEKU'; 
			WHEN 'AN1131w' THEN v_gfcf_name := 'WIZZ'; 
			WHEN 'AN1174t' THEN v_gfcf_name := 'TCF'; 
			WHEN 'AN1174a' THEN v_gfcf_name := 'EGYEB_ORIG'; 
			WHEN 'AN112n' THEN v_gfcf_name := 'NOE6';
			WHEN 'AN115' THEN v_gfcf_name := 'MEZO';
			WHEN 'CLASSIC' THEN v_gfcf_name := 'CLASSIC'; -- 5 klasszikus eszköz (AN112, AN1131, AN1139g, AN1139t)
			WHEN 'EGYEB' THEN v_gfcf_name := 'EGYEB'; -- 5 klasszikus eszköz (AN112, AN1131, AN1139g, AN1139t)
		END CASE;

-- 1/A) GFCF import általános

IF 		(gfcf_imp_alt = TRUE AND (version_to_run = 'v2' OR version_to_run = 'v3' OR version_to_run = 'v4')) THEN
		CFC_IMPORT.gfcf_imp_alt(''|| gfcf_year ||'', ''|| v_gfcf_table ||'', ''|| v_gfcf_ar_table ||'', ''|| v_gfcf_table_out ||'', ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'', ''|| v_arindex_1999 ||'',  ''|| v_eszkozcsp ||'', ''|| v_gfcf_name ||'', ''|| v_alszektor ||'', ''|| eszkoz ||'', ''|| table_rate_m ||'', ''|| v_arindex_lanc ||'', ''|| v_compare ||'', ''|| schema_name ||'', ''|| version_to_run ||''); 
		DBMS_OUTPUT.put_line('GFCF import_alt lefutott');
		
ELSIF 	(gfcf_imp_alt = TRUE AND version_to_run = 'v1' OR version_to_run = 'v5') THEN
		CFC_IMPORT.gfcf_imp_valt(''|| v_gfcf_table_out ||'', ''|| schema_name ||'', ''|| v_gfcf_mod_table ||'', ''|| gfcf_year ||'', ''|| v_arindex_1999 ||'', ''|| v_inv2_table ||'', ''|| table_rate_m ||'', ''|| version_to_run ||''); 
		DBMS_OUTPUT.put_line('GFCF import_valt lefutott');		
	
ELSE 	DBMS_OUTPUT.put_line('nincs GFCF import');
END IF;


-- 2) PIM futtatás

IF pim_run = TRUE THEN 

	sql_statement := 'SELECT count(Y'|| gfcf_year ||') from '|| v_lifetime_table ||'';
	EXECUTE IMMEDIATE sql_statement INTO v;
	sql_statement := 'SELECT count(Y'|| gfcf_year ||') from '|| v_lifetime_table ||' WHERE Y'|| gfcf_year ||' IS NOT NULL';
	EXECUTE IMMEDIATE sql_statement INTO v1;		
	IF v = v1 THEN
	
		sql_statement := 'SELECT count(Y'|| gfcf_year_plus ||'_1999) from '|| v_arindex_1999 ||'';
		EXECUTE IMMEDIATE sql_statement INTO v;
		sql_statement := 'SELECT count(Y'|| gfcf_year_plus ||'_1999) from '|| v_arindex_1999 ||' WHERE Y'|| gfcf_year_plus ||'_1999 IS NOT NULL';
		EXECUTE IMMEDIATE sql_statement INTO v1;		
		IF v = v1 THEN
		
		IF ''|| version_to_run ||'' NOT IN ('v4', 'v5') THEN
		
			LOOP

				EXIT WHEN evszam > gfcf_year+1;
		
				act_year := ''|| evszam ||'';

				CFC.create_pim(''|| act_year ||'', ''|| szekt ||'', ''|| alszekt ||'', ''|| eszkoz ||'', ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'', ''|| v_arindex_1999 ||'', ''|| szekt ||'', ''|| v_eszkozcsp ||'', ''|| v_alszektor ||'', ''|| gfcf_year ||'', ''|| schema_name ||'');

				evszam := ''|| evszam ||'' + 1;
				
				commit;

			END LOOP;
			
				CFC_DELETE_NET_GRS.delete_rows(''|| szekt ||'', ''|| alszekt ||'', ''|| eszkoz ||'', ''|| v_eszkozcsp ||'');
				
			commit;
			
		ELSIF ''|| version_to_run ||'' = 'v4' THEN
		
			LOOP 
			
			EXIT WHEN evszam > gfcf_year;
					
				act_year := ''|| evszam ||'';

				CFC.create_pim(''|| act_year ||'', ''|| szekt ||'', ''|| alszekt ||'', ''|| eszkoz ||'', ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'', ''|| v_arindex_1999 ||'', ''|| szekt ||'', ''|| v_eszkozcsp ||'', ''|| v_alszektor ||'', ''|| gfcf_year ||'', ''|| schema_name ||'');

				evszam := ''|| evszam ||'' + 1;
				
				commit;

			END LOOP;	

		ELSIF ''|| version_to_run ||'' = 'v5' THEN
		
			LOOP 
			
			EXIT WHEN evszam > ''|| update_max_year ||'';
					
				act_year := ''|| evszam ||'';

				CFC.create_pim(''|| act_year ||'', ''|| szekt ||'', ''|| alszekt ||'', ''|| eszkoz ||'', ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'', ''|| v_arindex_1999 ||'', ''|| szekt ||'', ''|| v_eszkozcsp ||'', ''|| v_alszektor ||'', ''|| update_max_year ||'', ''|| schema_name ||'');

				evszam := ''|| evszam ||'' + 1;
				
				commit;

			END LOOP;	
				
		END IF;

			DBMS_OUTPUT.put_line('PIM lefutott');
			
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('Az akutális ÁR BÁZIS táblában nincsen mindenhol érték!');
		
		END IF;			
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('Az akutális LT táblában nincsen mindenhol érték!');
	
	END IF;	

ELSE DBMS_OUTPUT.put_line('nem volt PIM futás');
	
END IF;


-- végtáblák összefűzése

IF sector_unite = TRUE THEN

	SELECT COUNT(*) INTO v FROM all_tables where table_name = UPPER(''|| eszkoz ||'_'|| act_year ||'');

		if v=0 THEN

				EXECUTE IMMEDIATE'
				CREATE TABLE '|| eszkoz ||'_'|| act_year ||'
				("OUTPUT" VARCHAR2(5), "SZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR2" VARCHAR2(100 BYTE), "ESZKOZCSP" VARCHAR2(100 BYTE), "AGAZAT" VARCHAR2(30 BYTE),"EGYEB" VARCHAR2(30 BYTE), 
				"Y1780" NUMBER,	"Y1781" NUMBER ,	Y1782 NUMBER ,	Y1783 NUMBER,	Y1784 NUMBER,	Y1785 NUMBER,	Y1786 NUMBER,	Y1787 NUMBER,	Y1788 NUMBER,	Y1789 NUMBER,	Y1790 NUMBER,	Y1791 NUMBER,	Y1792 NUMBER,	Y1793 NUMBER,	Y1794 NUMBER,	Y1795 NUMBER,	Y1796 NUMBER,	Y1797 NUMBER,	Y1798 NUMBER,	Y1799 NUMBER,	Y1800 NUMBER,	Y1801 NUMBER,	Y1802 NUMBER,	Y1803 NUMBER,	Y1804 NUMBER,	Y1805 NUMBER,	Y1806 NUMBER,	Y1807 NUMBER,	Y1808 NUMBER,	Y1809 NUMBER,	Y1810 NUMBER,	Y1811 NUMBER,	Y1812 NUMBER,	Y1813 NUMBER,	Y1814 NUMBER,	Y1815 NUMBER,	Y1816 NUMBER,	Y1817 NUMBER,	Y1818 NUMBER,	Y1819 NUMBER,	Y1820 NUMBER,	Y1821 NUMBER,	Y1822 NUMBER,	Y1823 NUMBER,	Y1824 NUMBER,	Y1825 NUMBER,	Y1826 NUMBER,	Y1827 NUMBER,	Y1828 NUMBER,	Y1829 NUMBER,	Y1830 NUMBER,	Y1831 NUMBER,	Y1832 NUMBER,	Y1833 NUMBER,	Y1834 NUMBER,	Y1835 NUMBER,	Y1836 NUMBER,	Y1837 NUMBER,	Y1838 NUMBER,	Y1839 NUMBER,	Y1840 NUMBER,	Y1841 NUMBER,	Y1842 NUMBER,	Y1843 NUMBER,	Y1844 NUMBER,	Y1845 NUMBER,	Y1846 NUMBER,	Y1847 NUMBER,	Y1848 NUMBER,	Y1849 NUMBER,	Y1850 NUMBER,	Y1851 NUMBER,	Y1852 NUMBER,	Y1853 NUMBER,	Y1854 NUMBER,	Y1855 NUMBER,	Y1856 NUMBER,	Y1857 NUMBER,	Y1858 NUMBER,	Y1859 NUMBER,	Y1860 NUMBER,	Y1861 NUMBER,	Y1862 NUMBER,	Y1863 NUMBER,	Y1864 NUMBER,	Y1865 NUMBER,	Y1866 NUMBER,	Y1867 NUMBER,	Y1868 NUMBER,	Y1869 NUMBER,	Y1870 NUMBER,	Y1871 NUMBER,	Y1872 NUMBER,	Y1873 NUMBER,	Y1874 NUMBER,	Y1875 NUMBER,	Y1876 NUMBER,	Y1877 NUMBER,	Y1878 NUMBER,	Y1879 NUMBER,	Y1880 NUMBER,	Y1881 NUMBER,	Y1882 NUMBER,	Y1883 NUMBER,	Y1884 NUMBER,	Y1885 NUMBER,	Y1886 NUMBER,	Y1887 NUMBER,	Y1888 NUMBER,	Y1889 NUMBER,	Y1890 NUMBER,	Y1891 NUMBER,	Y1892 NUMBER,	Y1893 NUMBER,	Y1894 NUMBER,	Y1895 NUMBER,	Y1896 NUMBER,	Y1897 NUMBER,	Y1898 NUMBER,	Y1899 NUMBER,

				"Y1900" NUMBER, "Y1901" NUMBER, "Y1902" NUMBER, "Y1903" NUMBER, "Y1904" NUMBER, "Y1905" NUMBER, "Y1906" NUMBER, "Y1907" NUMBER, "Y1908" NUMBER, "Y1909" NUMBER, "Y1910" NUMBER, "Y1911" NUMBER, "Y1912" NUMBER, "Y1913" NUMBER, "Y1914" NUMBER, "Y1915" NUMBER, "Y1916" NUMBER, "Y1917" NUMBER, "Y1918" NUMBER, "Y1919" NUMBER, "Y1920" NUMBER, "Y1921" NUMBER, "Y1922" NUMBER, "Y1923" NUMBER, "Y1924" NUMBER, "Y1925" NUMBER, "Y1926" NUMBER, "Y1927" NUMBER, "Y1928" NUMBER, "Y1929" NUMBER, "Y1930" NUMBER, "Y1931" NUMBER, "Y1932" NUMBER, "Y1933" NUMBER, "Y1934" NUMBER, "Y1935" NUMBER, "Y1936" NUMBER, "Y1937" NUMBER, "Y1938" NUMBER, "Y1939" NUMBER, "Y1940" NUMBER, "Y1941" NUMBER, "Y1942" NUMBER, "Y1943" NUMBER, "Y1944" NUMBER, "Y1945" NUMBER, "Y1946" NUMBER, "Y1947" NUMBER, "Y1948" NUMBER, "Y1949" NUMBER, "Y1950" NUMBER, "Y1951" NUMBER, "Y1952" NUMBER, "Y1953" NUMBER, "Y1954" NUMBER, "Y1955" NUMBER, "Y1956" NUMBER, "Y1957" NUMBER, "Y1958" NUMBER, "Y1959" NUMBER, "Y1960" NUMBER, "Y1961" NUMBER, "Y1962" NUMBER, "Y1963" NUMBER, "Y1964" NUMBER, "Y1965" NUMBER, "Y1966" NUMBER, "Y1967" NUMBER, "Y1968" NUMBER, "Y1969" NUMBER, "Y1970" NUMBER, "Y1971" NUMBER, "Y1972" NUMBER, "Y1973" NUMBER, "Y1974" NUMBER, "Y1975" NUMBER, "Y1976" NUMBER, "Y1977" NUMBER, "Y1978" NUMBER, "Y1979" NUMBER, "Y1980" NUMBER, "Y1981" NUMBER, "Y1982" NUMBER, "Y1983" NUMBER, "Y1984" NUMBER, "Y1985" NUMBER, "Y1986" NUMBER, "Y1987" NUMBER, "Y1988" NUMBER, "Y1989" NUMBER, "Y1990" NUMBER, "Y1991" NUMBER, "Y1992" NUMBER, "Y1993" NUMBER, "Y1994" NUMBER, "Y1995" NUMBER, "Y1996" NUMBER, "Y1997" NUMBER, "Y1998" NUMBER, "Y1999" NUMBER, "Y2000" NUMBER, "Y2001" NUMBER, "Y2002" NUMBER, "Y2003" NUMBER, "Y2004" NUMBER, "Y2005" NUMBER, "Y2006" NUMBER, "Y2007" NUMBER, "Y2008" NUMBER, "Y2009" NUMBER, "Y2010" NUMBER, "Y2011" NUMBER, "Y2012" NUMBER, "Y2013" NUMBER, "Y2014" NUMBER, "Y2015" NUMBER, "Y2016" NUMBER, "Y2017" NUMBER, "Y2018" NUMBER, "YSUM_99" NUMBER,  "YSUM_F" NUMBER, "YSUM_V" NUMBER)
				'
				;

		END IF;

	IF ''|| version_to_run ||'' NOT IN ('v4', 'v5') THEN
		
		LOOP 
			EXIT WHEN evszam > gfcf_year+1;

			act_year := ''|| evszam ||'';
			DBMS_OUTPUT.put_line(act_year);

			CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', ''|| szekt ||'', ''||v_alszektor ||'', ''|| v_eszkozcsp ||'', ''|| schema_name ||'');

			evszam := ''|| evszam ||'' + 1;

		END LOOP;
	
	ELSIF ''|| version_to_run ||'' = 'v4' THEN

		LOOP 
			EXIT WHEN evszam > gfcf_year;

			act_year := ''|| evszam ||'';
			DBMS_OUTPUT.put_line(act_year);

			CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', ''|| szekt ||'', ''||v_alszektor ||'', ''|| v_eszkozcsp ||'', ''|| schema_name ||'');

			evszam := ''|| evszam ||''+ 1;

		END LOOP;

	ELSIF ''|| version_to_run ||'' = 'v5' THEN

		LOOP 
			EXIT WHEN evszam > ''|| update_max_year ||'';

			act_year := ''|| evszam ||'';
			DBMS_OUTPUT.put_line(act_year);

			CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', ''|| szekt ||'', ''||v_alszektor ||'', ''|| v_eszkozcsp ||'', ''|| schema_name ||'');

			evszam := ''|| evszam ||''+ 1;

		END LOOP;
		
		
	END IF;

DBMS_OUTPUT.put_line('Unite lefutott');
ELSE DBMS_OUTPUT.put_line('nem volt unite');
END IF;

IF output_run = TRUE THEN

	CFC_OUTPUT_NEW.CFC_OUTPUT_NEW(''|| szekt ||'', ''|| v_alszektor ||'', ''|| output_year ||'');

DBMS_OUTPUT.put_line('OUTPUT lefutott');
ELSE DBMS_OUTPUT.put_line('nem volt OUTPUT');

END IF;

IF upload_to_PK = TRUE THEN

	CFC_UPLOAD.CFC_UPLOAD(''|| view1 ||'', ''|| view2 ||'', ''|| view3 ||'', ''|| output1 ||'', ''|| output2 ||'', ''|| output3 ||'', ''|| pk_up_max_year ||'');
	DBMS_OUTPUT.put_line('UPLOAD lefutott');

END IF;



EXCEPTION -- log táblába is írjunk!
when is_data then
		dbms_output.put_line('A tábla nem üres!');
		record_error(procName);
when no_data_found then
        dbms_output.put_line('Nincs adat');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
		record_error(procName);
when too_many_rows then
        dbms_output.put_line('Túl sok a sor');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
		record_error(procName);
when others then
        dbms_output.put_line('Előre nem várt hiba');
        dbms_output.put_line(sqlcode || ' ---> ' || sqlerrm);
		record_error(procName);
		RAISE;

END;