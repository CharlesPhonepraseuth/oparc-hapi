-- Revert oparc-hapi:13_stats_api from pg

BEGIN;

DROP VIEW events_attendance;
DROP TYPE attendance;
DROP VIEW events_with_uptimes;

COMMIT;
