-- Revert oparc-hapi:12_booking_api from pg

BEGIN;

DROP VIEW active_event;

-- on drop d'abord la fonction qui utilise le type
DROP FUNCTION view_bookings(int);

-- puis le type, une fois que plus rien n'en dépend
DROP TYPE booking_preview;


COMMIT;
