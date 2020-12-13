-- Deploy oparc-hapi:14_maintenance_api to pg

BEGIN;

-- pour que ça soit pratique à utiliser, on va créer plusieurs petites fonctions qui représentent le cycle de vie d'un incident
-- sa création, où on détaille la nature de l'incident
CREATE FUNCTION maintenance.new_incident(eid int, nat text) RETURNS maintenance.incident AS $$
INSERT INTO maintenance.incident (nature, happening_time, event_id)
VALUES (nat, now(), eid)
RETURNING *;
$$ LANGUAGE sql STRICT;

-- son avancement, d'un statut à un autre
CREATE FUNCTION maintenance.update_incident(iid int, prg maintenance.incident_progress) RETURNS maintenance.incident AS $$
UPDATE maintenance.incident
SET progress = prg
WHERE id = iid
RETURNING *;
$$ LANGUAGE sql STRICT;

-- le fait d'assigner un technicien sur l'incident
CREATE FUNCTION maintenance.assign_incident(iid int, tcn text) RETURNS maintenance.incident AS $$
UPDATE maintenance.incident
SET technician = tcn,
progress = 'pris en charge'::maintenance.incident_progress
WHERE id = iid
RETURNING *;
$$ LANGUAGE sql STRICT;

-- la fermeture d'un incident
CREATE FUNCTION maintenance.close_incident(iid int) RETURNS maintenance.incident AS $$
UPDATE maintenance.incident
SET resolved_time = now(),
progress = 'terminé'::maintenance.incident_progress
WHERE id = iid
RETURNING *;
$$ LANGUAGE sql STRICT;

-- oups, finalement, fallait pas le fermer
CREATE FUNCTION maintenance.reopen_incident(iid int) RETURNS maintenance.incident AS $$
UPDATE maintenance.incident
SET resolved_time = NULL,
progress = 'en attente'::maintenance.incident_progress
WHERE id = iid
RETURNING *;
$$ LANGUAGE sql STRICT;


-- et pour tout ce qui relève de l'affichage
CREATE VIEW maintenance.incident_list AS
SELECT
    incident.id,
    incident.resolved_time IS NOT NULL resolved,
    incident.nature,
    incident.progress,
    incident.technician,
    to_char(incident.happening_time, 'DD/MM/YY HH24:MI') happening_time,
    to_char(incident.resolved_time, 'DD/MM/YY HH24:MI') resolved_time,
    COALESCE(model.name, "event"."name") "event",
	model.pdf_link
FROM maintenance.incident
JOIN "event" ON "event".id = incident.event_id
LEFT JOIN maintenance.model ON "event".model_id = maintenance.model.id;


COMMIT;
