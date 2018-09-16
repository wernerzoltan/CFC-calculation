create or replace PROCEDURE probaz(proba1 VARCHAR2, proba2 VARCHAR2, proba3 VARCHAR2) AUTHID DEFINER  AS 
BEGIN
  EXECUTE IMMEDIATE '
  
  SELECT .Y'|| proba ||'_1999
  FROM '|| v_out_schema ||'.'|| v_gfcf_table ||'
    
  ';
END probaz;