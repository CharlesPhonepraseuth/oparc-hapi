-- Revert oparc-hapi:02_types-notnull from pg

BEGIN;

ALTER TABLE visitor
    ALTER ticket_number TYPE int USING ticket_number::int,
    ALTER ticket_number DROP NOT NULL,
    ALTER validity_start DROP NOT NULL,
    ALTER validity_end DROP NOT NULL,
    ALTER entered TYPE timestamp,
    ALTER "left" TYPE timestamp;

ALTER TABLE "event"
    ALTER "name" DROP NOT NULL,
    ALTER capacity DROP NOT NULL,
    ALTER duration DROP NOT NULL;

ALTER TABLE ride
    ALTER event_id DROP NOT NULL,
    ALTER visitor_id DROP NOT NULL,
    ALTER "time" TYPE timestamp;

ALTER TABLE booking
    ALTER event_id DROP NOT NULL,
    ALTER visitor_id DROP NOT NULL,
    ALTER seats DROP NOT NULL,
    ALTER "time" TYPE timestamp;

COMMIT;
