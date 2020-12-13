-- Deploy oparc-hapi:02_types-notnull to pg

BEGIN;

ALTER TABLE visitor
    ALTER ticket_number TYPE text,
    ALTER ticket_number SET NOT NULL,
    ALTER validity_start SET NOT NULL,
    ALTER validity_end SET NOT NULL,
    ALTER entered TYPE timestamptz,
    ALTER "left" TYPE timestamptz;

ALTER TABLE "event"
    ALTER name SET NOT NULL,
    ALTER capacity SET NOT NULL,
    ALTER duration SET NOT NULL;

ALTER TABLE ride
    ALTER event_id SET NOT NULL,
    ALTER visitor_id SET NOT NULL,
    ALTER "time" TYPE timestamptz;

ALTER TABLE booking
    ALTER event_id SET NOT NULL,
    ALTER visitor_id SET NOT NULL,
    ALTER seats SET NOT NULL,
    ALTER "time" TYPE timestamptz;

COMMIT;
