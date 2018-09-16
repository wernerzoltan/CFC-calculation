-- GFCF import

procedure cfc_epulet_korm_kozp(AKT_EV VARCHAR2) AS    
procName VARCHAR2(30);

BEGIN

procName := 'GFCF to INV2';
 
-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'STARTING', '');
 
PKD.truncate_table(''|| v_gfcf_out_01 ||'');


	--> 1. lépés: a GFCF táblából átszedjük a szükséges mezőket

	EXECUTE IMMEDIATE ' 
	INSERT INTO '|| v_out_schema ||'.'|| v_gfcf_out_01 ||'
	('|| v_imp_tabl_ep_korm_kozp ||')
	SELECT 
	'|| v_imp_tabl_ep_korm_kozp ||'
	FROM '|| v_out_schema ||'.'|| v_imp_gfcf ||'
	'
	; 
		
	EXECUTE IMMEDIATE ' 
	UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_01 ||'
	SET szektor = '|| v_szektor_korm_kozp ||' 
	'
	;
	
	EXECUTE IMMEDIATE ' 
	UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_01 ||'
	SET eszkozcsp = '|| v_eszkozcsp_korm_kozp ||' 
	'
	;
	
	--< 

	--> 2. lépés: kiszámoljuk a count_szoroz mező értékét (épület / kormányzat esetén kell)

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate count_szoroz', '');
		
	FOR i IN 1..V_AGAZAT.COUNT LOOP  

		EXECUTE IMMEDIATE '
		UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_01 ||'
		SET count_szoroz = 
	--	(SELECT (EPULET + (HASZNALT_EPULET_VASARLAS * 0.04) + (EPULET_ATVET * 0.04) + EPULET_PENZUGYI_LIZING)
	
	
		FROM '|| v_out_schema ||'.'|| v_gfcf_out_01 ||'
		WHERE AGAZAT = '''|| V_AGAZAT(i) ||''')
		WHERE AGAZAT = '''|| V_AGAZAT(i) ||'''
		'
		; 
		-- a lakás jelenleg hiányzik, ezt pótolni kell majd a következő módon: SELECT (EPULET + (HASZNALT_EPULET_VASARLAS * 0,04) + (EPULET_ATVET * 0,04) - LAKAS + EPULET_PENZUGYI_LIZING) 
	END LOOP;
	
	--<
				
	--> 3. lépés: 1999-es árra történő átszámítás

-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Calculate 1999 price', '');
	
	FOR j IN 1..V_AGAZAT.COUNT LOOP  

		EXECUTE IMMEDIATE ' 
		UPDATE '|| v_out_schema ||'.'|| v_gfcf_out_01 ||'
		SET count_szoroz_1999 = 
		(SELECT 
			CASE b.Y'|| AKT_EV ||'_1999
				WHEN 0 THEN a.count_szoroz
				ELSE a.count_szoroz / b.Y'|| AKT_EV ||'_1999 
			END as count_szoroz_1999
		
		FROM '|| v_out_schema ||'.'|| v_gfcf_out_01 ||' a
		INNER JOIN '|| v_out_schema ||'.'|| v_arindex_1999 ||' b
		ON a.AGAZAT = b. AGAZAT
		WHERE a.AGAZAT = '''|| V_AGAZAT(j) ||'''
		AND b.SZEKTOR = '|| v_szektor_korm_kozp ||' AND b.ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||'
		)
		WHERE AGAZAT = '''|| V_AGAZAT(j) ||'''
		'
		; 
	
	END LOOP;
	
	--<
	
	--> 4.lépés: meglévő INV2 táblába történő beillesztés
	
-- log
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'Put in INV2', '');
		
	FOR k IN 1..V_AGAZAT.COUNT LOOP  
	
		EXECUTE IMMEDIATE '
		UPDATE '|| v_out_schema ||'.'|| v_inv2_table ||'
		SET Y2015 =
		(SELECT COUNT_SZOROZ_1999 
		FROM '|| v_out_schema ||'.'|| v_gfcf_out_01 ||' a
		WHERE a.AGAZAT = '''|| V_AGAZAT(k) ||''' 
		AND a.SZEKTOR = '|| v_szektor_korm_kozp ||' AND a.ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||'
		)
		WHERE AGAZAT2 = '''|| V_AGAZAT(k) ||''' AND SZEKTOR = '|| v_szektor_korm_kozp ||' AND ESZKOZCSP = '|| v_eszkozcsp_korm_kozp ||'
		'
		;
		
	
		
	END LOOP;
		
	--<	
INSERT INTO logging (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'END', '');

-- error case	
EXCEPTION WHEN OTHERS THEN
record_error(procName);
RAISE;
	
END cfc_epulet_korm_kozp;


