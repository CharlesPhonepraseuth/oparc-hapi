-- Revert oparc-hapi:07_maintenance from pg

BEGIN;

DROP SCHEMA maintenance CASCADE;

DROP DOMAIN url;

ALTER TABLE "event" DROP COLUMN model_id;

COMMIT;
