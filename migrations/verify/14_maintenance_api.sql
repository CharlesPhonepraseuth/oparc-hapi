-- Verify oparc-hapi:14_maintenance_api on pg

BEGIN;

SELECT resolved FROM maintenance.incident_list WHERE false;

ROLLBACK;
