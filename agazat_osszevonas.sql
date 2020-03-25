create or replace PROCEDURE agazat_osszevonas(agazat_cel VARCHAR2, agazatok_sum VARCHAR2, agazatok_nullra VARCHAR2, v_out_table VARCHAR2, v_out_eszkcsp VARCHAR2, F_V_99a VARCHAR2, F_V_99 VARCHAR2, v_szektorok VARCHAR2, v_out_eszkcsp_c VARCHAR2, v_out_cfc VARCHAR2, v_in_year VARCHAR2) AS

BEGIN					
							
		EXECUTE IMMEDIATE'
		UPDATE PKD19.'|| v_out_table ||'
		SET '|| v_out_eszkcsp ||' = 
		(SELECT ROUND(SUM(NVL('|| F_V_99a ||', 0))) FROM PKD19.'|| v_out_eszkcsp ||'_'|| v_in_year ||' a
		WHERE a.AGAZAT IN ('|| agazatok_sum ||') AND a.ALSZEKTOR = '''|| v_szektorok ||''' AND a.ESZKOZCSP = '''|| v_out_eszkcsp_c ||''' AND a.OUTPUT = '''|| v_out_cfc ||''')
		WHERE AGAZAT = '''|| agazat_cel ||''' AND ALSZEKTOR = '''|| v_szektorok ||''' AND CFC_NET_GRS = '''|| v_out_cfc ||''' AND EV = '''|| v_in_year ||''' AND F_V_99 = '''|| F_V_99 ||''' 
		'
		;	
		
		COMMIT;
		
		EXECUTE IMMEDIATE'
		UPDATE PKD19.'|| v_out_table ||'
		SET '|| v_out_eszkcsp ||' = ''0''
		WHERE AGAZAT IN ('|| agazatok_nullra ||') AND ALSZEKTOR = '''|| v_szektorok ||''' AND CFC_NET_GRS = '''|| v_out_cfc ||''' AND EV = '''|| v_in_year ||''' AND F_V_99 = '''|| F_V_99 ||'''							
		'
		;
		
		COMMIT;
		
		
END;