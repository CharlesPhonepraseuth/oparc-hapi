-- Verify oparc-hapi:13_stats_api on pg

BEGIN;

SELECT * FROM events_attendance WHERE false;
SELECT * FROM events_with_uptimes WHERE false;

ROLLBACK;
