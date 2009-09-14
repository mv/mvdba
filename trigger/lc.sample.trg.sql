
CREATE OR REPLACE TRIGGER adp_patch_lc
                   BEFORE INSERT
                       OR UPDATE
                       ON adp_patch
                      FOR EACH ROW
DECLARE
    -- $Id: adp_patch_lc.trg.sql 13798 2007-04-18 17:10:05Z marcus.ferreira $
    gap_nm  adp_patch.gap_nm%TYPE;
    prd_nm  adp_patch.prd_nm%TYPE;
BEGIN
    -- Keep lower case
    gap_nm := LOWER(:NEW.gap_nm);
    --
    IF   :NEW.gap_nm <> gap_nm
    THEN :NEW.gap_nm := gap_nm;
    END IF;
    --
    prd_nm := LOWER(:NEW.prd_nm);
    --
    IF   :NEW.prd_nm <> prd_nm
    THEN :NEW.prd_nm := prd_nm;
    END IF;
    --
END adp_patch_id;
/

