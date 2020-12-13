-- Revert oparc-hapi:01_tables from pg

BEGIN;

DROP TABLE "event", visitor, ride, booking;

COMMIT;
