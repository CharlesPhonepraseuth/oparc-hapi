-- Verify oparc-hapi:06_3fn on pg

BEGIN;

SELECT open_time FROM "event" WHERE false;

ROLLBACK;
