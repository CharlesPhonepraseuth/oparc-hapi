-- Revert oparc-hapi:08_views from pg

BEGIN;

DROP VIEW IF EXISTS open_active_event;

DROP VIEW IF EXISTS active_event;

COMMIT;
