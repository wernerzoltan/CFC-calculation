create or replace PROCEDURE szektor_modositas(agazat_cel VARCHAR2, v_out_table VARCHAR2, v_out_eszkcsp VARCHAR2, F_V_99 VARCHAR2, v_szektorok VARCHAR2, v_out_cfc VARCHAR2, v_in_year VARCHAR2, v NUMBER) AS

BEGIN		

	EXECUTE IMMEDIATE'
	UPDATE PKD.'|| v_out_table ||'
	SET '|| v_out_eszkcsp ||' = '|| v ||'
	WHERE AGAZAT = '''|| agazat_cel ||''' AND ALSZEKTOR = '''|| v_szektorok	||''' AND CFC_NET_GRS = '''|| v_out_cfc ||''' AND F_V_99 = '''|| F_V_99 ||''' AND EV = '''|| v_in_year ||'''
	'
	;	
	
	COMMIT;
	
END;