-- Verify oparc-hapi:09_access_api on pg

BEGIN;

-- si la fonction n'existe pas, ça devrait râler
SELECT public.visitor_enters('0000000000000000');

ROLLBACK;
