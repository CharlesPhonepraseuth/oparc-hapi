-- Verify oparc-hapi:01_tables on pg

BEGIN;

SELECT
    visitor.ticket_number,
    "event".name,
    booking.seats,
    ride.time
FROM visitor
JOIN ride ON visitor.id = ride.visitor_id
JOIN booking on visitor.id = booking.visitor_id
JOIN "event" ON booking.event_id = "event".id
WHERE false;

ROLLBACK;
