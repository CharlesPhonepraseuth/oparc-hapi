-- Verify oparc-hapi:08_views on pg

BEGIN;

SELECT * FROM active_event WHERE false;

ROLLBACK;
