-- Deploy oparc-hapi:10_events_api to pg

BEGIN;

-- là, il n'y a aucune raison que l'insertion ne fonctionne pas, on décide donc de ne rien retourner
CREATE FUNCTION visitor_rides(tn oparc_serial, eid int) RETURNS void AS $$
INSERT INTO ride (visitor_id, event_id)
SELECT visitor.id, eid
FROM visitor
WHERE visitor.ticket_number = tn;
$$ LANGUAGE sql STRICT;

COMMIT;
