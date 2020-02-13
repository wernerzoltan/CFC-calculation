/*


create or replace PACKAGE CFC_OUTPUT_NEW_2 AUTHID CURRENT_USER AS 
TYPE t_out_cfc IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER; --

TYPE t_out_szektorok IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_eszkcsp_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_eszkcsp IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_eszkcsp_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_eszkcsp_3 IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_up IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_out_nk_up_c IS TABLE OF VARCHAR2(50 CHAR) INDEX BY PLS_INTEGER;
TYPE t_in_year IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER; --

TYPE T_AGAZAT_IMP_I IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER; --
TYPE t_3_agazat IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER; --
TYPE T_V_99 IS TABLE OF VARCHAR2(5 CHAR) INDEX BY PLS_INTEGER; --
TYPE T_V_99a IS TABLE OF VARCHAR2(10 CHAR) INDEX BY PLS_INTEGER; --

procedure CFC_OUTPUT_NEW_2(SZEKTOR VARCHAR2, ALSZEKTOR VARCHAR2, EVSZAM VARCHAR2);

END CFC_OUTPUT_NEW_2;

*/

create or replace PACKAGE BODY CFC_OUTPUT_NEW_2 AS 
F_V_99 T_V_99;
F_V_99a T_V_99a;
V_AGAZAT_IMP_I T_AGAZAT_IMP_I;
v_3_agazat t_3_agazat;
v_out_cfc t_out_cfc; --
v_out_eszkcsp t_out_eszkcsp; --
v_out_eszkcsp_c t_out_eszkcsp_c;
v_out_nk_eszkcsp_3 t_out_nk_eszkcsp_3;
v_out_nk_eszkcsp t_out_nk_eszkcsp;
v_out_nk_eszkcsp_c t_out_nk_eszkcsp_c;
v_out_nk_up t_out_nk_up;
v_out_nk_up_c t_out_nk_up_c;
v_in_year t_in_year; --
v_szektorok t_out_szektorok;
sql_statement VARCHAR2(5000);

procedure CFC_OUTPUT_NEW_2(SZEKTOR VARCHAR2, ALSZEKTOR VARCHAR2, EVSZAM VARCHAR2) AS

  type h_cursor_typ is ref cursor;
   type tev_phad_type is record ( 

                row_id rowid,
                "EPULET" NUMBER, 
                "TARTOSGEP" NUMBER, 
                "GYORSGEP" NUMBER, 
                "JARMU" NUMBER, 
                "SZOFTVER" NUMBER, 
                "ORIGINALS" NUMBER, 
                "FOLDJAVITAS" NUMBER, 
                "K_F" NUMBER, 
                "FEGYVER" NUMBER, 
                "OWNSOFT" NUMBER,                
                "LAKAS" NUMBER, 
                "MEZO" NUMBER,
                "NOE6" NUMBER, 
                "KISERTEKU" NUMBER, 
                "WIZZ" NUMBER, 
                "TCF" NUMBER, 
                "EGYEB_ORIG" NUMBER
);
    tev_phad_cur h_cursor_typ;
    tev_phad_rec tev_phad_type;

	
 type ysum_all_type is record ( 

                row_id rowid,
				"OUTPUT" VARCHAR2(5),
                "ALSZEKTOR" VARCHAR2(100),
                "AGAZAT" VARCHAR2(30),
                "YSUM_AKT" NUMBER, 
                "YSUM_UNCH" NUMBER, 
                "YSUM" NUMBER   
      );
    ysum_all_cur h_cursor_typ;
    ysum_all_rec ysum_all_type;	
	
  type ysum_type is record ( 

                row_id rowid,
                "EPULET" NUMBER, 
                "TARTOSGEP" NUMBER, 
                "GYORSGEP" NUMBER, 
                "JARMU" NUMBER, 
                "SZOFTVER" NUMBER   
      );
    ysum_cur h_cursor_typ;
    ysum_rec ysum_type;

    tev_phad_sql_text varchar2(1000);

	sum_all_epulet NUMBER;
	sum_all_tartosgep NUMBER;
	sum_all_gyorsgep NUMBER;
	sum_all_jarmu NUMBER;
	sum_all_szoftver NUMBER;


  type ysum_type_nk is record ( 

	row_id rowid,
	"ORIGINALS" NUMBER, 
	"FOLDJAVITAS" NUMBER, 
	"K_F" NUMBER, 
	"FEGYVER" NUMBER, 
	"OWNSOFT" NUMBER,
	"NOE6" NUMBER,
	"KISERTEKU" NUMBER,
	"TCF" NUMBER,
	"EGYEB_ORIG" NUMBER,
	"WIZZ" NUMBER

      );
    ysum_cur_nk h_cursor_typ;
    ysum_rec_nk ysum_type_nk;

	sum_all_ORIGINALS NUMBER;
	sum_all_FOLDJAVITAS NUMBER;
	sum_all_K_F NUMBER;
	sum_all_FEGYVER NUMBER;
	sum_all_OWNSOFT NUMBER;
	sum_all_NOE6 NUMBER;
	sum_all_KISERTEKU NUMBER;
	sum_all_TCF NUMBER;
	sum_all_EGYEB_ORIG NUMBER;
	sum_all_WIZZ NUMBER;

TYPE t_agazat IS TABLE OF VARCHAR2(20); 
v_agazat t_agazat; 

v NUMERIC; --
v1 NUMERIC; --
v2 NUMERIC; --
v_out_szektor VARCHAR2(50);
v_out_alszektor VARCHAR2(50);
v_out_table VARCHAR2(50); --
v_out_table_all VARCHAR2(50); --
v_out_table_mod VARCHAR2(50);
cfc_imputalt VARCHAR2(50) := 'CFC_IMPUTALT_99_F_V'; -- imputált tábla értékei
cfc_lakas VARCHAR2(50) := 'CFC_GRS_NET_LAKAS_MEZO'; -- LAKAS, MEZŐ értékek
cfc_besorolt VARCHAR2(50) := 'CFC_BES_VALL_F'; -- BESOROLT_VALL tábla 
cfc_besorolt_a VARCHAR2(50) := 'CFC_BES_VALL_KLASSZ_ARANY'; -- BESOROLT_VALL arány tábla 
bes_vall_eszkoz VARCHAR2(50); 
bes_vall_ertek NUMBER;
bes_vall_ertek1 NUMBER;
bes_vall_ertek2 NUMBER;
bes_vall_ertek3 NUMBER;
bes_vall_ertek4 NUMBER;
bes_vall_ertek5 NUMBER;

v_update VARCHAR2(50);

BEGIN

IF ''|| EVSZAM ||'' = 'ALL' THEN

	v_in_year(1) := '1995';
	v_in_year(2) := '1996';
	v_in_year(3) := '1997';
	v_in_year(4) := '1998';
	v_in_year(5) := '1999';
	v_in_year(6) := '2000';
	v_in_year(7) := '2001';
	v_in_year(8) := '2002';
	v_in_year(9) := '2003';
	v_in_year(10) := '2004';
	v_in_year(11) := '2005';
	v_in_year(12) := '2006';
	v_in_year(13) := '2007';
	v_in_year(14) := '2008';
	v_in_year(15) := '2009';
	v_in_year(16) := '2010';
	v_in_year(17) := '2011';
	v_in_year(18) := '2012';
	v_in_year(19) := '2013';
	v_in_year(20) := '2014';
	v_in_year(21) := '2015';
	v_in_year(22) := '2016';
	v_in_year(23) := '2017';
	v_in_year(24) := '2018';

ELSE 

    v_in_year(1) := ''|| EVSZAM ||'';

END IF;

v_out_table := 'C_OUTPUT_P2';
--v_out_table_all := 'C_OUTPUT_3JEGYU_P2';
--v_out_table_mod := 'C_OUTPUT_MOD_P2';

--PKD.TRUNCATE_TABLE(''|| v_out_table ||'');
-- PKD.TRUNCATE_TABLE(''|| v_out_table_all ||'');
-- PKD.TRUNCATE_TABLE(''|| v_out_table_mod ||'');

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

-- 1. lépés: az OUTPUT táblába betöltjük az alap értékeket

dbms_output.put_line('1. lépés START: ' || systimestamp);

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' ';
EXECUTE IMMEDIATE sql_statement INTO v;

IF v = 0 THEN

	FOR x IN 1..v_in_year.COUNT LOOP

		FOR y IN 1..F_V_99.COUNT LOOP

			FOR l IN 1..V_AGAZAT_IMP_I.COUNT LOOP

				EXECUTE IMMEDIATE'
				INSERT INTO '|| v_out_table ||' (EV, F_V_99, CFC_NET_GRS, ALSZEKTOR, AGAZAT) 
				VALUES ('''|| v_in_year(x) ||''', '''|| F_V_99(y) ||''', '''|| v_out_cfc(z) ||''', '''|| v_szektorok(s) ||''', '''|| V_AGAZAT_IMP_I(l) ||''')                                                                   
				'
				;

			END LOOP;

		END LOOP;

	END LOOP; -- évek

END IF;

END LOOP; -- CFC/NET/GRS

END LOOP;

dbms_output.put_line('1. lépés STOP: ' || systimestamp);

-- 2. lépés: az YSUM... értékeket beillesztjük

dbms_output.put_line('2. lépés START: ' || systimestamp);

FOR x IN 1..v_in_year.COUNT LOOP

	FOR b IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP 

		sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_out_eszkcsp(b) ||'_'|| v_in_year(x) ||' ';

		EXECUTE IMMEDIATE sql_statement INTO v;

		IF v > 0 THEN
		
			tev_phad_sql_text := 'SELECT rowid sorid, OUTPUT, ALSZEKTOR, AGAZAT, YSUM_AKT, YSUM_UNCH, YSUM  FROM '|| v_out_eszkcsp(b) ||'_'|| v_in_year(x) ||' WHERE ALSZEKTOR NOT IN (''S1311a'', ''S1313a'') AND AGAZAT != ''SUM'' ';
				
			open ysum_all_cur for tev_phad_sql_text;

			loop
			fetch ysum_all_cur into ysum_all_rec;
			exit when ysum_all_cur%NOTFOUND;  

			begin

			execute immediate '
			UPDATE PKD.'|| v_out_table ||' 
			set '|| v_out_eszkcsp(b) ||' = :YSUM_AKT
			WHERE ALSZEKTOR=:ALSZEKTOR
			AND AGAZAT =:AGAZAT
			AND CFC_NET_GRS =:OUTPUT
			AND F_V_99 = ''F''
			AND EV = '''|| v_in_year(x) ||'''
			' 
			using 
			ysum_all_rec.YSUM_AKT, 
			ysum_all_rec.ALSZEKTOR,
			ysum_all_rec.AGAZAT,
			ysum_all_rec.OUTPUT
			;                                                               

			execute immediate '
			UPDATE PKD.'|| v_out_table ||' 
			set '|| v_out_eszkcsp(b) ||' = :YSUM_UNCH
			WHERE ALSZEKTOR=:ALSZEKTOR
			AND AGAZAT =:AGAZAT
			AND CFC_NET_GRS =:OUTPUT
			AND F_V_99 = ''V''
			AND EV = '''|| v_in_year(x) ||'''
			 ' 
			using 
			ysum_all_rec.YSUM_UNCH, 
			ysum_all_rec.ALSZEKTOR,
			ysum_all_rec.AGAZAT,
			ysum_all_rec.OUTPUT
			;   

			execute immediate '
			UPDATE PKD.'|| v_out_table ||' 
			set '|| v_out_eszkcsp(b) ||' = :YSUM
			WHERE ALSZEKTOR=:ALSZEKTOR
			AND AGAZAT =:AGAZAT
			AND CFC_NET_GRS =:OUTPUT
			AND F_V_99 = ''99''
			AND EV = '''|| v_in_year(x) ||'''
			 ' 
			using
			ysum_all_rec.YSUM, 
			ysum_all_rec.ALSZEKTOR,
			ysum_all_rec.AGAZAT,
			ysum_all_rec.OUTPUT
			;  
			
			end;
			end loop;
			close ysum_all_cur;
			commit;       

		END IF;
			
	END LOOP;

END LOOP;


-- FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

	-- FOR x IN 1..v_in_year.COUNT LOOP

		-- FOR b IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP 

		-- sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_out_eszkcsp(b) ||'_'|| v_in_year(x) ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';

		-- EXECUTE IMMEDIATE sql_statement INTO v;

		-- IF v > 0 THEN

			-- IF ''|| v_szektorok(s) ||'' NOT IN ('S1311a', 'S1313a') THEN

				-- FOR c IN F_V_99a.FIRST..F_V_99a.LAST LOOP

					-- EXECUTE IMMEDIATE
					-- 'DECLARE
					-- CURSOR INS_OPS IS SELECT OUTPUT, ALSZEKTOR, AGAZAT, '|| F_V_99a(c) ||' as ONUM FROM '|| v_out_eszkcsp(b) ||'_'|| v_in_year(x) ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT != ''SUM'' ;
					-- TYPE INS_ARRAY IS TABLE OF INS_OPS%ROWTYPE;
					-- INS_OPS_ARRAY INS_ARRAY;
					-- BEGIN
					-- OPEN INS_OPS;
					-- LOOP
					-- FETCH INS_OPS BULK COLLECT INTO INS_OPS_ARRAY;
					-- FORALL I IN INS_OPS_ARRAY.FIRST..INS_OPS_ARRAY.LAST
					-- UPDATE '|| v_out_table ||' 
					-- SET '|| v_out_eszkcsp(b) ||' = INS_OPS_ARRAY(I).ONUM
					-- WHERE ALSZEKTOR = INS_OPS_ARRAY(I).ALSZEKTOR AND CFC_NET_GRS = INS_OPS_ARRAY(I).OUTPUT AND EV = '''|| v_in_year(x) ||''' AND AGAZAT = INS_OPS_ARRAY(I).AGAZAT AND F_V_99 = '''|| F_V_99(c) ||''';

					-- EXIT WHEN INS_OPS%NOTFOUND;
					-- END LOOP;
					-- CLOSE INS_OPS;
					-- END;';

				-- END LOOP;

			-- END IF;

		-- END IF;

        -- END LOOP;

	-- END LOOP;

-- END LOOP;

-- COMMIT;

dbms_output.put_line('2. lépés STOP: ' || systimestamp);
/*
-- 3. lépés: 3 jegyű ágazatok összevonása

dbms_output.put_line('3. lépés START: ' || systimestamp);

-- 843-as ágazatot előzőleg kerekíteni kell:
EXECUTE IMMEDIATE'
UPDATE '|| v_out_table ||'
SET EPULET = ROUND(EPULET)
WHERE AGAZAT = ''843'' 
AND ALSZEKTOR IN (''S1311'', ''S1313'')
'
;

-- 721, 722, 723-as ágazatot előzőleg kerekíteni kell:
EXECUTE IMMEDIATE'
UPDATE '|| v_out_table ||'
SET EPULET = ROUND(K_F)
WHERE AGAZAT IN (''721'', ''722'', ''723'')
AND ALSZEKTOR = ''S1311'' 
'
;

FOR a IN v_szektorok.FIRST..v_szektorok.LAST LOOP

	-- 3 jegyű táblába áttesszük a 3 jegyű értékeket
	EXECUTE IMMEDIATE'
	INSERT INTO '|| v_out_table_all ||'
	(SELECT ALSZEKTOR, AGAZAT, ROUND(EPULET), ROUND(TARTOSGEP), ROUND(GYORSGEP), ROUND(JARMU), ROUND(SZOFTVER), ROUND(SUM_CLASSIC), EV, F_V_99, CFC_NET_GRS, ROUND(ORIGINALS), ROUND(FOLDJAVITAS), ROUND(K_F), ROUND(FEGYVER), ROUND(OWNSOFT), ROUND(LAKAS), ROUND(NOE6), ROUND(KISERTEKU), ROUND(WIZZ), ROUND(MEZO), ROUND(TCF), ROUND(EGYEB_ORIG), ROUND(SUM_ALL), ROUND(BESOROLT_VALL), SZEKTOR
	FROM '|| v_out_table ||'
	WHERE AGAZAT IN (''361'', ''362'', ''421'', ''422'', ''711'', ''712'', ''721'', ''722'', ''723'', ''821'', ''822'', ''841'', ''842'', ''843'', ''844'', ''845'', ''846'', ''851'', ''852'', ''853'')
	AND ALSZEKTOR = '''|| v_szektorok(a) ||'''
	)
	'
	;

END LOOP;


-- S11 esetén: AN112 (épület), AN1139t (tartósgép), AN1139g (gyorsgép), AN1131 (jármű), AN1173s (szoftver): 
                -- 36, 361, 362 -> 36

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP   

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                IF ''|| v_szektorok(s) ||'' = 'S11' THEN

                               FOR x IN 1..v_in_year.COUNT LOOP

                                               FOR a IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP 

                                                               IF ''|| v_out_eszkcsp_c(a) ||'' IN ('AN112', 'AN1139t', 'AN1139g', 'AN1131', 'AN1173s') THEN     

                                                                              FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS('36', '''36'', ''361'', ''362''', '''361'', ''362''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                                                              END IF; 

                                                                              END LOOP;

                                                               END IF;

                                               END LOOP;

                               END LOOP; 

                END IF;

END LOOP;         

END LOOP;

-- S1311 esetén: AN112 (épület), AN1139t (tartósgép), AN1139g (gyorsgép), AN1131 (jármű), AN1173s (szoftver): 
                                               -- 421, 422 -> 42                               
                                               -- 711, 712 -> 71
                                               -- 821, 822 -> 82
                                               -- 841, 842, 843, 844, 845 -> 84
                                               -- 851, 852, 853 -> 85

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                IF ''|| v_szektorok(s) ||'' = 'S1311' THEN             

                               FOR x IN 1..v_in_year.COUNT LOOP

                                               FOR a IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP 

                                                               IF ''|| v_out_eszkcsp_c(a) ||'' IN ('AN112', 'AN1139t', 'AN1139g', 'AN1131', 'AN1173s') THEN     

                                                                              FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS('42', '''42'', ''421'', ''422''', '''421'', ''422''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                                                              END IF;

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                              PKD.AGAZAT_OSSZEVONAS('71', '''71'', ''711'', ''712''', '''711'', ''712''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                                                              END IF;

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS('82', '''82'', ''821'', ''822''', '''821'', ''822''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                                                              END IF;                                                                                               

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS('84', '''84'', ''841'', ''842'', ''843'', ''844'', ''845''', '''841'', ''842'', ''843'', ''844'', ''845''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                                                              END IF;

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS('85', '''85'', ''851'', ''852'', ''853''', '''851'', ''852'', ''853''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                                                              END IF;

                                                                              END LOOP;

                                                               END IF;

                                               END LOOP;

                               END LOOP;

                END IF;

END LOOP;                                        

END LOOP;

-- S1313 esetén: AN112 (épület), AN1139t (tartósgép), AN1139g (gyorsgép), AN1131 (jármű), AN1173s (szoftver): 
                -- 84, 841, 842, 843, 844 -> 84

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                IF ''|| v_szektorok(s) ||'' = 'S1313' THEN             

                               FOR x IN 1..v_in_year.COUNT LOOP

                                               FOR a IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP 

                                                               IF ''|| v_out_eszkcsp_c(a) ||'' IN ('AN112', 'AN1139t', 'AN1139g', 'AN1131', 'AN1173s') THEN     

                                                                              FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS('84', '''84'', ''841'', ''842'', ''843'', ''844''', '''841'', ''842'', ''843'', ''844''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99a(b) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_eszkcsp_c(a) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                                                              END IF; 

                                                                              END LOOP;

                                                               END IF;

                                               END LOOP;

                               END LOOP;

                END IF;

END LOOP;

END LOOP;


                FOR a IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP

                               EXECUTE IMMEDIATE'
                               UPDATE PKD.'|| v_out_table ||'
                               SET '|| v_out_eszkcsp(a) ||' =
                               ROUND('|| v_out_eszkcsp(a) ||')
                               '
                               ;

                END LOOP;


dbms_output.put_line('3. lépés STOP: ' || systimestamp);



-- 4.lépés: S1311 és S1313 esetén az egyes ágazatok között klasszikus eszközök esetében át kell variálni az ágazatokat, évtől függően!

dbms_output.put_line('4. lépés START: ' || systimestamp);

                --S1311: 38->84 - 1995 -> 2006
                --S1311: 56->55 - minden évre
                --S1311: 61->84 - minden évre
                --S1311: 96->84 - 2010 -> 2017
                --S1311: 49,58,62,94->84 - minden évre
                --S1311: 82->71 - 1995 -> 1999, 2013 -> 2017
                --S1311: 90->93 - 1995 -> 1999   
                --S1311: 68->55 - 2000 -> 2009   

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                FOR a IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP 

                               FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                                               FOR x IN 1..v_in_year.COUNT LOOP

                                                               IF ''|| v_szektorok(s) ||'' = 'S1311' THEN

                                                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                                                               EXECUTE IMMEDIATE sql_statement INTO v;

                                                               IF v > 0 THEN

                                                               --S1311: 38->84 - 1995 -> 2006
                                                               IF ''|| v_in_year(x) ||'' NOT IN ('2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''84'', ''38''', '''38''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF;

                                                               --S1311: 56->55 - minden évre
                                                               PKD.AGAZAT_VARIALAS('55', '''56'', ''55''', '''56''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               --S1311: 61->84 - minden évre
                                                               PKD.AGAZAT_VARIALAS('84', '''61'', ''84''', '''61''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               --S1311: 96->84 - 2010 -> 2017
                                                               IF ''|| v_in_year(x) ||'' IN ('2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '208') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''84'', ''96''', '''96''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF;

                                                               --S1311: 49,58,62,94->84 - minden évre
                                                               PKD.AGAZAT_VARIALAS('84', '''49'', ''58'', ''62'', ''94'', ''84''', '''49'', ''58'', ''62'', ''94''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               --S1311: 82->71 - 1995 -> 1999, 2013 -> 2017
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999', '2013', '2014', '2015', '2016', '2017') THEN

                                                               PKD.AGAZAT_VARIALAS('71', '''82'', ''71''', '''82''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF;                                                

                                                               --S1311: 90->93 - 1995 -> 1999   
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999') THEN

                                                               PKD.AGAZAT_VARIALAS('93', '''90'', ''93''', '''90''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF; 

                                                               --S1311: 68->55 - 2000 -> 2009   
                                                               IF ''|| v_in_year(x) ||'' IN ('2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009') THEN

                                                               PKD.AGAZAT_VARIALAS('55', '''68'', ''55''', '''68''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF; 

                                                               END IF;

                                                               END IF;

                --S1313: 35,47,58,62,72,77,94->84 - minden évre
                --S1313: 36->84 - 1995 -> 2009
                --S1313: 49,50->84 - 1995 -> 2013
                --S1313: 61->84 - 2010 -> 2013, 2017-től
                --S1313: 71,82->84 - 1995 -> 1999, 2010 -> 2013
                --S1313: 38->37 - 2000 -> 2003
                --S1313: 38->39 - 1995 -> 1999, 2004 -> 2009
                --S1313: 41->42 - 1995 -> 1999   
                --S1313: 56->55 - 1995 -> 1999   
                --S1313: 55->56 - 2000 -> 2002   
                --S1313: 60->93 - 1995 -> 1999, 2014 -> 2017
                --S1313: 71->82 - 2000 -> 2009
                --S1313: 75->86 - 2001 -> 2017
                --S1313: 82->71 - 2014 -> 2017
                --S1313: 82->84 - 2018
                --S1313: 90->91 - 1995 -> 1999

                                                               IF ''|| v_szektorok(s) ||'' = 'S1313' THEN

                                                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                                                               EXECUTE IMMEDIATE sql_statement INTO v;

                                                               IF v > 0 THEN

                                                               --S1313: 35,47,58,62,72,77,94->84 - minden évre
                                                               PKD.AGAZAT_VARIALAS('84', '''35'', ''47'', ''58'', ''62'', ''72'', ''77'', ''94'', ''84''', '''35'', ''47'', ''58'', ''62'', ''72'', ''77'', ''94''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               --S1313: 36->84 - 1995 -> 2009
                                                               IF ''|| v_in_year(x) ||'' NOT IN ('2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''36'', ''84''', '''36''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF;                                                                

                                                               --S1313: 49,50->84 - 1995 -> 2013
                                                               IF ''|| v_in_year(x) ||'' NOT IN ('2014', '2015', '2016', '2017', '2018') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''49'', ''50'', ''84''', '''49'', ''50''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF;                                                                

                                                               --S1313: 61->84 - 2010 -> 2013, 2017
                                                               IF ''|| v_in_year(x) ||'' IN ('2010', '2011', '2012', '2013', '2017') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''61'', ''84''', '''61''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF; 

                                                               --S1313: 71,82->84 - 1995 -> 1999, 2010 -> 2013 
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999', '2010', '2011', '2012', '2013') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''71'', ''82'', ''84''', '''71'', ''82''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 

                                                               --S1313: 38->37 - 2000 -> 2003
                                                               IF ''|| v_in_year(x) ||'' IN ('2000', '2001', '2002', '2003' ) THEN

                                                              PKD.AGAZAT_VARIALAS('37', '''38'', ''37''', '''38''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF; 


                                                               --S1313: 38->39 - 1995 -> 1999, 2004 -> 2009
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999', '2004', '2005', '2006', '2007', '2008', '2009') THEN

                                                               PKD.AGAZAT_VARIALAS('39', '''38'', ''39''', '''38''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                               END IF; 

                                                               --S1313: 41->42 - 1995 -> 1999   
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999') THEN

                                                               PKD.AGAZAT_VARIALAS('42', '''41'', ''42''', '''41''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 

                                                               --S1313: 55->56 - 2000 -> 2002   
                                                               IF ''|| v_in_year(x) ||'' IN ('2000', '2001', '2002') THEN

                                                               PKD.AGAZAT_VARIALAS('56', '''56'', ''55''', '''55''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');              


                                                               END IF; 

                                                               --S1313: 56->55 - 1995 -> 1999   
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999') THEN

                                                               PKD.AGAZAT_VARIALAS('55', '''55'', ''56''', '''56''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');              


                                                               END IF; 


                                                               --S1313: 60->93 - 1995 -> 1999, 2014 -> 2017
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999', '2014', '2015', '2016', '2017') THEN

                                                               PKD.AGAZAT_VARIALAS('93', '''60'', ''93''', '''60''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 


                                                               --S1313: 71->82 - 2000 -> 2009
                                                               IF ''|| v_in_year(x) ||'' IN ('2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009') THEN

                                                               PKD.AGAZAT_VARIALAS('82', '''71'', ''82''', '''71''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 

                                                               --S1313: 75->86 - 2001 -> 2017
                                                               IF ''|| v_in_year(x) ||'' NOT IN ('1995', '1996', '1997', '1998', '1999', '2000', '2018') THEN

                                                               PKD.AGAZAT_VARIALAS('86', '''75'', ''86''', '''75''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 

                                                               --S1313: 82->71 - 2014 -> 2017
                                                               IF ''|| v_in_year(x) ||'' IN ('2014', '2015', '2016', '2017') THEN

                                                               PKD.AGAZAT_VARIALAS('71', '''71'', ''82''', '''82''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 

                                                               --S1313: 82->84 - 2018
                                                               IF ''|| v_in_year(x) ||'' IN ('2018') THEN

                                                               PKD.AGAZAT_VARIALAS('84', '''84'', ''82''', '''82''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 


                                                               --S1313: 90->91 - 1995 -> 1999
                                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999') THEN

                                                               PKD.AGAZAT_VARIALAS('91', '''90'', ''91''', '''90''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                               END IF; 

                                                               END IF;

                                                               END IF;

-- S15 esetén 94-be kerülnek bizonyos ágazatok

                                                               IF ''|| v_szektorok(s) ||'' = 'S15' THEN

                                                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                                                               EXECUTE IMMEDIATE sql_statement INTO v;

                                                               IF v > 0 THEN

                                                               PKD.AGAZAT_VARIALAS('94', '''01'', ''15'', ''16'', ''17'', ''18'', ''33'', ''27'', ''26'', ''32'', ''36'', ''42'', ''56'', ''49'', ''52'', ''61'', ''68'', ''62'', ''71'', ''72'', ''39'', ''94'', ''96''', '''01'', ''15'', ''16'', ''17'', ''18'', ''33'', ''27'', ''26'', ''32'', ''36'', ''42'', ''56'', ''49'', ''52'', ''61'', ''68'', ''62'', ''71'', ''72'', ''39'', ''96''', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');                                                    

                                                               END IF;

                                                               END IF;


                                               END LOOP;

                               END LOOP;

                END LOOP;

END LOOP;         

END LOOP;

-- S14: OWNSOFT 27->25 minden évre
FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP
                
                               FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                                               FOR x IN 1..v_in_year.COUNT LOOP

                                                               IF ''|| v_szektorok(s) ||'' = 'S14' THEN

                                                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                                                               EXECUTE IMMEDIATE sql_statement INTO v;

                                                               PKD.AGAZAT_VARIALAS('25', '''25'', ''27''', '''27''', ''|| v_out_table ||'', 'OWNSOFT', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');
                                                               
                                                               END IF;
                                                               
                                               END LOOP;

                               END LOOP;
                                               
                END LOOP;
                                               
END LOOP;

COMMIT;

dbms_output.put_line('4. lépés STOP: ' || systimestamp);



-- 5. lépés: S1311 és S1313 közötti módosítások az összes klasszikus eszközre

dbms_output.put_line('5. lépés START: ' || systimestamp);

sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = ''S1311'' ';
EXECUTE IMMEDIATE sql_statement INTO v;
IF v > 0 THEN

sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = ''S1313'' ';
EXECUTE IMMEDIATE sql_statement INTO v;
IF v > 0 THEN                     


	FOR a IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP

		FOR b IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

			FOR c IN F_V_99.FIRST..F_V_99.LAST LOOP

			  -- 2012-ben:
			  -- S1311: 86-os ágazat = (S1311: 86 + S1313: 86) * 86%
			  -- S1313: 86-os ágazat = (S1311: 86 + S1313: 86) * 14%                   

			  sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE EV = ''2012''';
			  EXECUTE IMMEDIATE sql_statement INTO v;

			  IF v > 0 THEN

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012'') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012''))
			  * 0.86) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v1;

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012'') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012''))
			  * 0.14) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v2;

			  PKD.SZEKTOR_MODOSITAS('86', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1311', ''|| v_out_cfc(b) ||'', '2012', ''|| v1 ||'');

			  PKD.SZEKTOR_MODOSITAS('86', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1313', ''|| v_out_cfc(b) ||'', '2012', ''|| v2 ||'');


			  -- S1311: 87-es ágazat = (S1311: 87 + S1313: 87) * 50%   
			  -- S1313: 87-es ágazat = (S1311: 87 + S1313: 87) * 50%   
			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012'') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012''))
			  * 0.50) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v1;

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012'') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012''))
			  * 0.50) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v2;

			  PKD.SZEKTOR_MODOSITAS('87', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1311', ''|| v_out_cfc(b) ||'', '2012', ''|| v1 ||'');

			  PKD.SZEKTOR_MODOSITAS('87', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1313', ''|| v_out_cfc(b) ||'', '2012', ''|| v2 ||'');


			  -- S1311: 88-as ágazat = (S1311: 88 + S1313: 88) * 4%      
			  -- S1311: 88-as ágazat = (S1311: 88 + S1313: 88) * 96%    
			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012'') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012''))
			  * 0.04) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v1;

			  -- S1311: 88-as ágazat = (S1311: 88 + S1313: 88) * 96%
			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012'') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = ''2012''))
			  * 0.96) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v2;                                                                

			  PKD.SZEKTOR_MODOSITAS('88', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1311', ''|| v_out_cfc(b) ||'', '2012', ''|| v1 ||'');

			  PKD.SZEKTOR_MODOSITAS('88', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1313', ''|| v_out_cfc(b) ||'', '2012', ''|| v2 ||'');

			  END IF;

			  -- 2013-tól:
			  FOR d IN 19..v_in_year.LAST LOOP

			  -- S1311: 86-os ágazat = (S1311: 86 + S1313: 86) * 92%   
			  -- S1313: 86-os ágazat = (S1311: 86 + S1313: 86) * 8%      

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||''') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||'''))
			  * 0.92) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v1;

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||''') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''86'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||'''))
			  * 0.08) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v2;

			  PKD.SZEKTOR_MODOSITAS('86', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1311', ''|| v_out_cfc(b) ||'', ''|| v_in_year(d) ||'', ''|| v1 ||'');

			  PKD.SZEKTOR_MODOSITAS('86', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1313', ''|| v_out_cfc(b) ||'', ''|| v_in_year(d) ||'', ''|| v2 ||'');                                                                             


			  -- S1311: 87-es ágazat = (S1311: 87 + S1313: 87) * 66%   
			  -- S1311: 87-es ágazat = (S1311: 87 + S1313: 87) * 34%   
			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||''') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||'''))
			  * 0.66) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v1;

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||''') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''87'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||'''))
			  * 0.34) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v2;

			  PKD.SZEKTOR_MODOSITAS('87', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1311', ''|| v_out_cfc(b) ||'', ''|| v_in_year(d) ||'', ''|| v1 ||'');

			  PKD.SZEKTOR_MODOSITAS('87', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1313', ''|| v_out_cfc(b) ||'', ''|| v_in_year(d) ||'', ''|| v2 ||'');              


			  -- S1311: 88-as ágazat = (S1311: 88 + S1313: 88) * 7%      
			  -- S1311: 88-as ágazat = (S1311: 88 + S1313: 88) * 93%
			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||''') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||'''))
			  * 0.07) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v1;

			  sql_statement := 'SELECT ROUND(((SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1311''
			  AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||''') +
			  (SELECT NVL('|| v_out_eszkcsp(a) ||', 0) FROM PKD.'|| v_out_table ||' 
			  WHERE AGAZAT = ''88'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(d) ||'''))
			  * 0.93) from dual';
			  EXECUTE IMMEDIATE sql_statement INTO v2;  

			  PKD.SZEKTOR_MODOSITAS('88', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1311', ''|| v_out_cfc(b) ||'', ''|| v_in_year(d) ||'', ''|| v1 ||'');

			  PKD.SZEKTOR_MODOSITAS('88', ''|| v_out_table ||'', ''|| v_out_eszkcsp(a) ||'', ''|| F_V_99(c) ||'', 'S1313', ''|| v_out_cfc(b) ||'', ''|| v_in_year(d) ||'', ''|| v2 ||'');              


                                                                              END LOOP;

                                                               END LOOP;

                                               END LOOP;

                               END LOOP;


                               END IF;

                               END IF;

COMMIT;

dbms_output.put_line('5. lépés STOP: ' || systimestamp);

-- 6.lépés: SUM rekord kiszámítása

dbms_output.put_line('6. lépés START: ' || systimestamp);

-- a SUM rekordot újraszámítjuk a klasszikus eszközöknél

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                EXECUTE IMMEDIATE sql_statement INTO v;
                IF v > 0 THEN

                               FOR z IN F_V_99.FIRST..F_V_99.LAST LOOP

                                               FOR b IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                                                               FOR x IN v_in_year.FIRST..v_in_year.LAST LOOP

                                               execute immediate 'select ROUND(SUM(NVL(EPULET, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_epulet;
                                               execute immediate 'select ROUND(SUM(NVL(TARTOSGEP, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_tartosgep;                                  
                                               execute immediate 'select ROUND(SUM(NVL(GYORSGEP, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_gyorsgep;
                                               execute immediate 'select ROUND(SUM(NVL(JARMU, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_jarmu;
                                               execute immediate 'select ROUND(SUM(NVL(SZOFTVER, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_szoftver;      

tev_phad_sql_text := 'SELECT rowid sorid, EPULET, GYORSGEP, TARTOSGEP, JARMU, SZOFTVER FROM PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = ''SUM'' ';

open ysum_cur for tev_phad_sql_text;

        loop
            fetch ysum_cur into ysum_rec;
            exit when ysum_cur%NOTFOUND;  

            begin

               execute immediate '
                                                               UPDATE PKD.'|| v_out_table ||' 
                set
                                                               EPULET = :sum_all_epulet,
                                                               TARTOSGEP = :sum_all_tartosgep,
                                                               GYORSGEP = :sum_all_gyorsgep,
                                                               JARMU = :sum_all_jarmu,
                                                               SZOFTVER = :sum_all_szoftver
                                                               WHERE rowid=:sorid
                                                                 ' 
                                                               using 
                                                               sum_all_epulet, --sum_all_epulet
                                                               sum_all_tartosgep, --sum_all_tartosgep
                                                               sum_all_gyorsgep, --sum_all_gyorsgep
                                                               sum_all_jarmu, --sum_all_jarmu
                                                               sum_all_szoftver, --sum_all_szoftver
                                                               ysum_rec.row_id --sorid
                                                               ;                             

                               end;
end loop;
close ysum_cur;


                                                               END LOOP;

                                               END LOOP;

                               END LOOP; 

                END IF;

END LOOP;

COMMIT;            

-- SUM_CLASSIC kiszámítása 
tev_phad_sql_text := 'SELECT rowid sorid, EPULET, GYORSGEP, TARTOSGEP, JARMU, SZOFTVER FROM PKD.'|| v_out_table ||' ';

open ysum_cur for tev_phad_sql_text;

        loop
            fetch ysum_cur into ysum_rec;
            exit when ysum_cur%NOTFOUND;  

            begin

                execute immediate '
                                                               UPDATE PKD.'|| v_out_table ||' 
                set
                SUM_CLASSIC = :sum_all
                                                               WHERE rowid=:sorid
                                                                 ' 
                                                               using 
                                                               ROUND(NVL(ysum_rec.EPULET,0) + NVL(ysum_rec.GYORSGEP,0) + NVL(ysum_rec.TARTOSGEP, 0) + NVL(ysum_rec.JARMU, 0) + NVL(ysum_rec.SZOFTVER, 0)), --SUM_CLASSIC
                                                               ysum_rec.row_id --sorid
                                                               ;                                                               

                                               end;
                               end loop;
close ysum_cur;
commit;                              


COMMIT;            


dbms_output.put_line('6. lépés STOP: ' || systimestamp);

------- ^^ KLASSZIKUS MEZŐK
------- ˇˇ NEM KLASSZIKUS MEZŐK


-- 9.lépés: nem klasszikus eszközök importálása

dbms_output.put_line('9. lépés START: ' || systimestamp);

FOR x IN 1..v_in_year.COUNT LOOP

                FOR b IN v_out_nk_eszkcsp.FIRST..v_out_nk_eszkcsp.LAST LOOP 

                               SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_nk_eszkcsp(b) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                               IF v != 0 THEN

                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' ';
                               EXECUTE IMMEDIATE sql_statement INTO v;
                               IF v > 0 THEN

                               FOR c IN F_V_99a.FIRST..F_V_99a.LAST LOOP

                                               EXECUTE IMMEDIATE
                                               'DECLARE
                                                               CURSOR INS_OPS IS SELECT OUTPUT, ALSZEKTOR, AGAZAT, ROUND('|| F_V_99a(c) ||') AS OUTNUM FROM '|| v_out_nk_eszkcsp(b) ||'_'|| v_in_year(x) ||' WHERE AGAZAT != ''SUM'';
                                                               TYPE INS_ARRAY IS TABLE OF INS_OPS%ROWTYPE;
                                                               INS_OPS_ARRAY INS_ARRAY;
                                                 BEGIN
                                               OPEN INS_OPS;
                                               LOOP
                                                 FETCH INS_OPS BULK COLLECT INTO INS_OPS_ARRAY;
                                                 FORALL I IN INS_OPS_ARRAY.FIRST..INS_OPS_ARRAY.LAST
                                               UPDATE '|| v_out_table ||' 
                                               SET '|| v_out_nk_eszkcsp(b) ||' = INS_OPS_ARRAY(I).OUTNUM
                                               WHERE ALSZEKTOR = INS_OPS_ARRAY(I).ALSZEKTOR AND CFC_NET_GRS = INS_OPS_ARRAY(I).OUTPUT AND F_V_99 = '''|| F_V_99(c) ||''' AND EV = '''|| v_in_year(x) ||''' AND AGAZAT = INS_OPS_ARRAY(I).AGAZAT;

                                                 EXIT WHEN INS_OPS%NOTFOUND;
                                               END LOOP;
                                               CLOSE INS_OPS;
                                 END;';

                               END LOOP;

                               END IF;

                               END IF;

                END LOOP;

END LOOP;

COMMIT;

-- A 60-as ORIGINALS értékeket 1995-2002 között S1311-ből S11/59-be

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                               FOR x IN 1..v_in_year.COUNT LOOP

                                               IF ''|| v_szektorok(s) ||'' = 'S1311' THEN

                                               -- S1311a/60 -> S11/59
                                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = ''S11'' ';
                                               EXECUTE IMMEDIATE sql_statement INTO v;

                                               IF v > 0 THEN

                                               IF ''|| v_in_year(x) ||'' IN ('1995', '1996', '1997', '1998', '1999', '2000', '2001', '2002') THEN

                                                               EXECUTE IMMEDIATE'
                                                               UPDATE '|| v_out_table ||'
                                                               SET ORIGINALS = 
                                                               (SELECT (NVL(ORIGINALS, 0)) FROM '|| v_out_table ||' a
                                                               WHERE a.AGAZAT = ''60'' AND a.ALSZEKTOR = ''S1311a'' AND a.CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND a.EV = '''|| v_in_year(x) ||''' AND a.F_V_99 = '''|| F_V_99(b) ||''') + (SELECT (NVL(ORIGINALS, 0)) FROM '|| v_out_table ||' a
                                                               WHERE a.AGAZAT = ''59'' AND a.ALSZEKTOR = ''S11'' AND a.CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND a.EV = '''|| v_in_year(x) ||''' AND a.F_V_99 = '''|| F_V_99(b) ||''')
                                                               WHERE AGAZAT = ''59'' AND ALSZEKTOR = ''S11'' AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND EV = '''|| v_in_year(x) ||''' AND F_V_99 = '''|| F_V_99(b) ||'''
                                                               '
                                                               ;

                                                               EXECUTE IMMEDIATE'
                                                               UPDATE '|| v_out_table ||'
                                                               SET ORIGINALS = ''0''
                                                               WHERE AGAZAT = ''60'' AND ALSZEKTOR = ''S1311a'' AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND EV = '''|| v_in_year(x) ||''' AND F_V_99 = '''|| F_V_99(b) ||'''
                                                               '
                                                               ;

                                               END IF;

                                               END IF;                                                                

                                               END IF;

                               END LOOP;

                END LOOP;

END LOOP;         

END LOOP;

COMMIT;

-- A K+F értékeket 2007-2017 között S1311a-ból S1311-be

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 

                               FOR x IN 1..v_in_year.COUNT LOOP

                                               IF ''|| v_szektorok(s) ||'' = 'S1311a' THEN

                                               -- S1311/722 + S1311a/723 -> S1311/722
                                               sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = ''S1311'' ';
                                               EXECUTE IMMEDIATE sql_statement INTO v;

                                               IF v > 0 THEN

                                               IF ''|| v_in_year(x) ||'' IN ('2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017') THEN

                                                               EXECUTE IMMEDIATE'
                                                               UPDATE '|| v_out_table ||'
                                                               SET K_F = 
                                                               (SELECT (NVL(K_F, 0)) FROM '|| v_out_table ||' a
                                                               WHERE a.AGAZAT = ''723'' AND a.ALSZEKTOR = ''S1311a'' AND a.CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND a.EV = '''|| v_in_year(x) ||''' AND a.F_V_99 = '''|| F_V_99(b) ||''') + (SELECT (NVL(K_F, 0)) FROM '|| v_out_table ||' a
                                                               WHERE a.AGAZAT = ''722'' AND a.ALSZEKTOR = ''S1311'' AND a.CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND a.EV = '''|| v_in_year(x) ||''' AND a.F_V_99 = '''|| F_V_99(b) ||''')
                                                               WHERE AGAZAT = ''722'' AND ALSZEKTOR = ''S1311'' AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND EV = '''|| v_in_year(x) ||''' AND F_V_99 = '''|| F_V_99(b) ||'''
                                                               '
                                                               ;

                                                               EXECUTE IMMEDIATE'
                                                               UPDATE '|| v_out_table ||'
                                                               SET K_F = ''0''
                                                               WHERE AGAZAT IN (''723'', ''SUM'') AND ALSZEKTOR = ''S1311a'' AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND EV = '''|| v_in_year(x) ||''' AND F_V_99 = '''|| F_V_99(b) ||'''
                                                               '
                                                               ;

                                               END IF;

                                               END IF;                                                                

                                               END IF;

                               END LOOP;

                END LOOP;

END LOOP;         

END LOOP;

-- 2008 és 2011-ben K+F kerekített S1311/721-es értékhez + 1 értéket hozzáadunk.
FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                IF ''|| v_szektorok(s) ||'' = 'S1311' THEN

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET K_F = 
                               (SELECT ROUND(NVL(K_F, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''721'' AND a.ALSZEKTOR = ''S1311'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2008'' AND a.F_V_99 = ''F'') + 1
                               WHERE AGAZAT = ''721'' AND ALSZEKTOR = ''S1311'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2008'' AND F_V_99 = ''F''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET K_F = 
                               (SELECT ROUND(NVL(K_F, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''721'' AND a.ALSZEKTOR = ''S1311'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2011'' AND a.F_V_99 = ''F'') + 1
                               WHERE AGAZAT = ''721'' AND ALSZEKTOR = ''S1311'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2011'' AND F_V_99 = ''F''
                               '
                               ;

                END IF;

END LOOP;


-- 2017-ben FOLDJAVITAS kerekített S1313/39-ben + 3, S1313/84-ben -5 értékkel számolunk (F és CFC)
-- FOLDJAVITAS kerekített S1313/39-ben: 2015: +8, 2016: +9, 2017: +12 (V és CFC)
-- FOLDJAVITAS kerekített S1313/84-ben: 2015: -8, 2016: -8, 2017: -13 (V és CFC)

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                IF ''|| v_szektorok(s) ||'' = 'S1313' THEN

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''39'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2017'' AND a.F_V_99 = ''F'') + 3
                               WHERE AGAZAT = ''39'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2017'' AND F_V_99 = ''F''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''84'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2017'' AND a.F_V_99 = ''F'') + 5
                               WHERE AGAZAT = ''84'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2017'' AND F_V_99 = ''F''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''39'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2015'' AND a.F_V_99 = ''V'') + 8
                               WHERE AGAZAT = ''39'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2015'' AND F_V_99 = ''V''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''39'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2016'' AND a.F_V_99 = ''V'') + 9
                               WHERE AGAZAT = ''39'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2016'' AND F_V_99 = ''V''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''39'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2017'' AND a.F_V_99 = ''V'') + 12
                               WHERE AGAZAT = ''39'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2017'' AND F_V_99 = ''V''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''84'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2015'' AND a.F_V_99 = ''V'') - 8
                               WHERE AGAZAT = ''84'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2015'' AND F_V_99 = ''V''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''84'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2016'' AND a.F_V_99 = ''V'') - 8
                               WHERE AGAZAT = ''84'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2016'' AND F_V_99 = ''V''
                               '
                               ;

                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||'
                               SET FOLDJAVITAS = 
                               (SELECT ROUND(NVL(FOLDJAVITAS, 0)) FROM '|| v_out_table ||' a
                               WHERE a.AGAZAT = ''84'' AND a.ALSZEKTOR = ''S1313'' AND a.CFC_NET_GRS = ''cfc'' AND a.EV = ''2017'' AND a.F_V_99 = ''V'') - 13
                               WHERE AGAZAT = ''84'' AND ALSZEKTOR = ''S1313'' AND CFC_NET_GRS = ''cfc'' AND EV = ''2017'' AND F_V_99 = ''V''
                               '
                               ;

                END IF;

END LOOP;


dbms_output.put_line('9. lépés STOP: ' || systimestamp);

-- 10. lépés: CFC_IMPUTALT tábla értékeit hozzáadjuk a meglévő értékekhez

dbms_output.put_line('10. lépés START: ' || systimestamp);

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

sql_statement := 'SELECT COUNT(*) FROM PKD.'|| cfc_imputalt ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
EXECUTE IMMEDIATE sql_statement INTO v;
IF v > 0 THEN

FOR c IN v_out_nk_up.FIRST..3 LOOP -- csak ORIGINALS, FEGYVER, K_F

                FOR d IN F_V_99.FIRST..F_V_99.LAST LOOP

                               sql_statement := 'SELECT COUNT(*) FROM PKD.'|| cfc_imputalt ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' AND ESZKOZCSP = '''|| v_out_nk_up_c(c) ||''' AND F_V = '''|| F_V_99(d) ||''' ';
                               EXECUTE IMMEDIATE sql_statement INTO v;
                               IF v > 0 THEN

                               sql_statement := 'SELECT DISTINCT AGAZAT FROM PKD.'|| cfc_imputalt ||' WHERE ESZKOZCSP = '''|| v_out_nk_up_c(c) ||''' AND F_V = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                               EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat;

                                FOR b IN v_in_year.FIRST..v_in_year.LAST LOOP

                                               IF ''|| v_in_year(b) ||'' = '1995'
                                                               THEN v_update := 'Y1995';
                                               ELSIF ''|| v_in_year(b) ||'' = '1996'
                                                               THEN v_update := 'Y1996';
                                               ELSIF ''|| v_in_year(b) ||'' = '1997'
                                                               THEN v_update := 'Y1997';          
                                               ELSIF ''|| v_in_year(b) ||'' = '1998'
                                                               THEN v_update := 'Y1998';
                                               ELSIF ''|| v_in_year(b) ||'' = '1999'
                                                               THEN v_update := 'Y1999';
                                               ELSIF ''|| v_in_year(b) ||'' = '2000'
                                                               THEN v_update := 'Y2000';
                                               ELSIF ''|| v_in_year(b) ||'' = '2001'
                                                               THEN v_update := 'Y2001';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2002'
                                                               THEN v_update := 'Y2002';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2003'
                                                               THEN v_update := 'Y2003';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2004'
                                                               THEN v_update := 'Y2004';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2005'
                                                               THEN v_update := 'Y2005';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2006'
                                                               THEN v_update := 'Y2006';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2007'
                                                               THEN v_update := 'Y2007';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2008'
                                                               THEN v_update := 'Y2008';                                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2009'
                                                               THEN v_update := 'Y2009';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2010'
                                                               THEN v_update := 'Y2010';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2011'
                                                               THEN v_update := 'Y2011';
                                               ELSIF ''|| v_in_year(b) ||'' = '2012'
                                                               THEN v_update := 'Y2012';
                                               ELSIF ''|| v_in_year(b) ||'' = '2013'
                                                               THEN v_update := 'Y2013';
                                               ELSIF ''|| v_in_year(b) ||'' = '2014'
                                                               THEN v_update := 'Y2014';
                                               ELSIF ''|| v_in_year(b) ||'' = '2015'
                                                               THEN v_update := 'Y2015';
                                               ELSIF ''|| v_in_year(b) ||'' = '2016'
                                                               THEN v_update := 'Y2016';
                                               ELSIF ''|| v_in_year(b) ||'' = '2017'
                                                               THEN v_update := 'Y2017';
                                               ELSIF ''|| v_in_year(b) ||'' = '2018'
                                                               THEN v_update := 'Y2018';
                                               END IF;

                                               IF (''|| v_out_nk_up_c(c) ||'' = 'AN1174' AND ''|| v_szektorok(s) ||'' IN ('S11', 'S1311a', 'S1313a', 'S14'))  -- ORIGINALS: S11, S1311a, S1313a, S14
                                                               OR
                                               (''|| v_out_nk_up_c(c) ||'' = 'AN114' AND ''|| v_szektorok(s) ||'' = 'S1311') -- FEGYVER: S1311
                                                               OR 
                                               (''|| v_out_nk_up_c(c) ||'' = 'AN1171' AND ''|| v_szektorok(s) ||'' IN ('S1311', 'S15')) -- K_F: S1311, S15
                                               THEN

                                                               FOR e IN v_agazat.FIRST..v_agazat.LAST LOOP

                                                                              EXECUTE IMMEDIATE'
                                                                              UPDATE PKD.'|| v_out_table ||' 
                                                                              SET '|| v_out_nk_up(c) ||' =
                                                                              (SELECT ROUND(NVL('|| v_update ||', 0)) FROM PKD.'|| cfc_imputalt ||' WHERE ESZKOZCSP = '''|| v_out_nk_up_c(c) ||''' AND F_V = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = '''|| v_agazat(e) ||''' 
                                                                              ) + (SELECT NVL('|| v_out_nk_up(c) ||', 0) FROM PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = '''|| v_agazat(e) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_in_year(b) ||''')
                                                                              WHERE F_V_99 = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = '''|| v_agazat(e) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_in_year(b) ||'''
                                                                              '
                                                                              ;

                                                               END LOOP;

                                               END IF; 

                               END LOOP;

                               END IF;

                END LOOP;

END LOOP;


FOR c IN v_out_eszkcsp_c.FIRST..v_out_eszkcsp_c.LAST LOOP -- csak ÉPÜLET, JÁRMŰ, TARTÓSGÉP, SZOFTVER

                FOR d IN F_V_99.FIRST..F_V_99.LAST LOOP

                               sql_statement := 'SELECT COUNT(*) FROM PKD.'|| cfc_imputalt ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' AND ESZKOZCSP = '''|| v_out_eszkcsp_c(c) ||''' AND F_V = '''|| F_V_99(d) ||''' ';
                               EXECUTE IMMEDIATE sql_statement INTO v;
                               IF v > 0 THEN

                               sql_statement := 'SELECT DISTINCT AGAZAT FROM PKD.'|| cfc_imputalt ||' WHERE ESZKOZCSP = '''|| v_out_eszkcsp_c(c) ||''' AND F_V = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                               EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat;

                               FOR b IN v_in_year.FIRST..v_in_year.LAST LOOP

                                               IF ''|| v_in_year(b) ||'' = '1995'
                                                               THEN v_update := 'Y1995';
                                               ELSIF ''|| v_in_year(b) ||'' = '1996'
                                                               THEN v_update := 'Y1996';
                                               ELSIF ''|| v_in_year(b) ||'' = '1997'
                                                               THEN v_update := 'Y1997';          
                                               ELSIF ''|| v_in_year(b) ||'' = '1998'
                                                               THEN v_update := 'Y1998';
                                               ELSIF ''|| v_in_year(b) ||'' = '1999'
                                                               THEN v_update := 'Y1999';
                                               ELSIF ''|| v_in_year(b) ||'' = '2000'
                                                               THEN v_update := 'Y2000';
                                               ELSIF ''|| v_in_year(b) ||'' = '2001'
                                                               THEN v_update := 'Y2001';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2002'
                                                               THEN v_update := 'Y2002';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2003'
                                                               THEN v_update := 'Y2003';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2004'
                                                               THEN v_update := 'Y2004';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2005'
                                                               THEN v_update := 'Y2005';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2006'
                                                               THEN v_update := 'Y2006';                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2007'
                                                               THEN v_update := 'Y2007';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2008'
                                                               THEN v_update := 'Y2008';                                                         
                                               ELSIF ''|| v_in_year(b) ||'' = '2009'
                                                               THEN v_update := 'Y2009';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2010'
                                                               THEN v_update := 'Y2010';          
                                               ELSIF ''|| v_in_year(b) ||'' = '2011'
                                                               THEN v_update := 'Y2011';
                                               ELSIF ''|| v_in_year(b) ||'' = '2012'
                                                               THEN v_update := 'Y2012';
                                               ELSIF ''|| v_in_year(b) ||'' = '2013'
                                                               THEN v_update := 'Y2013';
                                               ELSIF ''|| v_in_year(b) ||'' = '2014'
                                                               THEN v_update := 'Y2014';
                                               ELSIF ''|| v_in_year(b) ||'' = '2015'
                                                               THEN v_update := 'Y2015';
                                               ELSIF ''|| v_in_year(b) ||'' = '2016'
                                                               THEN v_update := 'Y2016';
                                               ELSIF ''|| v_in_year(b) ||'' = '2017'
                                                               THEN v_update := 'Y2017';
                                               ELSIF ''|| v_in_year(b) ||'' = '2018'
                                                               THEN v_update := 'Y2018';                                                         
                                               END IF;

                                               IF ''|| v_out_eszkcsp_c(c) ||'' IN ('AN112', 'AN1131', 'AN1139t', 'AN1173s') AND ''|| v_szektorok(s) ||'' = 'S12'  -- ÉPÜLET, JÁRMű, TARTÓSGÉP, SZOFTVER: S12

                                               THEN

                                                               FOR e IN v_agazat.FIRST..v_agazat.LAST LOOP

                                                                              EXECUTE IMMEDIATE'
                                                                              UPDATE PKD.'|| v_out_table ||' 
                                                                              SET '|| v_out_eszkcsp(c) ||' =
                                                                              (SELECT ROUND(NVL('|| v_update ||', 0)) FROM PKD.'|| cfc_imputalt ||' WHERE ESZKOZCSP = '''|| v_out_eszkcsp_c(c) ||''' AND F_V = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = '''|| v_agazat(e) ||''' 
                                                                              ) + (SELECT NVL('|| v_out_eszkcsp(c) ||', 0) FROM PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = '''|| v_agazat(e) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_in_year(b) ||''')
                                                                              WHERE F_V_99 = '''|| F_V_99(d) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = '''|| v_agazat(e) ||''' AND CFC_NET_GRS = ''cfc'' AND EV = '''|| v_in_year(b) ||'''
                                                                              '
                                                                              ;

                                                               END LOOP;

                                               END IF; 

                               END LOOP;

                               END IF;

                END LOOP;

END LOOP;

END IF;

END LOOP;

dbms_output.put_line('10. lépés STOP: ' || systimestamp);


-- 11. lépés: 3 jegyű ágazatok összevonása

dbms_output.put_line('11. lépés START: ' || systimestamp);

-- 3 jegyű táblába átírás
FOR a IN v_out_nk_eszkcsp_3.FIRST..v_out_nk_eszkcsp_3.LAST LOOP

                FOR l IN v_3_agazat.FIRST..v_3_agazat.LAST LOOP

                               FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                                               FOR x IN v_in_year.FIRST..v_in_year.LAST LOOP

                                                               FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                                                                              FOR b IN F_V_99.FIRST..F_V_99.LAST LOOP

                                                                                              EXECUTE IMMEDIATE'
                                                                                              UPDATE '|| v_out_table_all ||'
                                                                                              SET '|| v_out_nk_eszkcsp_3(a) ||' = 
                                                                                              (SELECT '|| v_out_nk_eszkcsp_3(a) ||' FROM '|| v_out_table ||'
                                                                                              WHERE AGAZAT = '''|| v_3_agazat(l) ||''' 
                                                                                              AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND EV = '''|| v_in_year(x) ||''' AND 
                                                                                              F_V_99 = '''|| F_V_99(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''')
                                                                                              WHERE AGAZAT = '''|| v_3_agazat(l) ||''' 
                                                                                              AND CFC_NET_GRS = '''|| v_out_cfc(z) ||''' AND EV = '''|| v_in_year(x) ||''' AND 
                                                                                              F_V_99 = '''|| F_V_99(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''
                                                                                              '
                                                                                              ;

                                                                              END LOOP;

                                                               END LOOP;

                                               END LOOP;

                               END LOOP;

                END LOOP;

END LOOP;

-- összevonás
FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

-- S1311 esetén: AN1123 (földjavítás), AN1171 (K_F), AN1174 (originals), AN1173o (ownsoft), AN114 (fegyver):
                                               -- 72, 721, 722, 723 -> 72
                                               -- 84, 841, 842, 843, 844, 845, 846 -> 84

FOR z IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                IF ''|| v_szektorok(s) ||'' = 'S1311' THEN

                               FOR x IN 1..v_in_year.COUNT LOOP

                                               FOR a IN v_out_nk_eszkcsp.FIRST..v_out_nk_eszkcsp.LAST LOOP 

                                                               IF ''|| v_out_nk_eszkcsp_c(a) ||'' IN ('AN1123', 'AN1171', 'AN1174', 'AN1173o', 'AN114') THEN  

                                                                              FOR b IN F_V_99a.FIRST..F_V_99a.LAST LOOP 


                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_nk_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                              PKD.AGAZAT_OSSZEVONAS_NK('72', '''72'', ''721'', ''722''', '''721'', ''722'', ''723''', ''|| v_out_table ||'', ''|| v_out_nk_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');

                                                                                              END IF;


                                                                                              SELECT COUNT(*) INTO v FROM user_tab_cols WHERE table_name = ''|| v_out_nk_eszkcsp(a) ||'_'|| v_in_year(x) ||''; -- létezik az input tábla?
                                                                                              IF v != 0 THEN

                                                                                                              PKD.AGAZAT_OSSZEVONAS_NK('84', '''84'', ''841'', ''842'', ''843'', ''844'', ''845'', ''846''', '''841'', ''842'', ''843'', ''844'', ''845'', ''846''', ''|| v_out_table ||'', ''|| v_out_nk_eszkcsp(a) ||'', ''|| F_V_99(b) ||'', ''|| v_szektorok(s) ||'', ''|| v_out_cfc(z) ||'', ''|| v_in_year(x) ||'');


                                                                                              END IF;

                                                                              END LOOP;

                                                               END IF;

                                               END LOOP;

                               END LOOP;

                END IF;

END LOOP;         

END LOOP;         

COMMIT;            

dbms_output.put_line('11. lépés STOP: ' || systimestamp);



-- 12. lépés: SUM rekord újraszámítása nem klasszikusok esetében

v_out_nk_eszkcsp(1) := 'ORIGINALS'; --AN1174
v_out_nk_eszkcsp(2) := 'FOLDJAVITAS'; --AN1123
v_out_nk_eszkcsp(3) := 'K_F'; --AN1171
v_out_nk_eszkcsp(4) := 'FEGYVER'; --AN114
v_out_nk_eszkcsp(5) := 'OWNSOFT'; --AN1173o
v_out_nk_eszkcsp(6) := 'NOE6'; 
v_out_nk_eszkcsp(7) := 'KISERTEKU'; 
v_out_nk_eszkcsp(8) := 'WIZZ'; 
v_out_nk_eszkcsp(9) := 'TCF'; 
v_out_nk_eszkcsp(10) := 'EGYEB_ORIG'; 


dbms_output.put_line('12. lépés START: ' || systimestamp);

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                EXECUTE IMMEDIATE sql_statement INTO v;
                IF v > 0 THEN

                               FOR z IN F_V_99.FIRST..F_V_99.LAST LOOP

                                               FOR b IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                                                               FOR x IN v_in_year.FIRST..v_in_year.LAST LOOP

                                               execute immediate 'select ROUND(SUM(NVL(ORIGINALS, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_originals;
                                               execute immediate 'select ROUND(SUM(NVL(FOLDJAVITAS, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO SUM_ALL_FOLDJAVITAS;                                      
                                               execute immediate 'select ROUND(SUM(NVL(K_F, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_K_F;
                                               execute immediate 'select ROUND(SUM(NVL(FEGYVER, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_FEGYVER;
                                               execute immediate 'select ROUND(SUM(NVL(OWNSOFT, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_OWNSOFT; 
                                               execute immediate 'select ROUND(SUM(NVL(NOE6, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_NOE6;           
                                               execute immediate 'select ROUND(SUM(NVL(KISERTEKU, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_KISERTEKU; 
                                               execute immediate 'select ROUND(SUM(NVL(TCF, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_TCF;          
                                               execute immediate 'select ROUND(SUM(NVL(EGYEB_ORIG, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_EGYEB_ORIG;            
                                               execute immediate 'select ROUND(SUM(NVL(WIZZ, 0))) from PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||'''' INTO sum_all_WIZZ;            
                               
                               
tev_phad_sql_text := 'SELECT rowid sorid, ORIGINALS, FOLDJAVITAS, K_F, FEGYVER, OWNSOFT, NOE6, KISERTEKU, TCF, EGYEB_ORIG, WIZZ FROM PKD.'|| v_out_table ||' WHERE F_V_99 = '''|| F_V_99(z) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(b) ||''' AND EV = '''|| v_in_year(x) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND AGAZAT = ''SUM'' ';

open ysum_cur_nk for tev_phad_sql_text;

        loop
            fetch ysum_cur_nk into ysum_rec_nk;
            exit when ysum_cur_nk%NOTFOUND;  

            begin

                execute immediate '
                                                               UPDATE PKD.'|| v_out_table ||' 
                set
                                                               ORIGINALS = :sum_all_originals,
                                                               FOLDJAVITAS = :sum_all_foldjavitas,
                                                               K_F = :sum_all_k_f,
                                                               FEGYVER = :sum_all_FEGYVER,
                                                               OWNSOFT = :sum_all_ownsoft,
                                                               NOE6 = :sum_all_NOE6, 
                                                               KISERTEKU = :sum_all_KISERTEKU,
                                                               TCF = :sum_all_TCF,
                                                               EGYEB_ORIG = :sum_all_EGYEB_ORIG,
                                                               WIZZ = :sum_all_WIZZ
                                                               WHERE rowid=:sorid
                                                                 ' 
                                                               using 
                                                               sum_all_originals, --sum_all_epulet
                                                               sum_all_foldjavitas, --sum_all_tartosgep
                                                               sum_all_k_f, --sum_all_k_f
                                                               sum_all_FEGYVER, --sum_all_jarmu
                                                               sum_all_ownsoft, --sum_all_szoftver
                                                               sum_all_NOE6,
                                                               sum_all_KISERTEKU,
                                                               sum_all_TCF,
                                                               sum_all_EGYEB_ORIG,
                                                               sum_all_WIZZ,
                                                               ysum_rec_nk.row_id --sorid
                                                               ;                             

                               end;
end loop;
close ysum_cur_nk;


                                                               END LOOP;

                                               END LOOP;

                               END LOOP; 

                END IF;

END LOOP;                         

COMMIT;

dbms_output.put_line('12. lépés STOP: ' || systimestamp);



-- 13. lépés: CFC_LAKAS_MEZO tábla értékeit beillesztjük

dbms_output.put_line('13. lépés START: ' || systimestamp);

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

FOR c IN 4..5 LOOP -- csak a LAKAS és MEZO értékeket vesszük át

sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
EXECUTE IMMEDIATE sql_statement INTO v;

IF v > 0 THEN

sql_statement := 'SELECT COUNT(*) FROM '|| cfc_lakas ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
EXECUTE IMMEDIATE sql_statement INTO v;

IF v > 0 THEN

                FOR b IN v_in_year.FIRST..v_in_year.LAST LOOP -- 1995->2000 + 2012

                               IF ''|| v_in_year(b) ||'' = '1995'
                                               THEN v_update := 'Y1995';
                               ELSIF ''|| v_in_year(b) ||'' = '1996'
                                               THEN v_update := 'Y1996';
                               ELSIF ''|| v_in_year(b) ||'' = '1997'
                                               THEN v_update := 'Y1997';          
                               ELSIF ''|| v_in_year(b) ||'' = '1998'
                                               THEN v_update := 'Y1998';
                               ELSIF ''|| v_in_year(b) ||'' = '1999'
                                               THEN v_update := 'Y1999';
                               ELSIF ''|| v_in_year(b) ||'' = '2000'
                                               THEN v_update := 'Y2000';
                               ELSIF ''|| v_in_year(b) ||'' = '2001'
                                               THEN v_update := 'Y2001';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2002'
                                               THEN v_update := 'Y2002';          
                               ELSIF ''|| v_in_year(b) ||'' = '2003'
                                               THEN v_update := 'Y2003';          
                               ELSIF ''|| v_in_year(b) ||'' = '2004'
                                               THEN v_update := 'Y2004';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2005'
                                               THEN v_update := 'Y2005';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2006'
                                               THEN v_update := 'Y2006';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2007'
                                               THEN v_update := 'Y2007';          
                               ELSIF ''|| v_in_year(b) ||'' = '2008'
                                               THEN v_update := 'Y2008';                                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2009'
                                               THEN v_update := 'Y2009';          
                               ELSIF ''|| v_in_year(b) ||'' = '2010'
                                               THEN v_update := 'Y2010';          
                               ELSIF ''|| v_in_year(b) ||'' = '2011'
                                               THEN v_update := 'Y2011';
                               ELSIF ''|| v_in_year(b) ||'' = '2012'
                                               THEN v_update := 'Y2012';
                               ELSIF ''|| v_in_year(b) ||'' = '2013'
                                               THEN v_update := 'Y2013';
                               ELSIF ''|| v_in_year(b) ||'' = '2014'
                                               THEN v_update := 'Y2014';
                               ELSIF ''|| v_in_year(b) ||'' = '2015'
                                               THEN v_update := 'Y2015';
                               ELSIF ''|| v_in_year(b) ||'' = '2016'
                                               THEN v_update := 'Y2016';
                               ELSIF ''|| v_in_year(b) ||'' = '2017'
                                               THEN v_update := 'Y2017';
                               ELSIF ''|| v_in_year(b) ||'' = '2018'
                                                               THEN v_update := 'Y2018';
                               END IF;

                               EXECUTE IMMEDIATE
                 'DECLARE
                    CURSOR INS_OPS IS SELECT F_V, OUTPUT, ALSZEKTOR, ESZKOZ, AGAZAT, ROUND('|| v_update ||') as UPD FROM '|| cfc_lakas ||' 
                                               WHERE ESZKOZ = '''|| v_out_nk_up_c(c) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''';
                    TYPE INS_ARRAY IS TABLE OF INS_OPS%ROWTYPE;
                    INS_OPS_ARRAY INS_ARRAY;
                  BEGIN
                    OPEN INS_OPS;
                    LOOP
                      FETCH INS_OPS BULK COLLECT INTO INS_OPS_ARRAY;
                      FORALL I IN INS_OPS_ARRAY.FIRST..INS_OPS_ARRAY.LAST
                               UPDATE '|| v_out_table ||' 
                               SET '|| v_out_nk_up(c) ||' = INS_OPS_ARRAY(I).UPD
                               WHERE ALSZEKTOR = INS_OPS_ARRAY(I).ALSZEKTOR AND CFC_NET_GRS = INS_OPS_ARRAY(I).OUTPUT AND EV = '''|| v_in_year(b) ||''' AND AGAZAT = INS_OPS_ARRAY(I).AGAZAT AND F_V_99 = INS_OPS_ARRAY(I).F_V;

                      EXIT WHEN INS_OPS%NOTFOUND;
                    END LOOP;
                    CLOSE INS_OPS;
                  END;';

                  COMMIT;

                  FOR x IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                               FOR y IN F_V_99.FIRST..F_V_99.LAST LOOP

                                 sql_statement := 'SELECT COUNT(*) FROM PKD.'|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(x) ||''' AND F_V_99 = '''|| F_V_99(y) ||''' ';
                                 EXECUTE IMMEDIATE sql_statement INTO v;

                                               IF v > 0 THEN

                                                               EXECUTE IMMEDIATE'
                                                               UPDATE PKD.'|| v_out_table ||'
                                                               SET '|| v_out_nk_up(c) ||' = 
                                                               (SELECT SUM(NVL('|| v_out_nk_up(c) ||', 0))
                                                               FROM PKD.'|| v_out_table ||'
                                                               WHERE EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(x) ||''' AND F_V_99 = '''|| F_V_99(y) ||'''  AND AGAZAT != ''SUM'')
                                                               WHERE AGAZAT = ''SUM'' AND EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(x) ||''' AND F_V_99 = '''|| F_V_99(y) ||'''
                                                               '
                                                               ;

                                               END IF;

                               END LOOP;

                  END LOOP;

                END LOOP;

END IF;

END IF;

END LOOP;

END LOOP;

dbms_output.put_line('13. lépés STOP: ' || systimestamp);

-- 14.lépés: CFC_BES_VALL_F táblából az F adatok átvétele a BESOROLT_VALL mezőbe S1311a és S1313a esetén, V érték számítás 2016-ig bezárólag

dbms_output.put_line('14. lépés START: ' || systimestamp);

FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                IF ''|| v_szektorok(s) ||'' IN ('S1311a', 'S1313a') THEN

                sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                EXECUTE IMMEDIATE sql_statement INTO v;

                IF v > 0 THEN

                FOR b IN v_in_year.FIRST..v_in_year.LAST LOOP

                               IF ''|| v_in_year(b) ||'' = '1995'
                                               THEN v_update := 'Y1995';
                               ELSIF ''|| v_in_year(b) ||'' = '1996'
                                               THEN v_update := 'Y1996';
                               ELSIF ''|| v_in_year(b) ||'' = '1997'
                                               THEN v_update := 'Y1997';          
                               ELSIF ''|| v_in_year(b) ||'' = '1998'
                                               THEN v_update := 'Y1998';
                               ELSIF ''|| v_in_year(b) ||'' = '1999'
                                               THEN v_update := 'Y1999';
                               ELSIF ''|| v_in_year(b) ||'' = '2000'
                                               THEN v_update := 'Y2000';
                               ELSIF ''|| v_in_year(b) ||'' = '2001'
                                               THEN v_update := 'Y2001';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2002'
                                               THEN v_update := 'Y2002';          
                               ELSIF ''|| v_in_year(b) ||'' = '2003'
                                               THEN v_update := 'Y2003';          
                               ELSIF ''|| v_in_year(b) ||'' = '2004'
                                               THEN v_update := 'Y2004';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2005'
                                               THEN v_update := 'Y2005';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2006'
                                               THEN v_update := 'Y2006';                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2007'
                                               THEN v_update := 'Y2007';          
                               ELSIF ''|| v_in_year(b) ||'' = '2008'
                                               THEN v_update := 'Y2008';                                                         
                               ELSIF ''|| v_in_year(b) ||'' = '2009'
                                               THEN v_update := 'Y2009';          
                               ELSIF ''|| v_in_year(b) ||'' = '2010'
                                               THEN v_update := 'Y2010';          
                               ELSIF ''|| v_in_year(b) ||'' = '2011'
                                               THEN v_update := 'Y2011';
                               ELSIF ''|| v_in_year(b) ||'' = '2012'
                                               THEN v_update := 'Y2012';
                               ELSIF ''|| v_in_year(b) ||'' = '2013'
                                               THEN v_update := 'Y2013';
                               ELSIF ''|| v_in_year(b) ||'' = '2014'
                                               THEN v_update := 'Y2014';
                               ELSIF ''|| v_in_year(b) ||'' = '2015'
                                               THEN v_update := 'Y2015';
                               ELSIF ''|| v_in_year(b) ||'' = '2016'
                                               THEN v_update := 'Y2016';
                               ELSIF ''|| v_in_year(b) ||'' = '2017'
                                               THEN v_update := 'Y2017';
                               ELSIF ''|| v_in_year(b) ||'' = '2018'
                                               THEN v_update := 'Y2018';
                                               END IF;

                               EXECUTE IMMEDIATE
                 'DECLARE
                    CURSOR INS_OPS IS SELECT ALSZEKTOR, AGAZAT, ROUND('|| v_update ||') as UPD FROM '|| cfc_besorolt ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''';
                    TYPE INS_ARRAY IS TABLE OF INS_OPS%ROWTYPE;
                    INS_OPS_ARRAY INS_ARRAY;
                  BEGIN
                    OPEN INS_OPS;
                    LOOP
                      FETCH INS_OPS BULK COLLECT INTO INS_OPS_ARRAY;
                      FORALL I IN INS_OPS_ARRAY.FIRST..INS_OPS_ARRAY.LAST
                               UPDATE '|| v_out_table ||' 
                               SET BESOROLT_VALL = INS_OPS_ARRAY(I).UPD
                               WHERE ALSZEKTOR = INS_OPS_ARRAY(I).ALSZEKTOR AND EV = '''|| v_in_year(b) ||''' AND AGAZAT = INS_OPS_ARRAY(I).AGAZAT AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'';

                      EXIT WHEN INS_OPS%NOTFOUND;
                    END LOOP;
                    CLOSE INS_OPS;
                  END;'; 

                  COMMIT;


                  FOR a IN v_out_eszkcsp_c.FIRST..v_out_eszkcsp_c.LAST LOOP

                  sql_statement := 'SELECT AGAZAT FROM '|| cfc_besorolt_a ||' WHERE '|| v_out_eszkcsp_c(a) ||' IS NOT NULL AND ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                  EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat;

                               FOR c IN v_agazat.FIRST..v_agazat.LAST LOOP

                  -- arányok alapján szétosztás a mezők között (klasszikus mezők)
                               EXECUTE IMMEDIATE'
                               UPDATE '|| v_out_table ||' 
                               SET '|| v_out_eszkcsp(a) ||' =
                               (SELECT ROUND(a.BESOROLT_VALL * (0.01 * b.'|| v_out_eszkcsp_c(a) ||'))
                               FROM '|| v_out_table ||' a INNER JOIN '|| cfc_besorolt_a ||' b ON a.AGAZAT = b.AGAZAT AND a.ALSZEKTOR = b.ALSZEKTOR WHERE a.ALSZEKTOR = '''|| v_szektorok(s) ||''' AND a.AGAZAT = '''|| v_agazat(c) ||''' AND a.EV = '''|| v_in_year(b) ||''' AND a.F_V_99 = ''F'' AND a.CFC_NET_GRS = ''cfc'')
                               WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' AND EV = '''|| v_in_year(b) ||''' AND AGAZAT = '''|| v_agazat(c) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc''
                               '
                               ;


                               COMMIT;

                               END LOOP;

                  END LOOP;


-- SUM_CLASSIC kiszámítása 
tev_phad_sql_text := 'SELECT rowid sorid, EPULET, GYORSGEP, TARTOSGEP, JARMU, SZOFTVER FROM PKD.'|| v_out_table ||' ';

open ysum_cur for tev_phad_sql_text;

        loop
            fetch ysum_cur into ysum_rec;
            exit when ysum_cur%NOTFOUND;  

            begin

                execute immediate '
                                                               UPDATE PKD.'|| v_out_table ||' 
                set
                SUM_CLASSIC = :sum_classic
                                                               WHERE rowid=:sorid
                                                                 ' 
                                                               using 
                                                               ROUND(NVL(ysum_rec.EPULET,0) + NVL(ysum_rec.GYORSGEP,0) + NVL(ysum_rec.TARTOSGEP, 0) + NVL(ysum_rec.JARMU, 0) + NVL(ysum_rec.SZOFTVER, 0)), --SUM_CLASSIC
                                                               ysum_rec.row_id --sorid
                                                               ;                                                               

                                               end;
                               end loop;
close ysum_cur;
commit;                                                                


-- BESOROLT_VALL és SUM_CLASSIC mező összehasonlítása: ha eltérés van, akkor akkor a BESOROLT_VALL mező értékét vegye fel a SUM_CLASSIC, a különbséget pedig rá kell tenni az 5 klasszikus eszköz közül arra, amelyik a legnagyobb

FOR a IN 13..v_in_year.LAST LOOP  --2007-től

sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE BESOROLT_VALL != SUM_CLASSIC AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND SUM_CLASSIC IS NOT NULL AND EV = '''|| v_in_year(a) ||''' AND AGAZAT != ''SUM'' ';
EXECUTE IMMEDIATE sql_statement INTO v;

IF v > 0 THEN

sql_statement := 'SELECT AGAZAT FROM '|| v_out_table ||' WHERE BESOROLT_VALL != SUM_CLASSIC AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND SUM_CLASSIC IS NOT NULL AND EV = '''|| v_in_year(a) ||''' AND AGAZAT != ''SUM''';
EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat;

FOR b IN v_agazat.FIRST..v_agazat.LAST LOOP

                sql_statement := 'SELECT EPULET FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND cfc_net_grs = ''cfc'' and F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement INTO bes_vall_ertek1;

                sql_statement := 'SELECT TARTOSGEP FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND cfc_net_grs = ''cfc'' and F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement INTO bes_vall_ertek2;

                IF bes_vall_ertek2 > bes_vall_ertek1 THEN bes_vall_ertek := bes_vall_ertek2; ELSE bes_vall_ertek := bes_vall_ertek1; END IF;
                IF bes_vall_ertek2 > bes_vall_ertek1 THEN bes_vall_eszkoz := 'TARTOSGEP'; ELSE bes_vall_eszkoz := 'EPULET'; END IF;

                sql_statement := 'SELECT GYORSGEP FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND cfc_net_grs = ''cfc'' and F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement INTO bes_vall_ertek3;

                IF bes_vall_ertek3 > bes_vall_ertek THEN bes_vall_ertek := bes_vall_ertek3; bes_vall_eszkoz := 'GYORSGEP'; END IF;

                sql_statement := 'SELECT JARMU FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND cfc_net_grs = ''cfc'' and F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement INTO bes_vall_ertek4;

                IF bes_vall_ertek4 > bes_vall_ertek THEN bes_vall_ertek := bes_vall_ertek4; bes_vall_eszkoz := 'JARMU'; END IF;

                sql_statement := 'SELECT SZOFTVER FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND cfc_net_grs = ''cfc'' and F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement INTO bes_vall_ertek5;

                IF bes_vall_ertek5 > bes_vall_ertek THEN bes_vall_ertek := bes_vall_ertek5; bes_vall_eszkoz := 'SZOFTVER';                END IF;

                EXECUTE IMMEDIATE'
                UPDATE '|| v_out_table ||'
                SET SUM_CLASSIC = BESOROLT_VALL,
                '|| bes_vall_eszkoz ||' = '|| bes_vall_eszkoz ||' + (BESOROLT_VALL - SUM_CLASSIC)
                WHERE EV = '''|| v_in_year(a) ||''' AND AGAZAT = '''|| v_agazat(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND cfc_net_grs = ''cfc'' and F_V_99 = ''F''

                '
                ;


END LOOP;

END IF;

END LOOP;

                  -- V értékek számítása

                FOR c IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP

                --            S1311a V = S1311a xxx(F) / (S1311 XXX (F) / S1311 XXX (V)) 
                --            S1313a V = S1313a xxx(F) / (S1313 XXX (F) / S1313 XXX (V))

                sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE '|| v_out_eszkcsp(c) ||' != 0 AND '|| v_out_eszkcsp(c) ||' IS NOT NULL AND EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR =  '''|| v_szektorok(s) ||''' ';
                EXECUTE IMMEDIATE sql_statement INTO v;

                IF v > 0 THEN

                sql_statement := 'SELECT DISTINCT AGAZAT FROM '|| v_out_table ||' WHERE '|| v_out_eszkcsp(c) ||' != 0 AND '|| v_out_eszkcsp(c) ||' IS NOT NULL AND '|| v_out_eszkcsp(c) ||' != 0 AND '|| v_out_eszkcsp(c) ||' IS NOT NULL AND EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR =  '''|| v_szektorok(s) ||''' AND F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat;

                               FOR a IN v_agazat.FIRST..v_agazat.LAST LOOP

                               IF ''|| v_szektorok(s) ||'' = 'S1311a' THEN

                                 EXECUTE IMMEDIATE'
                                 UPDATE '|| v_out_table ||'
                                 SET '|| v_out_eszkcsp(c) ||' = 
                                 (SELECT ROUND((SELECT '|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1311a'' AND AGAZAT = '''|| v_agazat(a) ||''') / ((SELECT a.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' a WHERE a.EV = '''|| v_in_year(b) ||''' AND a.F_V_99 = ''F'' AND a.CFC_NET_GRS = ''cfc'' AND a.ALSZEKTOR = ''S1311'' AND a.'|| v_out_eszkcsp(c) ||' != 0 AND a.AGAZAT = '''|| v_agazat(a) ||''') / (SELECT b.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' b WHERE b.EV = '''|| v_in_year(b) ||''' AND b.F_V_99 = ''V'' AND b.CFC_NET_GRS = ''cfc'' AND b.ALSZEKTOR = ''S1311'' AND b.'|| v_out_eszkcsp(c) ||' != 0 AND b.AGAZAT = '''|| v_agazat(a) ||''')))
                                 FROM dual)
                                 WHERE AGAZAT = '''|| v_agazat(a) ||''' AND F_V_99 = ''V'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1311a'' AND EV = '''|| v_in_year(b) ||'''
                                 '
                                 ;

                                 COMMIT;

                               ELSIF ''|| v_szektorok(s) ||'' = 'S1313a' THEN

                                 EXECUTE IMMEDIATE'
                                 UPDATE '|| v_out_table ||'
                                 SET '|| v_out_eszkcsp(c) ||' = 
                                 (SELECT ROUND((SELECT '|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1313a'' AND AGAZAT = '''|| v_agazat(a) ||''') / ((SELECT a.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' a WHERE a.EV = '''|| v_in_year(b) ||''' AND a.F_V_99 = ''F'' AND a.CFC_NET_GRS = ''cfc'' AND a.ALSZEKTOR = ''S1313'' AND a.'|| v_out_eszkcsp(c) ||' != 0 AND a.AGAZAT = '''|| v_agazat(a) ||''') / (SELECT b.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' b WHERE b.EV = '''|| v_in_year(b) ||''' AND b.F_V_99 = ''V'' AND b.CFC_NET_GRS = ''cfc'' AND b.ALSZEKTOR = ''S1313'' AND b.'|| v_out_eszkcsp(c) ||' != 0 AND b.AGAZAT = '''|| v_agazat(a) ||''')))
                                 FROM dual)
                                 WHERE AGAZAT = '''|| v_agazat(a) ||''' AND F_V_99 = ''V'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1313a'' AND EV = '''|| v_in_year(b) ||'''
                                 '
                                 ;

                                 COMMIT;

                               END IF;

                               END LOOP;

                END IF;


                -- ahol 0 az érték: 
                --            S1311a V = S1311a xxx(F) / (S1311 SUM XXX (F) / S1311 SUM XXX (V)) -- 15 / 268142 / 251067
                --            S1313a V = S1313a xxx(F) / (S1313 SUM XXX (F) / S1313 SUM XXX (V))

                sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE '|| v_out_eszkcsp(c) ||' != 0 AND '|| v_out_eszkcsp(c) ||' IS NOT NULL AND EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR =  '''|| v_szektorok(s) ||''' AND F_V_99 = ''F'' ';
                EXECUTE IMMEDIATE sql_statement INTO v;

                IF v > 0 THEN

                sql_statement := 'SELECT DISTINCT AGAZAT FROM '|| v_out_table ||' WHERE '|| v_out_eszkcsp(c) ||' != 0 AND '|| v_out_eszkcsp(c) ||' IS NOT NULL AND EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR =  '''|| v_szektorok(s) ||''' ';
                EXECUTE IMMEDIATE sql_statement BULK COLLECT INTO v_agazat;

                               FOR a IN v_agazat.FIRST..v_agazat.LAST LOOP

                               IF ''|| v_szektorok(s) ||'' = 'S1311a' THEN

                               sql_statement := 'SELECT NVL('|| v_out_eszkcsp(c) ||', 0) FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1311'' AND AGAZAT = '''|| v_agazat(a) ||''' ';           
                               EXECUTE IMMEDIATE sql_statement INTO v;

                               IF v = 0 THEN

                                 EXECUTE IMMEDIATE'
                                 UPDATE '|| v_out_table ||'
                                 SET '|| v_out_eszkcsp(c) ||' = 
                                 (SELECT ROUND((SELECT '|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1311a'' AND AGAZAT = '''|| v_agazat(a) ||''') / ((SELECT a.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' a WHERE a.EV = '''|| v_in_year(b) ||''' AND a.F_V_99 = ''F'' AND a.CFC_NET_GRS = ''cfc'' AND a.ALSZEKTOR = ''S1311'' AND a.AGAZAT = ''SUM'') / (SELECT b.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' b WHERE b.EV = '''|| v_in_year(b) ||''' AND b.F_V_99 = ''V'' AND b.CFC_NET_GRS = ''cfc'' AND b.ALSZEKTOR = ''S1311'' AND b.AGAZAT = ''SUM'')))
                                 FROM dual)
                                 WHERE AGAZAT = '''|| v_agazat(a) ||''' AND F_V_99 = ''V'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1311a'' AND EV = '''|| v_in_year(b) ||'''
                                 '
                                 ;

                                 COMMIT;

                               END IF;

                               ELSIF ''|| v_szektorok(s) ||'' = 'S1313a' THEN  

                               sql_statement := 'SELECT NVL('|| v_out_eszkcsp(c) ||', 0) FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1313'' AND AGAZAT = '''|| v_agazat(a) ||''' ';           
                               EXECUTE IMMEDIATE sql_statement INTO v;

                               IF v = 0 THEN

                                 EXECUTE IMMEDIATE'
                                 UPDATE '|| v_out_table ||'
                                 SET '|| v_out_eszkcsp(c) ||' = 
                                 (SELECT ROUND((SELECT '|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' WHERE EV = '''|| v_in_year(b) ||''' AND F_V_99 = ''F'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1313a'' AND AGAZAT = '''|| v_agazat(a) ||''') / ((SELECT a.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' a WHERE a.EV = '''|| v_in_year(b) ||''' AND a.F_V_99 = ''F'' AND a.CFC_NET_GRS = ''cfc'' AND a.ALSZEKTOR = ''S1313'' AND a.AGAZAT = ''SUM'') / (SELECT b.'|| v_out_eszkcsp(c) ||' FROM '|| v_out_table ||' b WHERE b.EV = '''|| v_in_year(b) ||''' AND b.F_V_99 = ''V'' AND b.CFC_NET_GRS = ''cfc'' AND b.ALSZEKTOR = ''S1313'' AND b.AGAZAT = ''SUM'')))
                                 FROM dual)
                                 WHERE AGAZAT = '''|| v_agazat(a) ||''' AND F_V_99 = ''V'' AND CFC_NET_GRS = ''cfc'' AND ALSZEKTOR = ''S1313a'' AND EV = '''|| v_in_year(b) ||'''
                                 '
                                 ;

                                 COMMIT;

                               END IF;

                               END IF;

                               END LOOP;

                END IF;

                END LOOP;

END LOOP;

COMMIT;


                -- V érték számítása a SUM_CLASSIC mezőre
FOR s IN v_szektorok.FIRST..v_szektorok.LAST LOOP

                IF ''|| v_szektorok(s) ||'' IN ('S1311a', 'S1313a') THEN

                sql_statement := 'SELECT COUNT(*) FROM '|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' ';
                EXECUTE IMMEDIATE sql_statement INTO v;
                IF v > 0 THEN

                EXECUTE IMMEDIATE
                'DECLARE
                               CURSOR INS_OPS IS SELECT ALSZEKTOR, AGAZAT, CFC_NET_GRS, F_V_99, EV, ROUND((NVL('|| v_out_eszkcsp(1) ||', 0) + NVL('|| v_out_eszkcsp(2) ||', 0) + NVL('|| v_out_eszkcsp(3) ||', 0) + NVL('|| v_out_eszkcsp(4) ||', 0) + NVL('|| v_out_eszkcsp(5) ||', 0))) as SUM_CLASSIC
                               FROM PKD.'|| v_out_table ||' WHERE ALSZEKTOR = '''|| v_szektorok(s) ||''' AND F_V_99 = ''V'' AND CFC_NET_GRS = ''cfc'';
                               TYPE INS_ARRAY IS TABLE OF INS_OPS%ROWTYPE;
                               INS_OPS_ARRAY INS_ARRAY;
                  BEGIN
                OPEN INS_OPS;
                LOOP
                  FETCH INS_OPS BULK COLLECT INTO INS_OPS_ARRAY;
                  FORALL I IN INS_OPS_ARRAY.FIRST..INS_OPS_ARRAY.LAST
                UPDATE PKD.'|| v_out_table ||' 
                SET SUM_CLASSIC = INS_OPS_ARRAY(I).SUM_CLASSIC
                WHERE EV = INS_OPS_ARRAY(I).EV AND AGAZAT = INS_OPS_ARRAY(I).AGAZAT AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = INS_OPS_ARRAY(I).CFC_NET_GRS AND F_V_99 = INS_OPS_ARRAY(I).F_V_99;

                  EXIT WHEN INS_OPS%NOTFOUND;
                END LOOP;
                CLOSE INS_OPS;
                END;';

                END IF;

                END IF;

END LOOP;

COMMIT;


                -- SUM rekord számítása

                FOR b IN v_in_year.FIRST..v_in_year.LAST LOOP

                FOR c IN v_out_eszkcsp.FIRST..v_out_eszkcsp.LAST LOOP

                               FOR x IN v_out_cfc.FIRST..v_out_cfc.LAST LOOP

                                               FOR y IN F_V_99.FIRST..F_V_99.LAST LOOP

                                                               EXECUTE IMMEDIATE'
                                                               UPDATE PKD.'|| v_out_table ||'
                                                               SET '|| v_out_eszkcsp(c) ||' = 
                                                               (SELECT SUM(NVL('|| v_out_eszkcsp(c) ||', 0))
                                                               FROM PKD.'|| v_out_table ||'
                                                               WHERE EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(x) ||''' AND F_V_99 = '''|| F_V_99(y) ||'''  AND AGAZAT != ''SUM'')
                                                               WHERE AGAZAT = ''SUM'' AND EV = '''|| v_in_year(b) ||''' AND ALSZEKTOR = '''|| v_szektorok(s) ||''' AND CFC_NET_GRS = '''|| v_out_cfc(x) ||''' AND F_V_99 = '''|| F_V_99(y) ||'''
                                                               '
                                                               ;


                                                               COMMIT;

                                               END LOOP;

                               END LOOP;

                END LOOP;

                END LOOP;

                END IF;

                END IF;

END LOOP;




-- SUM_CLASSIC kiszámítása a SUM rekordra
tev_phad_sql_text := 'SELECT rowid sorid, EPULET, GYORSGEP, TARTOSGEP, JARMU, SZOFTVER FROM PKD.'|| v_out_table ||' WHERE AGAZAT = ''SUM'' ';

open ysum_cur for tev_phad_sql_text;

        loop
            fetch ysum_cur into ysum_rec;
            exit when ysum_cur%NOTFOUND;  

            begin

                execute immediate '
                                                               UPDATE PKD.'|| v_out_table ||' 
                set
                SUM_CLASSIC = :sum_all
                                                               WHERE rowid=:sorid
                                                                 ' 
                                                               using 
                                                               ROUND(NVL(ysum_rec.EPULET,0) + NVL(ysum_rec.GYORSGEP,0) + NVL(ysum_rec.TARTOSGEP, 0) + NVL(ysum_rec.JARMU, 0) + NVL(ysum_rec.SZOFTVER, 0)), --SUM_CLASSIC
                                                               ysum_rec.row_id --sorid
                                                               ;                                                               

                                               end;
                               end loop;
close ysum_cur;
commit;               



dbms_output.put_line('14. lépés STOP: ' || systimestamp);

-- 17.lépés: SUM_ALL mező feltöltése

dbms_output.put_line('17. lépés START: ' || systimestamp);

tev_phad_sql_text := 'SELECT rowid sorid, EPULET, GYORSGEP, TARTOSGEP, JARMU, SZOFTVER, ORIGINALS, FOLDJAVITAS, K_F, FEGYVER, OWNSOFT, LAKAS, MEZO, NOE6, KISERTEKU, WIZZ, TCF, EGYEB_ORIG FROM PKD.'|| v_out_table ||' ';

open tev_phad_cur for tev_phad_sql_text;

        loop
            fetch tev_phad_cur into tev_phad_rec;
            exit when tev_phad_cur%NOTFOUND;  

            begin

                execute immediate '
                                                               UPDATE PKD.'|| v_out_table ||' 
                set
                SUM_ALL = :sum_all
                                                               WHERE rowid=:sorid
                                                                 ' 
                                                               using 
                                                               (NVL(tev_phad_rec.epulet,0) + NVL(tev_phad_rec.GYORSGEP,0) + NVL(tev_phad_rec.TARTOSGEP, 0) + NVL(tev_phad_rec.JARMU, 0) + NVL(tev_phad_rec.SZOFTVER, 0) + NVL(tev_phad_rec.ORIGINALS, 0) + NVL(tev_phad_rec.FOLDJAVITAS, 0) + NVL(tev_phad_rec.K_F, 0) + NVL(tev_phad_rec.FEGYVER, 0) + NVL(tev_phad_rec.OWNSOFT, 0) + NVL(tev_phad_rec.LAKAS, 0) + NVL(tev_phad_rec.MEZO, 0) + NVL(tev_phad_rec.NOE6, 0) + NVL(tev_phad_rec.KISERTEKU, 0) + NVL(tev_phad_rec.WIZZ, 0) + NVL(tev_phad_rec.TCF, 0) + NVL(tev_phad_rec.EGYEB_ORIG, 0)
                                                               ), --SUM_ALL
                                                               tev_phad_rec.row_id --sorid
                                                               ;                                                               

                               end;
end loop;
close tev_phad_cur;
commit;                                                                

dbms_output.put_line('17. lépés STOP: ' || systimestamp);


EXECUTE IMMEDIATE'
DELETE FROM '|| v_out_table ||' 
WHERE AGAZAT IN (''361'', ''362'', ''421'', ''422'', ''711'', ''712'', ''721'', ''722'', ''723'', ''821'', ''822'', ''841'', ''842'', ''843'', ''844'', ''845'', ''846'', ''851'', ''852'', ''853'')
'
;

-- SZEKTOR mező feltölése
EXECUTE IMMEDIATE'
UPDATE '|| v_out_table ||'
SET SZEKTOR = ALSZEKTOR 
WHERE ALSZEKTOR NOT LIKE ''S13%''
'
;

EXECUTE IMMEDIATE'
UPDATE '|| v_out_table ||'
SET SZEKTOR = ''S13'' 
WHERE ALSZEKTOR LIKE ''S13%''
'
;

--módosított tábla létrehozása
EXECUTE IMMEDIATE'
INSERT INTO '|| v_out_table_mod ||'
(SELECT * FROM '|| v_out_table ||')
'
;

OUTPUT_MOD();

*/

END CFC_OUTPUT_NEW_2;

BEGIN

v_szektorok(1) := 'S11';
v_szektorok(2) := 'S1311';
v_szektorok(3) := 'S1313';
v_szektorok(4) := 'S1314';
v_szektorok(5) := 'S12';
v_szektorok(6) := 'S15';
v_szektorok(7) := 'S1311a';
v_szektorok(8) := 'S1313a';
v_szektorok(9) := 'S14'; 

F_V_99(1) := 'F';
F_V_99(2) := 'V';
F_V_99(3) := '99';

F_V_99a(1) := 'YSUM_AKT';
F_V_99a(2) := 'YSUM_UNCH';
F_V_99a(3) := 'YSUM';

v_out_cfc(1) := 'cfc'; 
v_out_cfc(2) := 'net';
v_out_cfc(3) := 'grs';

-- szektorok

-- klasszikus eszközcsoportok
v_out_eszkcsp(1) := 'EPULET'; --AN112
v_out_eszkcsp(2) := 'GYORSGEP'; --AN1139g
v_out_eszkcsp(3) := 'TARTOSGEP'; --AN1139t
v_out_eszkcsp(4) := 'JARMU'; --AN1131
v_out_eszkcsp(5) := 'SZOFTVER'; -- AN1173s

v_out_eszkcsp_c(1) := 'AN112';
v_out_eszkcsp_c(2) := 'AN1139g';
v_out_eszkcsp_c(3) := 'AN1139t';
v_out_eszkcsp_c(4) := 'AN1131';
v_out_eszkcsp_c(5) := 'AN1173s';

-- nem klasszikus eszközcsoportok nem kormányzat esetén
v_out_nk_eszkcsp(1) := 'ORIGINALS'; --AN1174
v_out_nk_eszkcsp(2) := 'FOLDJAVITAS'; --AN1123
v_out_nk_eszkcsp(3) := 'K_F'; --AN1171
v_out_nk_eszkcsp(4) := 'FEGYVER'; --AN114
v_out_nk_eszkcsp(5) := 'OWNSOFT'; --AN1173o
v_out_nk_eszkcsp(6) := 'NOE6'; 
v_out_nk_eszkcsp(7) := 'KISERTEKU'; 
v_out_nk_eszkcsp(8) := 'WIZZ'; 
v_out_nk_eszkcsp(9) := 'TCF'; 
v_out_nk_eszkcsp(10) := 'EGYEB_ORIG'; 

v_out_nk_eszkcsp_c(1) := 'AN1174';
v_out_nk_eszkcsp_c(2) := 'AN1123';
v_out_nk_eszkcsp_c(3) := 'AN1171';
v_out_nk_eszkcsp_c(4) := 'AN114';
v_out_nk_eszkcsp_c(5) := 'AN1173o';
v_out_nk_eszkcsp_c(6) := 'AN112n';
v_out_nk_eszkcsp_c(7) := 'AN1139k';
v_out_nk_eszkcsp_c(8) := 'AN1131w';
v_out_nk_eszkcsp_c(9) := 'AN1174t';
v_out_nk_eszkcsp_c(10) := 'AN1174a';

-- nem klasszikus eszközcsoportok update-re
v_out_nk_up(1) := 'ORIGINALS';
v_out_nk_up(2) := 'FEGYVER';
v_out_nk_up(3) := 'K_F';
v_out_nk_up(4) := 'LAKAS';
v_out_nk_up(5) := 'MEZO';

v_out_nk_up_c(1) := 'AN1174';
v_out_nk_up_c(2) := 'AN114';
v_out_nk_up_c(3) := 'AN1171';
v_out_nk_up_c(4) := 'AN111';
v_out_nk_up_c(5) := 'AN115';



V_AGAZAT_IMP_I(1) := 'SUM';
V_AGAZAT_IMP_I(2) := '01';
V_AGAZAT_IMP_I(3) := '02';
V_AGAZAT_IMP_I(4) := '03';
V_AGAZAT_IMP_I(5) := '05';
V_AGAZAT_IMP_I(6) := '06';
V_AGAZAT_IMP_I(7) := '07';
V_AGAZAT_IMP_I(8) := '08';
V_AGAZAT_IMP_I(9) := '09';
V_AGAZAT_IMP_I(10) := '10';
V_AGAZAT_IMP_I(11) := '11';
V_AGAZAT_IMP_I(12) := '12';
V_AGAZAT_IMP_I(13) := '13';
V_AGAZAT_IMP_I(14) := '14';
V_AGAZAT_IMP_I(15) := '15';
V_AGAZAT_IMP_I(16) := '16';
V_AGAZAT_IMP_I(17) := '17';
V_AGAZAT_IMP_I(18) := '18';
V_AGAZAT_IMP_I(19) := '19';
V_AGAZAT_IMP_I(20) := '20';
V_AGAZAT_IMP_I(21) := '21';
V_AGAZAT_IMP_I(22) := '22';
V_AGAZAT_IMP_I(23) := '23';
V_AGAZAT_IMP_I(24) := '24';
V_AGAZAT_IMP_I(25) := '25';
V_AGAZAT_IMP_I(26) := '26';
V_AGAZAT_IMP_I(27) := '27';
V_AGAZAT_IMP_I(28) := '28';
V_AGAZAT_IMP_I(29) := '29';
V_AGAZAT_IMP_I(30) := '30';
V_AGAZAT_IMP_I(31) := '31';
V_AGAZAT_IMP_I(32) := '32';
V_AGAZAT_IMP_I(33) := '33';
V_AGAZAT_IMP_I(34) := '35';
V_AGAZAT_IMP_I(35) := '36';
V_AGAZAT_IMP_I(36) := '361';
V_AGAZAT_IMP_I(37) := '362';
V_AGAZAT_IMP_I(38) := '37';
V_AGAZAT_IMP_I(39) := '38';
V_AGAZAT_IMP_I(40) := '39';
V_AGAZAT_IMP_I(41) := '41';
V_AGAZAT_IMP_I(42) := '42';
V_AGAZAT_IMP_I(43) := '421';
V_AGAZAT_IMP_I(44) := '422';
V_AGAZAT_IMP_I(45) := '43';
V_AGAZAT_IMP_I(46) := '45';
V_AGAZAT_IMP_I(47) := '46';
V_AGAZAT_IMP_I(48) := '47';
V_AGAZAT_IMP_I(49) := '49';
V_AGAZAT_IMP_I(50) := '50';
V_AGAZAT_IMP_I(51) := '51';
V_AGAZAT_IMP_I(52) := '52';
V_AGAZAT_IMP_I(53) := '53';
V_AGAZAT_IMP_I(54) := '55';
V_AGAZAT_IMP_I(55) := '56';
V_AGAZAT_IMP_I(56) := '58';
V_AGAZAT_IMP_I(57) := '59';
V_AGAZAT_IMP_I(58) := '60';
V_AGAZAT_IMP_I(59) := '61';
V_AGAZAT_IMP_I(60) := '62';
V_AGAZAT_IMP_I(61) := '63';
V_AGAZAT_IMP_I(62) := '64';
V_AGAZAT_IMP_I(63) := '65';
V_AGAZAT_IMP_I(64) := '66';
V_AGAZAT_IMP_I(65) := '68';
V_AGAZAT_IMP_I(66) := '69';
V_AGAZAT_IMP_I(67) := '70';
V_AGAZAT_IMP_I(68) := '71';
V_AGAZAT_IMP_I(69) := '711';
V_AGAZAT_IMP_I(70) := '712';
V_AGAZAT_IMP_I(71) := '72';
V_AGAZAT_IMP_I(72) := '721';
V_AGAZAT_IMP_I(73) := '722';
V_AGAZAT_IMP_I(74) := '723';
V_AGAZAT_IMP_I(75) := '73';
V_AGAZAT_IMP_I(76) := '74';
V_AGAZAT_IMP_I(77) := '75';
V_AGAZAT_IMP_I(78) := '77';
V_AGAZAT_IMP_I(79) := '78';
V_AGAZAT_IMP_I(80) := '79';
V_AGAZAT_IMP_I(81) := '80';
V_AGAZAT_IMP_I(82) := '81';
V_AGAZAT_IMP_I(83) := '82';
V_AGAZAT_IMP_I(84) := '821';
V_AGAZAT_IMP_I(85) := '822';
V_AGAZAT_IMP_I(86) := '84';
V_AGAZAT_IMP_I(87) := '841';
V_AGAZAT_IMP_I(88) := '842';
V_AGAZAT_IMP_I(89) := '843';
V_AGAZAT_IMP_I(90) := '844';
V_AGAZAT_IMP_I(91) := '845';
V_AGAZAT_IMP_I(92) := '846';
V_AGAZAT_IMP_I(93) := '85';
V_AGAZAT_IMP_I(94) := '851';
V_AGAZAT_IMP_I(95) := '852';
V_AGAZAT_IMP_I(96) := '853';
V_AGAZAT_IMP_I(97) := '86';
V_AGAZAT_IMP_I(98) := '87';
V_AGAZAT_IMP_I(99) := '88';
V_AGAZAT_IMP_I(100) := '90';
V_AGAZAT_IMP_I(101) := '91';
V_AGAZAT_IMP_I(102) := '92';
V_AGAZAT_IMP_I(103) := '93';
V_AGAZAT_IMP_I(104) := '94';
V_AGAZAT_IMP_I(105) := '95';
V_AGAZAT_IMP_I(106) := '96';
V_AGAZAT_IMP_I(107) := '97';
V_AGAZAT_IMP_I(108) := '98';
V_AGAZAT_IMP_I(109) := '99';

v_3_agazat(1) := '721';
v_3_agazat(2) := '722';
v_3_agazat(3) := '723';
v_3_agazat(4) := '841';
v_3_agazat(5) := '842';
v_3_agazat(6) := '843';
v_3_agazat(7) := '844';
v_3_agazat(8) := '845';
v_3_agazat(9) := '846';
v_3_agazat(10) := '361';
v_3_agazat(11) := '362';
v_3_agazat(12) := '421';
v_3_agazat(13) := '422';
v_3_agazat(14) := '711';
v_3_agazat(15) := '712';
v_3_agazat(16) := '821';
v_3_agazat(17) := '822';
v_3_agazat(18) := '851';
v_3_agazat(19) := '852';
v_3_agazat(20) := '853';

v_out_nk_eszkcsp_3(1) := 'ORIGINALS';
v_out_nk_eszkcsp_3(2) := 'FOLDJAVITAS';
v_out_nk_eszkcsp_3(3) := 'K_F';
v_out_nk_eszkcsp_3(4) := 'FEGYVER';
v_out_nk_eszkcsp_3(5) := 'OWNSOFT';
v_out_nk_eszkcsp_3(6) := 'LAKAS';
v_out_nk_eszkcsp_3(7) := 'NOE6';
v_out_nk_eszkcsp_3(8) := 'KISERTEKU';
v_out_nk_eszkcsp_3(9) := 'WIZZ';
v_out_nk_eszkcsp_3(10) := 'MEZO';
v_out_nk_eszkcsp_3(11) := 'TCF';
v_out_nk_eszkcsp_3(12) := 'EGYEB_ORIG';
-- v_out_nk_eszkcsp_3(13) := 'EPULET';
-- v_out_nk_eszkcsp_3(14) := 'TARTOSGEP';
-- v_out_nk_eszkcsp_3(15) := 'GYORSGEP';
-- v_out_nk_eszkcsp_3(16) := 'JARMU';
-- v_out_nk_eszkcsp_3(17) := 'SZOFTVER';

END;
