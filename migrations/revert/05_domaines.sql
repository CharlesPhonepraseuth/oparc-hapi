-- Revert oparc-hapi:05_domaines from pg

BEGIN;

-- assigner pint à seats
ALTER TABLE booking ALTER seats TYPE int;

-- assigner oparc_serial à ticket_number
ALTER TABLE visitor ALTER ticket_number TYPE text;

-- assigner pint à capacity
ALTER TABLE "event" ALTER capacity TYPE int;


DROP DOMAIN pint;

DROP DOMAIN oparc_serial;

COMMIT;
