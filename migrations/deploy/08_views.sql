-- Deploy oparc-hapi:08_views to pg

BEGIN;

CREATE VIEW active_event AS
SELECT "event".*
FROM "event"
WHERE id NOT IN (
	SELECT event_id
	FROM maintenance.incident
	WHERE resolved_time IS NULL
);

CREATE VIEW open_active_event AS
SELECT * FROM active_event
-- il faut que l'heure actuelle soit située entre l'heure d'ouverture
WHERE now() >= current_date + opening
-- et l'heure de fermeture moins la durée d'un tour
AND now() <= current_date + opening + open_time - duration;

COMMIT;
