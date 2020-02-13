create or replace PROCEDURE agazat_osszevonas_nk(agazat_cel VARCHAR2, agazatok_sum VARCHAR2, agazatok_nullra VARCHAR2, v_out_table VARCHAR2, v_out_nk_eszkcsp VARCHAR2, F_V_99 VARCHAR2, v_szektorok VARCHAR2, v_out_cfc VARCHAR2, v_in_year VARCHAR2) AS

BEGIN					
							
		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_out_table ||'
		SET PKD.'|| v_out_nk_eszkcsp ||' = 
		(SELECT ROUND(SUM(NVL('|| v_out_nk_eszkcsp ||',0))) FROM PKD.'|| v_out_table ||' a
		WHERE a.AGAZAT IN ('|| agazatok_sum ||') AND a.ALSZEKTOR = '''|| v_szektorok ||''' AND a.CFC_NET_GRS = '''|| v_out_cfc ||''' AND a.F_V_99 = '''|| F_V_99 ||''' AND EV = '''|| v_in_year ||''')
		WHERE AGAZAT = '''|| agazat_cel ||''' AND ALSZEKTOR = '''|| v_szektorok ||''' AND EV = '''|| v_in_year ||''' AND F_V_99 = '''|| F_V_99 ||''' AND CFC_NET_GRS = '''|| v_out_cfc ||'''
		'
		;	
		
		COMMIT;

		EXECUTE IMMEDIATE'
		UPDATE PKD.'|| v_out_table ||'
		SET '|| v_out_nk_eszkcsp ||' = ''0''
		WHERE AGAZAT IN ('|| agazatok_nullra ||') AND ALSZEKTOR = '''|| v_szektorok ||''' AND EV = '''|| v_in_year ||''' AND F_V_99 = '''|| F_V_99 ||''' AND CFC_NET_GRS = '''|| v_out_cfc ||'''					
		'
		;
		
		COMMIT;
		
		
END;