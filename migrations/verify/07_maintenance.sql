-- Verify oparc-hapi:07_maintenance on pg

BEGIN;

SELECT id FROM maintenance.incident WHERE false;

SELECT 'https://coucou.com'::url;

ROLLBACK;
