/*

create or replace PACKAGE CFC_UPLOAD AUTHID CURRENT_USER AS 
procedure CFC_UPLOAD(view1 VARCHAR2, view2 VARCHAR2, view3 VARCHAR2, output1 VARCHAR2, output2 VARCHAR2, output3 VARCHAR2, pk_up_max_year NUMBER);
END CFC_UPLOAD;

-------
*/

create or replace PACKAGE BODY CFC_UPLOAD AS 

procedure CFC_UPLOAD(view1 VARCHAR2, view2 VARCHAR2, view3 VARCHAR2, output1 VARCHAR2, output2 VARCHAR2, output3 VARCHAR2, pk_up_max_year NUMBER) AS
v1 NUMERIC;
v2 NUMERIC;
v3 NUMERIC;
sql_command VARCHAR2(200);
procName VARCHAR2(30);

BEGIN

procName := 'CFC_UPLOAD';

INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'START', '');

	sql_command := 'SELECT COUNT(*) FROM PK.'|| output1 ||'';
	EXECUTE IMMEDIATE sql_command INTO v1;
	
	sql_command := 'SELECT COUNT(*) FROM PK.'|| output2 ||'';
	EXECUTE IMMEDIATE sql_command INTO v2;
	
	sql_command := 'SELECT COUNT(*) FROM PK.'|| output3 ||'';
	EXECUTE IMMEDIATE sql_command INTO v3;
	
	IF v1 > 0 OR v2 > 0 OR v3 > 0 THEN 

		DBMS_OUTPUT.PUT_LINE('A PK adatbázis táblák nem üresek! Első körben el kell azokat menteni, majd tartalmukat törölni szükséges!');
	
	ELSE

 		EXECUTE IMMEDIATE'
		INSERT INTO PK.'|| output1 ||' (TEV, MP102, M0691, MP101, PKAA270) 
		(SELECT * FROM (SELECT EV, MP102, 
		CASE AG
			WHEN ''Total'' THEN ''==''
			ELSE AG
		END,
		CASE F_V_99
			WHEN ''F'' THEN ''1''
			ELSE ''2''
		END,
		ERTEK 
		FROM PKD19.'|| view1 ||'
		WHERE CFC_NET_GRS = ''net''
		AND F_V_99 IN (''F'', ''V'')
		AND EV <= '|| pk_up_max_year ||'))
		'
		;

	 	EXECUTE IMMEDIATE'
		INSERT INTO PK.'|| output2 ||' (TEV, MP102, M0691, MP101, PKAA271) 
		(SELECT EV, MP102, 
		CASE AG
			WHEN ''Total'' THEN ''==''
			ELSE AG
		END,
		CASE F_V_99
			WHEN ''F'' THEN ''1''
			ELSE ''2''
		END,
		ERTEK 
		FROM PKD19.'|| view2 ||'
		WHERE CFC_NET_GRS = ''grs''
		AND F_V_99 IN (''F'', ''V'')
		AND EV <= '|| pk_up_max_year ||')
		'
		;

		EXECUTE IMMEDIATE'
		INSERT INTO PK.'|| output3 ||' (TEV, MP102, MP101, MP65, PKAA270, PKAA271) 
		(SELECT a.EV, a.MP102, 
		CASE a.F_V_99
			WHEN ''F'' THEN ''1''
			ELSE ''2''
		END,
		a.SZEKTOR, a.ERTEK, b.ERTEK
		FROM PKD19.'|| view3 ||' a INNER JOIN PKD19.'|| view3 ||' b
		ON a.EV = b.EV AND a.F_V_99 = b.F_V_99 AND a.SZEKTOR = b.SZEKTOR AND a.MP102 = b.MP102
		WHERE a.CFC_NET_GRS = ''net'' AND b.CFC_NET_GRS = ''grs''
		AND a.F_V_99 IN (''F'', ''V'')
		AND a.EV <= '|| pk_up_max_year ||')
		'
		;
		
		commit;

	END IF; 


INSERT INTO PKD19.LOGGING (created_on, info, proc_name, message, backtrace)
VALUES (TO_CHAR(CURRENT_TIMESTAMP, 'YYYY.MM.DD HH24:MI:SS.FF'), 'Info', ''|| procName ||'', 'STOP', '');	
	
END CFC_UPLOAD;

END;