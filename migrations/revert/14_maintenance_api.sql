-- Revert oparc-hapi:14_maintenance_api from pg

BEGIN;

-- beaucoup de fonctions créées => beaucoup de fonctions à supprimer
DROP FUNCTION maintenance.new_incident(int, text);
DROP FUNCTION maintenance.update_incident(int, maintenance.incident_progress);
DROP FUNCTION maintenance.assign_incident(int, text);
DROP FUNCTION maintenance.close_incident(int);
DROP FUNCTION maintenance.reopen_incident(iid int);

DROP VIEW maintenance.incident_list;

COMMIT;
