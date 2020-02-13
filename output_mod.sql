create or replace PROCEDURE OUTPUT_MOD AUTHID CURRENT_USER AS

v_out_table_mod VARCHAR2(50);
v_table_diff VARCHAR2(50);
sql_statement VARCHAR2(5000);
v NUMERIC;

TYPE t_szektorok IS TABLE OF VARCHAR2(20); 
v_szektorok t_szektorok; 

TYPE t_agazatok IS TABLE OF VARCHAR2(20); 
v_agazatok t_agazatok; 

TYPE t_FV IS TABLE OF VARCHAR2(20); 
v_FV t_FV;

TYPE t_evek IS TABLE OF VARCHAR2(20); 
v_evek t_evek;

BEGIN

v_out_table_mod := 'C_OUTPUT_FINAL';
v_table_diff := 'C_OUTPUT_DIFF';

sql_statement := 'SELECT DISTINCT ALSZEKTOR FROM PKD.'|| v_table_diff ||'';
EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_szektorok;

FOR a IN v_szektorok.FIRST..v_szektorok.LAST LOOP

	sql_statement := 'SELECT DISTINCT AGAZAT FROM PKD.'|| v_table_diff ||' 
	WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' ';
	EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazatok;

	FOR b IN v_agazatok.FIRST..v_agazatok.LAST LOOP

		sql_statement := 'SELECT DISTINCT F_V_99 FROM PKD.'|| v_table_diff ||' 
		WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||''' ';
		EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_FV;		

			FOR c IN v_FV.FIRST..v_FV.LAST LOOP

				sql_statement := 'SELECT DISTINCT EV FROM PKD.'|| v_table_diff ||' 
				WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
				AND F_V_99 = '''|| v_FV(c) ||''' ';
				EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_evek;

					FOR d IN v_evek.FIRST..v_evek.LAST LOOP

						sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_out_table_mod ||' 
						WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc''';
						EXECUTE IMMEDIATE sql_statement INTO v;

						IF v > 0 THEN

						EXECUTE IMMEDIATE'
						UPDATE PKD.'|| v_out_table_mod ||'
						SET EPULET = 
						(SELECT NVL(EPULET, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(EPULET, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						JARMU = 
						(SELECT NVL(JARMU, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(JARMU, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						GYORSGEP = 
						(SELECT NVL(GYORSGEP, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(GYORSGEP, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						TARTOSGEP = 
						(SELECT NVL(TARTOSGEP, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(TARTOSGEP, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						SZOFTVER = 
						(SELECT NVL(SZOFTVER, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(SZOFTVER, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						FEGYVER = 
						(SELECT NVL(FEGYVER, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(FEGYVER, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						K_F = 
						(SELECT NVL(K_F, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(K_F, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						ORIGINALS = 
						(SELECT NVL(ORIGINALS, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(ORIGINALS, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						
						FOLDJAVITAS = 
						(SELECT NVL(FOLDJAVITAS, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(FOLDJAVITAS, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),

						OWNSOFT = 
						(SELECT NVL(OWNSOFT, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(OWNSOFT, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),						
						
						SUM_CLASSIC = 
						(SELECT NVL(SUM_CLASSIC, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(SUM_CLASSIC, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||'''),
						SUM_ALL = 
						(SELECT NVL(SUM_ALL, 0) FROM PKD.'|| v_out_table_mod ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc'') + (SELECT NVL(SUM_ALL, 0) FROM PKD.'|| v_table_diff ||' WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''')

						WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = '''|| v_agazatok(b) ||'''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc''
						'
						;		

						-- SUM mező újraszámítása
						EXECUTE IMMEDIATE'
						UPDATE PKD.'|| v_out_table_mod ||'
						SET EPULET = (select ROUND(SUM(NVL(EPULET, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						JARMU = (select ROUND(SUM(NVL(JARMU, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						GYORSGEP = (select ROUND(SUM(NVL(GYORSGEP, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						TARTOSGEP = (select ROUND(SUM(NVL(TARTOSGEP, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						SZOFTVER = (select ROUND(SUM(NVL(SZOFTVER, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						FEGYVER = (select ROUND(SUM(NVL(FEGYVER, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						K_F = (select ROUND(SUM(NVL(K_F, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						ORIGINALS = (select ROUND(SUM(NVL(ORIGINALS, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						
						FOLDJAVITAS = (select ROUND(SUM(NVL(FOLDJAVITAS, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),

						OWNSOFT = (select ROUND(SUM(NVL(OWNSOFT, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
										
						SUM_CLASSIC = (select ROUND(SUM(NVL(SUM_CLASSIC, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM''),
						SUM_ALL = (select ROUND(SUM(NVL(SUM_ALL, 0))) from PKD.'|| v_out_table_mod ||' WHERE F_V_99 = '''|| v_FV(c) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_evek(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT != ''SUM'')

						WHERE ALSZEKTOR = '''|| v_szektorok(a) ||''' AND AGAZAT = ''SUM''
						AND F_V_99 = '''|| v_FV(c) ||''' AND EV = '''|| v_evek(d) ||''' AND CFC_NET_GRS = ''cfc''
						'
						;	
						
						
						END IF;
	
					END LOOP;

			END LOOP;

	END LOOP;

END LOOP;

-- A NET és GRS értékeket 1000-el el kell osztani
EXECUTE IMMEDIATE'
UPDATE '|| v_out_table_mod ||'
SET EPULET = ROUND(EPULET/1000),
TARTOSGEP = ROUND(TARTOSGEP/1000),
GYORSGEP = ROUND(GYORSGEP/1000),
JARMU = ROUND(JARMU/1000),
SZOFTVER = ROUND(SZOFTVER/1000),
ORIGINALS = ROUND(ORIGINALS/1000),
FOLDJAVITAS = ROUND(FOLDJAVITAS/1000),
K_F = ROUND(K_F/1000),
FEGYVER = ROUND(FEGYVER/1000),
OWNSOFT = ROUND(OWNSOFT/1000),
LAKAS = ROUND(LAKAS/1000),
NOE6 = ROUND(NOE6/1000),
KISERTEKU = ROUND(KISERTEKU/1000),
WIZZ = ROUND(WIZZ/1000),
MEZO = ROUND(MEZO/1000),
TCF = ROUND(TCF/1000),
EGYEB_ORIG = ROUND(EGYEB_ORIG/1000),
BESOROLT_VALL = ROUND(BESOROLT_VALL/1000)
WHERE CFC_NET_GRS IN (''net'', ''grs'')
'
;

COMMIT;


EXECUTE IMMEDIATE'
UPDATE PKD.'|| v_out_table_mod ||'
SET SUM_CLASSIC = NVL(EPULET, 0) + NVL(TARTOSGEP, 0) + NVL(GYORSGEP, 0) + NVL(JARMU, 0) + NVL(SZOFTVER, 0)
WHERE CFC_NET_GRS IN (''net'', ''grs'')
'
;

EXECUTE IMMEDIATE'
UPDATE PKD.'|| v_out_table_mod ||'
SET SUM_ALL = NVL(EPULET, 0) + NVL(TARTOSGEP, 0) + NVL(GYORSGEP, 0) + NVL(JARMU, 0) + NVL(SZOFTVER, 0) + NVL(ORIGINALS, 0) + NVL(FOLDJAVITAS, 0) + NVL(K_F, 0) + NVL(FEGYVER, 0) + NVL(OWNSOFT, 0) + NVL(LAKAS, 0) + NVL(NOE6, 0) + NVL(KISERTEKU, 0) + NVL(WIZZ, 0) + NVL(MEZO, 0) + NVL(TCF, 0) + NVL(EGYEB_ORIG, 0) 
WHERE CFC_NET_GRS IN (''net'', ''grs'')
'
;

COMMIT;

CFC_OUTPUT_NEW.CFC_OUTPUT_NEW_MOD();


END;