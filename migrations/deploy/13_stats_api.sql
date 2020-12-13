-- Deploy oparc-hapi:13_stats_api to pg

BEGIN;

-- liste les attractions et leur taux d'ouverture sur les derniers 90 jours (c'est à dire 90 jours moins la somme des durées d'incidents)
CREATE VIEW events_with_uptimes AS
WITH downtimes AS (
	SELECT COALESCE(resolved_time, now()) - happening_time downtime, event_id
	FROM maintenance.incident
)
SELECT public.event.*, '90 days' - COALESCE(sum(downtime), '0 seconds'::interval) uptime
FROM public.event
LEFT JOIN downtimes ON public.event.id = downtimes.event_id
GROUP BY public.event.id;

-- dans une vue, une colonne ne peut pas avoir le type record ou record[]
-- car le format de la vue doit toujours être défini clairement
-- et record, c'est un format souple qui peut représenter tout et n'importe quoi
-- on va donc créer un type complexe attendance, qui regroupe un numéro de semaine et une moyenne (de visites par jour cette semaine)
CREATE TYPE attendance AS (
	week int,
	avg_visits float
);

-- et hop !
CREATE VIEW events_attendance AS
WITH events_attendance AS (
	SELECT event_id, extract(week FROM ride.time)::int week, (count(*) / 7.0)::float avg_visits
	FROM ride
	WHERE ride.time > now() - '1 year 4 weeks'::interval AND ride.time < now() - '1 year'::interval
	GROUP BY event_id, extract(week FROM ride.time)
	ORDER BY event_id, week
)
SELECT "event".*, array_agg((week, avg_visits)::attendance)
FROM "event"
JOIN events_attendance ON events_attendance.event_id = "event".id
GROUP BY "event".id;

COMMIT;
