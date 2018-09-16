-- PIM futtatás

PROCEDURE cfc_epulet_korm_kozp_pim(AKT_EV VARCHAR2) AS

procName VARCHAR2(30);
act_year VARCHAR2(30); 

BEGIN

procName := 'Start_PIM';
act_year := ''|| AKT_EV ||'' + 1; -- a CFC számolásnál szükséges, amikor visszaszámolunk aktuális árra (ellentétben a NET és GRS számolással, itt nem az aktuális évre, hanem aktuális + 1 évre számolunk)

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'STARTING', '');

	--> 5.lépés: PIM futtatása

		-- létrehozzuk a sorokat ágazatok szerint, feltöltjük a szükséges mezőértékekkel
		
	FOR a IN 1..v_pim_korm_kozp.COUNT LOOP 
	
	 PKD.drop_table(''|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'');

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Create '|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'', '');
	
		EXECUTE IMMEDIATE'
		CREATE TABLE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
		("SZEKTOR" VARCHAR2(100 BYTE), 
			"ALSZEKTOR1" VARCHAR2(100 BYTE), 
			"ALSZEKTOR2" VARCHAR2(100 BYTE), 
			"ESZKOZCSP" VARCHAR2(100 BYTE), 
			"AGAZAT" VARCHAR2(30 BYTE), 
			"ALAGAZAT" VARCHAR2(30 BYTE), 
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
			"Y2016" NUMBER, 
	
			"YSUM" NUMBER,  
			"YSUM_AKT" NUMBER
		   ) SEGMENT CREATION IMMEDIATE 
		  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
		  NOCOMPRESS LOGGING
		  STORAGE(INITIAL 81920 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
		  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
		  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
		  TABLESPACE "PKC" 
		'
		;
	

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate PIM', '');
	
	
		FOR l IN 1..V_AGAZAT_PIM.COUNT LOOP
			
			EXECUTE IMMEDIATE'
			INSERT INTO '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
			(SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT)
			SELECT SZEKTOR, ALSZEKTOR1, ESZKOZCSP, AGAZAT, ALAGAZAT
			FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
			WHERE SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' AND AGAZAT = '|| V_AGAZAT_PIM(l) ||' 
			'
			;

		
		-- a létrehozott ágazatokhoz hozzászámoljuk a PIM értékeket
			 FOR m IN 1..116 LOOP -- az adott évig kell, ezt minden futásnál módosítani kell!
						
				CASE
				
				-- NET és GRS esetén adott évre (AKT_EV) számolunk
				
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_kozp_net' THEN
				-- WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_onk_net' THEN 
				WHEN ''|| v_pim_korm_kozp(a) ||'' = 'fegyver_net' THEN  
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
				SET Y'|| V_YEARS(m) ||' = (SELECT (Y'|| V_YEARS(m) ||' * (SELECT ERTEK FROM '|| V_PIM_INPUT(a) ||'
				WHERE EV = ('|| AKT_EV ||' - '|| V_YEARS(m) ||') 
				AND LIFETIME = (SELECT Y'|| V_YEARS(m) ||' FROM '|| v_out_schema ||'.'|| v_lifetime_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_PIM(l) ||' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' )))
				FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_PIM(l) ||' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||')
				WHERE SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' AND AGAZAT = '|| V_AGAZAT_PIM(l) ||'
				'
				;
				
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_kozp_grs' THEN
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_onk_grs' THEN
				WHEN ''|| v_pim_korm_kozp(a) ||'' = 'fegyver_grs' THEN  
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
				SET Y'|| V_YEARS(m) ||' = (SELECT (Y'|| V_YEARS(m) ||' * (SELECT ERTEK FROM '|| V_PIM_INPUT(a) ||'
				WHERE EV = ('|| AKT_EV ||' - '|| V_YEARS(m) ||') 
				AND LIFETIME = (SELECT Y'|| V_YEARS(m) ||' FROM '|| v_out_schema ||'.'|| v_lifetime_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_PIM(l) ||' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' )))
				FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_PIM(l) ||' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||')
				WHERE SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' AND AGAZAT = '|| V_AGAZAT_PIM(l) ||'
				'
				;
				
				-- CFC esetén adott év+1-el számolunk (AKT_EV + 1)
				
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_kozp_cfc' THEN
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_onk_cfc' THEN
				WHEN ''|| v_pim_korm_kozp(a) ||'' = 'fegyver_cfc' THEN  
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
				SET Y'|| V_YEARS(m) ||' = (SELECT (Y'|| V_YEARS(m) ||' * (SELECT ERTEK FROM '|| V_PIM_INPUT(a) ||'
				WHERE EV = ('|| AKT_EV ||'+1 - '|| V_YEARS(m) ||') 
				AND LIFETIME = (SELECT Y'|| V_YEARS(m) ||' FROM '|| v_out_schema ||'.'|| v_lifetime_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_PIM(l) ||' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' )))
				FROM '|| v_out_schema ||'.'|| v_inv2_table ||'
				WHERE AGAZAT = '|| V_AGAZAT_PIM(l) ||' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||')
				WHERE SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||' AND AGAZAT = '|| V_AGAZAT_PIM(l) ||'
				'
				;
									
				END CASE;
				
			END LOOP;
				
		END LOOP;
		
		
		-- 6.lépés: összeadjuk az eredményeket és sum mezőbe elmentjük

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate SUM', '');
		
		FOR n IN 1..V_AGAZAT_PIM.COUNT LOOP  
	
			EXECUTE IMMEDIATE'
			UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
			SET YSUM = 
			(SELECT '|| v_pim_sum ||' FROM '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
			WHERE AGAZAT = '|| V_AGAZAT_PIM(n) ||')
			WHERE AGAZAT = '|| V_AGAZAT_PIM(n) ||'
			'
			;
					
		
		END LOOP;
		

		-- 7.lépés: aktuális évre számolunk árindexet (1999-ről vissza)

		-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate actual price', '');		

		FOR o IN 1..V_AGAZAT_PIM.COUNT LOOP 
		
			CASE
				
				-- NET és GRS esetén adott évvel szorzunk
				
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_kozp_net' THEN 
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_onk_net' THEN 
				WHEN ''|| v_pim_korm_kozp(a) ||'' = 'fegyver_net' THEN  
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
				SET YSUM_AKT = (SELECT a.YSUM * b.Y'|| AKT_EV ||'_1999 as YSUM_AKT
				FROM '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||' a
				INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
				ON a.AGAZAT = b. AGAZAT
				WHERE a.AGAZAT = '|| V_AGAZAT_PIM(o) ||'
				AND b.SZEKTOR = '|| v_szektor_korm_kozp ||' AND b.ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||')
				WHERE AGAZAT = '|| V_AGAZAT_PIM(o) ||'
				'
				;
				
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_kozp_grs' THEN
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_onk_grs' THEN
				WHEN ''|| v_pim_korm_kozp(a) ||'' = 'fegyver_grs' THEN  
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
				SET YSUM_AKT = (SELECT a.YSUM * b.Y'|| AKT_EV ||'_1999 as YSUM_AKT
				FROM '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||' a
				INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
				ON a.AGAZAT = b. AGAZAT
				WHERE a.AGAZAT = '|| V_AGAZAT_PIM(o) ||'
				AND b.SZEKTOR = '|| v_szektor_korm_kozp ||' AND b.ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||')
				WHERE AGAZAT = '|| V_AGAZAT_PIM(o) ||'
				'
				;
				
				-- CFC esetén adott év+1-el szorzunk
				
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_kozp_cfc' THEN
				--WHEN ''|| v_pim_korm_kozp(a) ||'' = 'ep_korm_onk_cfc' THEN
				WHEN ''|| v_pim_korm_kozp(a) ||'' = 'fegyver_cfc' THEN  
				EXECUTE IMMEDIATE'
				UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
				SET YSUM_AKT = (SELECT a.YSUM * b.Y'|| act_year ||'_1999 as YSUM_AKT
				FROM '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||' a
				INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
				ON a.AGAZAT = b. AGAZAT
				WHERE a.AGAZAT = '|| V_AGAZAT_PIM(o) ||'
				AND b.SZEKTOR = '|| v_szektor_korm_kozp ||' AND b.ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||')
				WHERE AGAZAT = '|| V_AGAZAT_PIM(o) ||'
				'
				;
				
				END CASE;
		
		END LOOP;
		
		
		--8. lépés készítünk egy végleges SUM értéket az ágazatok összesenről

		-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate price SUM', '');
		
	EXECUTE IMMEDIATE'
		INSERT INTO '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
		(szektor, eszkozcsp, agazat, YSUM)
		SELECT '|| v_szektor_korm_kozp ||', '|| v_eszkozcsp_korm_kozp ||', ''SUM'', sum(YSUM)
		FROM '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
		WHERE szektor = '|| v_szektor_korm_kozp ||' AND eszkozcsp = '|| v_eszkozcsp_korm_kozp ||'
		GROUP BY szektor, eszkozcsp
		
		'
		;
		
	EXECUTE IMMEDIATE'
		UPDATE '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
		SET YSUM_AKT = (SELECT sum(YSUM_AKT)
		FROM '|| v_out_schema ||'.'|| v_pim_korm_kozp(a) ||'_'|| AKT_EV ||'
		WHERE szektor = '|| v_szektor_korm_kozp ||' AND eszkozcsp = '|| v_eszkozcsp_korm_kozp ||'
		GROUP BY szektor, eszkozcsp		
		)
		WHERE szektor = '|| v_szektor_korm_kozp ||' AND eszkozcsp = '|| v_eszkozcsp_korm_kozp ||' AND AGAZAT = ''SUM''
		'
		;
		
	END LOOP;

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'END', '');

-- error case	
EXCEPTION WHEN OTHERS THEN
record_error(procName);
RAISE;


END cfc_epulet_korm_kozp_pim;
