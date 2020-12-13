-- Revert oparc-hapi:09_access_api from pg

BEGIN;

DROP FUNCTION visitor_enters(oparc_serial);
DROP FUNCTION visitor_leaves(oparc_serial);

COMMIT;
