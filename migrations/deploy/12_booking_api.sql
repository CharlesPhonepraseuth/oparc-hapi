-- Deploy oparc-hapi:12_booking_api to pg

BEGIN;

-- ces deux vues n'étaient là que pour l'exemple, mais elles nous embêtent
-- car leur format n'est pas le bon et on ne peut CREATE OR REPLACE une vue que si le format de sortie (nom et type des colonnes) est strictement identique
-- IF EXISTS car sinon, on ne les recrée pas, elles ne servaient à rien de toute façon
DROP VIEW IF EXISTS open_active_event;
DROP VIEW IF EXISTS active_event;

-- la nouvelle vue, avec toutes les infos
CREATE VIEW active_event AS
SELECT
	id,
	"name",
	opening,
	opening + open_time closing,
	duration,
    -- et la colonne de la muerte : est-ce que cette attraction est ouverte ou fermée ?
    -- premier cas, l'heure de fermeture est plus tard dans la journée, il faut alors vérifier 2 cas
	current_time <= opening + open_time AND -- elle ferme plus tard aujourd'hui
	(current_time >= opening OR -- ET elle a ouvert plus tôt aujourd'hui
	opening > opening + open_time) -- OU elle a ouvert tard hier
    -- dans ces 2 cas, elle est ouverte, mais il reste un cas pernicieux
    -- elle ferme tôt, mais elle a réouvert aujourd'hui
	OR current_time >= opening AND opening > opening + open_time open -- elle fermera demain de bonne heure, donc
    -- dans ces 3 cas, elle est ouverte, sinon elle est fermée
FROM "event"
WHERE "event".id NOT IN (
	SELECT incident.event_id
	FROM maintenance.incident
	WHERE incident.resolved_time IS NULL
);

-- pour garantir la facilité d'usage maximale, je crée un type composite qui sera retourné par ma fonction ci-dessous
-- c'est l'équivalent d'un modèle mais en SQL
CREATE TYPE booking_preview AS (
	id int, -- pour supprimer une réservation facilement
	"event" text, -- parce que le nom de l'attraction sera plus parlant que son id pour un visiteur :-D
	seats int,
	"time" timestamptz
);

-- notez qu'il est également possible de retourner un SETOF record (type neutre qui peut prendre n'importe quelle forme)
-- mais quand vous appellerez la fonction, il faudra alors détailler le format attendu
-- ex: SELECT * FROM view_bookings(4) bookings(id, event, seats, "time") => c'est pas chouette, vous imposez à l'utilisateur de votre fonction de connaître par coeur ce qui va être retourné
CREATE FUNCTION view_bookings(vid int) RETURNS SETOF booking_preview AS $$
SELECT booking.id, "event"."name", booking.seats, booking.time
FROM booking
JOIN "event" ON booking.event_id = "event".id
WHERE booking.visitor_id = vid AND booking.time > now()
$$ LANGUAGE sql STRICT;

-- on ne s'occupe pas de l'action de réserver pour l'instant, ça fera une migration à elle toute seule


COMMIT;
