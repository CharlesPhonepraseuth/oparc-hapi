-- Revert oparc-hapi:10_events_api from pg

BEGIN;

DROP FUNCTION visitor_rides(oparc_serial, int);

COMMIT;
