-- CFC main

create or replace PROCEDURE CFC_main AUTHID CURRENT_USER  AS
act_year NUMBER;
gfcf_imp BOOLEAN;
gfcf_imp_alt BOOLEAN;
pim_run BOOLEAN;
sector_unite BOOLEAN;
v_szektor VARCHAR2(10);
v_alszektor VARCHAR2(10);
v_eszkozcsp VARCHAR2(10);
v_gfcf_table VARCHAR2(30);
v_gfcf_ar_table VARCHAR2(30);
v_inv2_table VARCHAR2(30);
v_lifetime_table VARCHAR2(50);
v_arindex_1999 VARCHAR2(50);
v_arindex_lanc VARCHAR2(50);
v NUMERIC;
szekt VARCHAR2(10);
alszekt VARCHAR2(10);
eszkoz VARCHAR2(50);
v_szektor_name VARCHAR2(50);
szekt_atad VARCHAR2(10);
alszekt_atad VARCHAR2(10);
v_gfcf_name VARCHAR2(50);

gfcf_year VARCHAR2(10) := '2015'; 					-- a GFCF tábla import évszáma
evszam VARCHAR2(10) := '2015';  					-- évszám, amelyik évtől futtatjuk az INV2-t

BEGIN
v_szektor := 'S13'; 								-- szektor kódja
v_alszektor := 'S1313'; 							-- alszektor kódja 
v_eszkozcsp := 'AN1131'; 							-- eszközcsoport kódja 
gfcf_imp := FALSE;									-- EGYEDI! futtatjuk-e a GFCF importot, ha igen: TRUE, ha nem: FALSE
gfcf_imp_alt := TRUE;								-- ÁLTALÁNOS! futtatjuk-e a GFCF importot, ha igen: TRUE, ha nem: FALSE
pim_run := FALSE; 									-- futtatjuk-e a PIM futást, ha igen: TRUE, ha nem: FALSE
sector_unite := FALSE;								-- ha több szektorra futtatunk, akkor a végén összevonjuk-e a különböző táblákat egybe. Ha igen: TRUE, ha nem: FALSE

-- INPUT ADATOK:
-- GFCF táblák:
--v_gfcf_table := 'GFCF_OWNSOFT'; -- ownsoft (összes szektor)
--v_gfcf_table := 'GFCF_2015_DEC'; -- S11, S12, S13/1311, S13/1313, S14, S15 - 2015. december - FONTOS! Az éles futásnál az S13 több GFCF összeadásából tevődik össze: GFCF tábla összközpont + összönk értékei
v_gfcf_table := 'GFCF_2015_180904'; -- S11, S12, S13/1311, S13/1313, S14, S15 - 2015. május - FONTOS! Az éles futásnál az S13 több GFCF összeadásából tevődik össze: GFCF tábla összközpont + összönk értékei - ORIGINALS-hoz kell
v_gfcf_ar_table := 'GFCF_AR_2016_180904';

-- INV2 tábla:
-- v_inv2_table := 'INV2_TESZT_PROBA'; 				-- első teszteléshez volt
-- v_inv2_table := 'INV2_TESZT_PROBA_TESZT'; 		-- épület / központ / T08 (S13 / S1311 / AN112)
-- v_inv2_table := 'INV2_TESZT_93'; 				-- épület / központ / T03 (S13 / S1311 / AN112)
-- v_inv2_table := 'INV2_TESZT_TB'; 				-- TB / T08 (S13 / S1314 / AN112)
-- v_inv2_table := 'INV2_EP_ONK_93'; 				-- épület / önkormányzat / T03 (S13 / S1313 / AN112) 
-- v_inv2_table := 'INV2_EP_1780'; 					-- épület / önkormányzat / T03 (S13 / S1313 / AN112)  1780-tól
-- v_inv2_table := 'INV2_EP_KOZP_1780'; 			-- épület / kormányzat / T03 (S13 / S1311 / AN112)  1780-tól
-- v_inv2_table := 'INV2_EP_ONK_1780_96'; 			-- épület / kormányzat / T08 (S13 / S1313 / AN112)  1780-tól
-- v_inv2_table := 'INV2_FEGYVER'; 					-- fegyver / T08 (S13 / S1311 / AN114)
-- v_inv2_table := 'INV2_FEGYVER_PROBA'; 			-- fegyver / T08 (S13 / S1311 / AN114)
-- v_inv2_table := 'INV2_OWNSOFT'; 					-- ownsoft (összes szektor)
-- v_inv2_table := 'INV2_KF'; 						-- K+F (összes szektor)
-- v_inv2_table := 'INV2_MELIO';					-- melioráció (S11, S13/S1311, S13/S1313, S14)
-- v_inv2_table := 'INV2_ORIGINALS';				-- originals (S11, S13/S1311, S13/S1313, S14)
-- v_inv2_table := 'INV2_ONK_GYORSGEP_93';			-- gyorsgép / önkormányzat (S13/1313/AN1132) -- 1780-tól, T03
-- v_inv2_table := 'INV2_ONK_JARMU_93'; 			-- jármű / önkormányzat (S13/1313/AN1131) -- 1780-tól, T03
-- v_inv2_table := 'INV2_ONK_SZOFTVER_93';			-- szoftver / önkormányzat (S13/1313/AN11731b) -- 1780-tól, T03
-- v_inv2_table := 'INV2_ONK_TARTOSGEP_93';			-- tartósgép / önkormányzat (S13/1313/AN1139) -- 1780-tól, T03
-- v_inv2_table := 'INV2_ONK_EPULET_93';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T03
-- v_inv2_table := 'INV2_KORM_GYORSGEP_93';			-- gyorsgép / kormányzat (S13/1311/AN1132) -- 1780-tól, T03
-- v_inv2_table := 'INV2_KORM_JARMU_93'; 			-- jármű / kormányzat (S13/1311/AN1131) -- 1780-tól, T03
-- v_inv2_table := 'INV2_KORM_SZOFTVER_93';			-- szoftver / kormányzat (S13/1311/AN11731b) -- 1780-tól, T03
-- v_inv2_table := 'INV2_KORM_TARTOSGEP_93';		-- tartósgép / kormányzat (S13/1311/AN1139) -- 1780-tól, T03
-- v_inv2_table := 'INV2_KORM_EPULET_93';				-- épület / kormányzat (S13/1311/AN112) -- 1780-tól, T03
-- v_inv2_table := 'INV2_LOTOF_93';					-- épület, gép, jármű, szoftver, kisértékű, no6, wizz / S11, S12, S14, S15 -- 1780-tól, T03
-- v_inv2_table := 'INV2_KORM_SZOFTVER_T08_3';			-- szoftver / kormányzat (S13/1311/AN11731b) -- 1780-tól, T08
-- v_inv2_table := 'INV2_KORM_JARMU_T08_3'; 			-- jármű / kormányzat (S13/1311/AN1131) -- 1780-tól, T08
-- v_inv2_table := 'INV2_KORM_GYORSGEP_T08_3';			-- gyorsgép / kormányzat (S13/1311/AN1132) -- 1780-tól, T08
-- v_inv2_table := 'INV2_KORM_TARTOSGEP_T08_3';		-- tartósgép / kormányzat (S13/1311/AN1139) -- 1780-tól, T08
-- v_inv2_table := 'INV2_KORM_EPULET_T08_3';				-- épület / kormányzat (S13/1311/AN112) -- 1780-tól, T08
-- v_inv2_table := 'INV2_ONK_EPULET_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_inv2_table := 'INV2_ONK_GYORSGEP_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_inv2_table := 'INV2_ONK_JARMU_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_inv2_table := 'INV2_ONK_SZOFTVER_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_inv2_table := 'INV2_ONK_TARTOSGEP_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08

-- v_inv2_table := 'INV2_ALL_T08'; -- kormányzat
 
v_inv2_table := 'INV2_ALL_T08_180904';
 
 -- LIFETIME tábla
-- v_lifetime_table := 'LIFETIME_TESZT';  			-- első teszteléshez volt
-- v_lifetime_table := 'LIFETIME_TESZT_2'; 			-- épület / központ / T08 (S13 / S1311 / AN112)
-- v_lifetime_table := 'LIFETIME_TESZT_93'; 		-- épület / központ / T03 (S13 / S1311 / AN112)
-- v_lifetime_table := 'LT_TB'; 					-- TB / T08 (S13 / S1314 / AN112)
-- v_lifetime_table := 'LT_EP_ONK_93'; 				-- épület / önkormányzat / T03 (S13 / S1311 / AN112)
-- v_lifetime_table := 'LT_EP_1780'; 				-- épület / önkormányzat / T03 (S13 / S1313 / AN112) 1780-tól
-- v_lifetime_table := 'LT_EP_1780_MOD'; 			-- épület / önkormányzat / T03 (S13 / S1313 / AN112) 1780-tól, 2011-ig 75-ös LT érték a 63/UTAK ágazatban
-- v_lifetime_table := 'LT_EP_KORM_1780'; 			-- épület / kormányzat / T03 (S13 / S1311 / AN112) 1780-tól 
-- v_lifetime_table := 'LT_EP_KORM_1780_MOD'; 		-- épület / kormányzat / T03 (S13 / S1311 / AN112) 1780-tól, 2011-ig 75-ös LT érték a 63/UTAK ágazatban
-- v_lifetime_table := 'LT_FEGYVER'; 				-- fegyver / T08 (S13 / S1311 / AN114)
-- v_lifetime_table := 'LT_EP_ONK_1780_96'; 		-- épület / önkormányzat / T08 (S13 / S1311 / AN112) 1780-tól, 2011-ig 55-ös LT érték a 63/UTAK ágazatban
-- v_lifetime_table := 'LT_EP_ONK_1780_96_M'; 		-- épület / önkormányzat / T08 (S13 / S1311 / AN112) 1780-tól, 2011-ig 75-ös LT érték a 63/UTAK ágazatban
-- v_lifetime_table := 'LT_OWNSOFT'; 				-- ownsoft (összes szektor)
-- v_lifetime_table := 'LT_KF'; 					-- K+F (összes szektor)
-- v_lifetime_table := 'LT_MELIO'; 					-- melioráció (S11, S13/S1311, S13/S1313, S14)
-- v_lifetime_table := 'LT_ORIGINALS'; 				-- originals (S11, S13/S1311, S13/S1313, S14)
-- v_lifetime_table := 'LT_ONK_GYORSGEP_93';		-- gyorsgép / önkormányzat (S13/1313/AN1132) -- 1780-tól, T03
-- v_lifetime_table := 'LT_ONK_JARMU_93';			-- jármű / önkormányzat (S13/1313/AN1131) -- 1780-tól, T03
-- v_lifetime_table := 'LT_ONK_SZOFTVER_93';		-- szoftver / önkormányzat (S13/1313/AN11731b) -- 1780-tól, T03
-- v_lifetime_table := 'LT_ONK_TARTOSGEP_93';		-- tartósgép / önkormányzat (S13/1313/AN1139) -- 1780-tól, T03
-- v_lifetime_table := 'LT_ONK_EPULET_93';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T03
-- v_lifetime_table := 'LT_KORM_GYORSGEP_93';		-- gyorsgép / kormányzat (S13/1311/AN1132) -- 1780-tól, T03
-- v_lifetime_table := 'LT_KORM_JARMU_93';			-- jármű / kormányzat (S13/1311/AN1131) -- 1780-tól, T03
-- v_lifetime_table := 'LT_KORM_SZOFTVER_93';		-- szoftver / kormányzat (S13/1311/AN11731b) -- 1780-tól, T03
-- v_lifetime_table := 'LT_KORM_TARTOSGEP_93';		-- tartósgép / kormányzat (S13/1311/AN1139) -- 1780-tól, T03
-- v_lifetime_table := 'LT_KORM_EPULET_93';			-- épület / kormányzat (S13/1311/AN112) -- 1780-tól, T03
-- v_lifetime_table := 'LT_LOTOF_93';					-- épület, gép, jármű, szoftver, kisértékű, no6, wizz / S11, S12, S14, S15 -- 1780-tól, T03
-- v_lifetime_table := 'LT_KORM_SZOFTVER_T08_3';		-- szoftver / kormányzat (S13/1311/AN11731b) -- 1780-tól, T08
-- v_lifetime_table := 'LT_KORM_JARMU_T08_3';			-- jármű / kormányzat (S13/1311/AN1131) -- 1780-tól, T08
-- v_lifetime_table := 'LT_KORM_GYORSGEP_T08_3';		-- gyorsgép / kormányzat (S13/1311/AN1132) -- 1780-tól, T08
-- v_lifetime_table := 'LT_KORM_TARTOSGEP_T08_3';		-- tartósgép / kormányzat (S13/1311/AN1139) -- 1780-tól, T08
-- v_lifetime_table := 'LT_KORM_EPULET_T08_3';			-- épület / kormányzat (S13/1311/AN112) -- 1780-tól, T08
--v_lifetime_table := 'LT_ONK_EPULET_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_lifetime_table := 'LT_ONK_GYORSGEP_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_lifetime_table := 'LT_ONK_JARMU_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_lifetime_table := 'LT_ONK_SZOFTVER_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_lifetime_table := 'LT_ONK_TARTOSGEP_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08

-- v_lifetime_table := 'LT_ALL_T08'; -- kormányzat
v_lifetime_table := 'LT_ALL_T08_180904';

-- ÁRINDEX tábla
-- v_arindex_1999 := 'ARINDEX_1999_TESZT'; 			-- első teszteléshez volt
-- v_arindex_1999 := 'ARINDEX_1999_TESZT_UJ';		-- épület / központ / T08 (S13 / S1311 / AN112)
-- v_arindex_1999 := 'ARINDEX_1999_TESZT_UJ_9598'; -- épület / központ / T08 (S13 / S1311 / AN112) , csak 4 év adatai
-- v_arindex_1999 := 'ARINDEX_1999_TESZT_93'; 		-- épület / központ / T03 (S13 / S1311 / AN112)
-- v_arindex_1999 := 'AR_99_EP_ONK_93'; 			-- épület / önkormányzat / T03 (S13 / S1313 / AN112) 
-- v_arindex_1999 := 'AR_99_EP_KORM_93'; 			-- épület / kormányzat / T03 (S13 / S1313 / AN112)
-- v_arindex_1999 := 'AR_99_EP_ONK_96'; 			-- épület / önkormányzat / T08 (S13 / S1313 / AN112)
-- v_arindex_1999 := 'AR_FEGYVER'; 					-- fegyver / T08 (S13 / S1311 / AN114)
-- v_arindex_1999 := 'AR_99_TB'; 					-- TB / T08 (S13 / S1314 / AN112)
-- v_arindex_1999 := 'AR_OWNSOFT'; 					-- ownsoft (összes szektor)
-- v_arindex_1999 := 'AR_KF'; 						-- K+F (összes szektor)
-- v_arindex_1999 := 'AR_MELIO'; 					-- melioráció (S11, S13/S1311, S13/S1313, S14)
-- v_arindex_1999 := 'AR_ORIGINALS'; 				-- originals (S11, S13/S1311, S13/S1313, S14)
-- v_arindex_1999 := 'AR_ONK_GYORSGEP_93';			-- gyorsgép / önkormányzat (S13/1313/AN1132) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_ONK_JARMU_93';				-- jármű / önkormányzat (S13/1313/AN1131) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_ONK_SZOFTVER_93'; 			-- szoftver / önkormányzat (S13/1313/AN11731b) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_ONK_TARTOSGEP_93';			-- tartósgép / önkormányzat (S13/1313/AN1139) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_ONK_EPULET_93';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_KORM_GYORSGEP_93';			-- gyorsgép / kormányzat (S13/1311/AN1132) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_KORM_JARMU_93';			-- jármű / kormányzat (S13/1311/AN1131) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_KORM_SZOFTVER_93'; 		-- szoftver / kormányzat (S13/1311/AN11731b) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_KORM_TARTOSGEP_93';		-- tartósgép / kormányzat (S13/1311/AN1139) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_KORM_EPULET_93';			-- épület / kormányzat (S13/1311/AN112) -- 1780-tól, T03
-- v_arindex_1999 := 'AR_LOTOF_93';					-- épület, gép, jármű, szoftver, kisértékű, no6, wizz / S11, S12, S14, S15 -- 1780-tól, T03
-- v_arindex_1999 := 'AR_KORM_SZOFTVER_T08_3'; 		-- szoftver / kormányzat (S13/1311/AN11731b) -- 1780-tól, T08
-- v_arindex_1999 := 'AR_KORM_JARMU_T08_3';			-- jármű / kormányzat (S13/1311/AN1131) -- 1780-tól, T08
-- v_arindex_1999 := 'AR_KORM_GYORSGEP_T08_3';			-- gyorsgép / kormányzat (S13/1311/AN1132) -- 1780-tól, T08
-- v_arindex_1999 := 'AR_KORM_TARTOSGEP_T08_3';		-- tartósgép / kormányzat (S13/1311/AN1139) -- 1780-tól, T08
-- v_arindex_1999 := 'AR_KORM_EPULET_T08_3';			-- épület / kormányzat (S13/1311/AN112) -- 1780-tól, T08
--v_arindex_1999 := 'AR_ONK_EPULET_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_arindex_1999 := 'AR_ONK_GYORSGEP_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
-- v_arindex_1999 := 'AR_ONK_JARMU_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_arindex_1999 := 'AR_ONK_SZOFTVER_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08
--v_arindex_1999 := 'AR_ONK_TARTOSGEP_T08_2';			-- épület / önkormányzat (S13/1313/AN112) -- 1780-tól, T08

-- v_arindex_1999 := 'AR_ALL_BAZIS'; -- kormányzat
v_arindex_1999 := 'AR_ALL_BAZIS_180904';

v_arindex_lanc := 'AR_ALL_LANC_180904';

CASE v_szektor
			WHEN 'S11' THEN szekt := 'npVall';
			WHEN 'S12' THEN szekt := 'vall';
			WHEN 'S13' THEN szekt := 'korm';
			WHEN 'S14' THEN szekt := 'hazt';
			WHEN 'S15' THEN szekt := 'np';
		END CASE;	

		CASE v_alszektor
			WHEN 'S11' THEN alszekt:= '0';
			WHEN 'S12' THEN alszekt:= '0';
			WHEN 'S13' THEN alszekt:= '0';
			WHEN 'S14' THEN alszekt:= '0';
			WHEN 'S15' THEN alszekt:= '0';
			WHEN 'S1311' THEN alszekt := 'kozp';
			WHEN 'S1312' THEN alszekt := 'osszkormanyzat'; -- GFCF input táblához
			WHEN 'S1313' THEN alszekt := 'onk';
			WHEN 'S1314' THEN alszekt := 'tb';
		END CASE;	

		CASE v_eszkozcsp --GFCF táblában lévő fejléc megnevezések
			WHEN 'AN111' THEN eszkoz := 'LAKAS';
			WHEN 'AN112' THEN eszkoz := 'EPULET_CALC';
			WHEN 'AN112b' THEN eszkoz := 'EPULET_UTAK_KORR';
			WHEN 'AN112c' THEN eszkoz := 'EPULET_PPP_KORR';
			WHEN 'AN114' THEN eszkoz := 'FEGYVER';
			WHEN 'AN114a' THEN eszkoz := 'Gripen';
			WHEN 'AN1123' THEN eszkoz := 'FOLDJAVITAS';
			WHEN 'AN1171' THEN eszkoz := 'K_F';
			WHEN 'AN1174' THEN eszkoz := 'ORIGINALS';
			WHEN 'AN11731a' THEN eszkoz := 'ownsoft'; -- ez melyik?
			WHEN 'AN1139' THEN eszkoz := 'TARTOSGEP'; 
			WHEN 'AN1132' THEN eszkoz := 'GYORSGEP'; 
			WHEN 'AN1131' THEN eszkoz := 'JARMU';  
			WHEN 'AN11731b' THEN eszkoz := 'szoftver'; -- ez melyik?
			WHEN 'AN1139a' THEN eszkoz := 'kiserteku'; -- ez melyik?
			WHEN 'AN1139b' THEN eszkoz := 'WIZZ'; -- ez melyik?
			WHEN 'AN1139c' THEN eszkoz := 'TCF'; -- ez melyik?
			WHEN 'AN1139d' THEN eszkoz := 'egyeb_orig'; -- ez melyik?
			WHEN 'AN112a' THEN eszkoz := 'NOE6'; -- ez melyik?
			WHEN 'AN115' THEN eszkoz := 'MEZO'; 
		END CASE;
		
		CASE v_eszkozcsp -- GFCF_AR táblában lévő fejléc megnevezések
			WHEN 'AN111' THEN v_gfcf_name := 'LAKAS';
			WHEN 'AN112' THEN v_gfcf_name := 'EPULET';
			WHEN 'AN112b' THEN v_gfcf_name := 'EPULET_UTAK_KORR';
			WHEN 'AN112c' THEN v_gfcf_name := 'EPULET_PPP_KORR';
			WHEN 'AN114' THEN v_gfcf_name := 'FEGYVER';
			WHEN 'AN114a' THEN v_gfcf_name := 'Gripen';
			WHEN 'AN1123' THEN v_gfcf_name := 'FOLDJAVITAS';
			WHEN 'AN1171' THEN v_gfcf_name := 'K_F';
			WHEN 'AN1174' THEN v_gfcf_name := 'ORIGINALS';
			WHEN 'AN11731a' THEN v_gfcf_name := 'EGYEB';
			WHEN 'AN11731b' THEN v_gfcf_name := 'EGYEB'; 
			WHEN 'AN1139d' THEN v_gfcf_name := 'EGYEB'; 
			WHEN 'AN1139' THEN v_gfcf_name := 'GEP';  
			WHEN 'AN1132' THEN v_gfcf_name := 'GEP';  
			WHEN 'AN1131' THEN v_gfcf_name := 'JARMU'; 
			WHEN 'AN1139a' THEN v_gfcf_name := 'kiserteku';  -- ez nem a végleges GFCF oldali mezőnév, még módosul! 
			WHEN 'AN1139b' THEN v_gfcf_name := 'WIZZ'; -- ez nem a végleges GFCF oldali mezőnév, még módosul! 
			WHEN 'AN1139c' THEN v_gfcf_name := 'TCF'; -- ez nem a végleges GFCF oldali mezőnév, még módosul! 
			WHEN 'AN112a' THEN v_gfcf_name := 'NOE6'; -- ez nem a végleges GFCF oldali mezőnév, még módosul! 
			WHEN 'AN115' THEN v_gfcf_name := 'MEZO';
		END CASE;

		
/* GFCF tábla importjához szükséges infok:
S11: Összváll munkalap, 64-65-66, ágazatok nélkül
S12: Összváll munkalap, 64-65-66, ágazatok
S13 / S1311: Össközpont munkalap „mínusz” Központ vállalat munkalap és Központ intézmény munkalapról a ’PIM-hez’ táblázat adatai
S13 / S1313: Összönk munkalap „mínusz” Önkorm vállalat munkalap és Önkorm intézmény munkalapról a ’PIM-hez’ táblázat adatai
S13 / S1314: TB - ép, gép, jármű, szoftver
S14: Összht_nonprofnélkül munkalap
S15: HÁztart_nonpro munkalap
árindex: Összváll munkalapról kell bemásolni (de bármelyik jó, mert ugyanaz minden szektorban)
*/

-- 1/A) GFCF import általános

IF gfcf_imp_alt = TRUE THEN 
CFC_IMPORT.gfcf_imp_alt(''|| gfcf_year ||'', ''|| v_gfcf_table ||'', ''|| v_gfcf_ar_table ||'', ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'', ''|| v_arindex_1999 ||'', ''|| v_szektor ||'', ''|| v_eszkozcsp ||'', ''|| v_gfcf_name ||'', ''|| v_alszektor ||'', ''|| eszkoz ||''); 
DBMS_OUTPUT.put_line('GFCF import_alt lefutott');
ELSE DBMS_OUTPUT.put_line('nincs GFCF import');

END IF;
		
		
-- 1/B) GFCF import egyedi

IF gfcf_imp = TRUE THEN 
CFC_IMPORT.gfcf_imp_egyedi(''|| gfcf_year ||'', ''|| v_gfcf_table ||'', ''|| v_gfcf_ar_table ||'',  ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'',  v_arindex_1999 ||'', ''|| v_szektor ||'', ''|| v_eszkozcsp ||'', ''|| v_alszektor ||'', ''|| eszkoz ||''); 
DBMS_OUTPUT.put_line('GFCF import_egyedi lefutott');
ELSE DBMS_OUTPUT.put_line('nincs GFCF import');

END IF;


-- 2) PIM futtatás

IF pim_run = TRUE THEN 

	FOR i IN 1..2 LOOP  -- 1..22: 1 értéke: 1995, 22 értéke: 2016 

		act_year := ''|| evszam ||'';

		CFC.create_pim(''|| act_year ||'', ''|| szekt ||'', ''|| alszekt ||'', ''|| eszkoz ||'', ''|| v_inv2_table ||'', ''|| v_lifetime_table ||'', ''|| v_arindex_1999 ||'', ''|| v_szektor ||'', ''|| v_eszkozcsp ||'', ''|| v_alszektor ||'');

		evszam := ''|| evszam ||'' + 1;
	
	END LOOP;
	
		CFC_DELETE_NET_GRS.delete_rows(''|| szekt ||'', ''|| alszekt ||'', ''|| eszkoz ||'');

DBMS_OUTPUT.put_line('PIM lefutott');
ELSE DBMS_OUTPUT.put_line('nem volt PIM futás');
END IF;


-- végtáblák összefűzése

IF sector_unite = TRUE THEN

	
	FOR i IN 1..22 LOOP  -- 1..4: 1 értéke: 1995, 22 értéke: 2016

		act_year := ''|| evszam ||'';
		DBMS_OUTPUT.put_line(act_year);
		

		SELECT COUNT(*) INTO v FROM all_tables where table_name = UPPER(''|| eszkoz ||'_'|| act_year ||'');
		
		if v=0 THEN

				EXECUTE IMMEDIATE'
				CREATE TABLE '|| eszkoz ||'_'|| act_year ||'
				("OUTPUT" VARCHAR2(5), "SZEKTOR" VARCHAR2(100 BYTE), "ALSZEKTOR1" VARCHAR2(100 BYTE), "ALSZEKTOR2" VARCHAR2(100 BYTE), "ESZKOZCSP" VARCHAR2(100 BYTE), "AGAZAT" VARCHAR2(30 BYTE),"ALAGAZAT" VARCHAR2(30 BYTE), "Y1900" NUMBER, "Y1901" NUMBER, "Y1902" NUMBER, "Y1903" NUMBER, "Y1904" NUMBER, "Y1905" NUMBER, "Y1906" NUMBER, "Y1907" NUMBER, "Y1908" NUMBER, "Y1909" NUMBER, "Y1910" NUMBER, "Y1911" NUMBER, "Y1912" NUMBER, "Y1913" NUMBER, "Y1914" NUMBER, "Y1915" NUMBER, "Y1916" NUMBER, "Y1917" NUMBER, "Y1918" NUMBER, "Y1919" NUMBER, "Y1920" NUMBER, "Y1921" NUMBER, "Y1922" NUMBER, "Y1923" NUMBER, "Y1924" NUMBER, "Y1925" NUMBER, "Y1926" NUMBER, "Y1927" NUMBER, "Y1928" NUMBER, "Y1929" NUMBER, "Y1930" NUMBER, "Y1931" NUMBER, "Y1932" NUMBER, "Y1933" NUMBER, "Y1934" NUMBER, "Y1935" NUMBER, "Y1936" NUMBER, "Y1937" NUMBER, "Y1938" NUMBER, "Y1939" NUMBER, "Y1940" NUMBER, "Y1941" NUMBER, "Y1942" NUMBER, "Y1943" NUMBER, "Y1944" NUMBER, "Y1945" NUMBER, "Y1946" NUMBER, "Y1947" NUMBER, "Y1948" NUMBER, "Y1949" NUMBER, "Y1950" NUMBER, "Y1951" NUMBER, "Y1952" NUMBER, "Y1953" NUMBER, "Y1954" NUMBER, "Y1955" NUMBER, "Y1956" NUMBER, "Y1957" NUMBER, "Y1958" NUMBER, "Y1959" NUMBER, "Y1960" NUMBER, "Y1961" NUMBER, "Y1962" NUMBER, "Y1963" NUMBER, "Y1964" NUMBER, "Y1965" NUMBER, "Y1966" NUMBER, "Y1967" NUMBER, "Y1968" NUMBER, "Y1969" NUMBER, "Y1970" NUMBER, "Y1971" NUMBER, "Y1972" NUMBER, "Y1973" NUMBER, "Y1974" NUMBER, "Y1975" NUMBER, "Y1976" NUMBER, "Y1977" NUMBER, "Y1978" NUMBER, "Y1979" NUMBER, "Y1980" NUMBER, "Y1981" NUMBER, "Y1982" NUMBER, "Y1983" NUMBER, "Y1984" NUMBER, "Y1985" NUMBER, "Y1986" NUMBER, "Y1987" NUMBER, "Y1988" NUMBER, "Y1989" NUMBER, "Y1990" NUMBER, "Y1991" NUMBER, "Y1992" NUMBER, "Y1993" NUMBER, "Y1994" NUMBER, "Y1995" NUMBER, "Y1996" NUMBER, "Y1997" NUMBER, "Y1998" NUMBER, "Y1999" NUMBER, "Y2000" NUMBER, "Y2001" NUMBER, "Y2002" NUMBER, "Y2003" NUMBER, "Y2004" NUMBER, "Y2005" NUMBER, "Y2006" NUMBER, "Y2007" NUMBER, "Y2008" NUMBER, "Y2009" NUMBER, "Y2010" NUMBER, "Y2011" NUMBER, "Y2012" NUMBER, "Y2013" NUMBER, "Y2014" NUMBER, "Y2015" NUMBER, "Y2016" NUMBER, "YSUM" NUMBER,  "YSUM_AKT" NUMBER)
				'
				;
				
		END IF;
		
		CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', '0');
		CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', 'kozp');
		CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', 'osszkormanyzat');
		CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', 'onk');
		CFC.sector_unite(''|| act_year ||'', ''|| eszkoz ||'', 'tb');
		evszam := ''|| evszam ||'' + 1;

	END LOOP;

DBMS_OUTPUT.put_line('Unite lefutott');
ELSE DBMS_OUTPUT.put_line('nem volt unite');
END IF;

END;