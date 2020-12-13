-- Verify oparc-hapi:03_checks on pg

BEGIN;

-- s'il y en a une, les autres sont là
SELECT 1/COUNT(*) FROM pg_catalog.pg_constraint WHERE conname = 'visitor_ticket_number_key';


ROLLBACK;
