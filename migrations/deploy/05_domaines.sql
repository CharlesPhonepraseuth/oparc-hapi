-- Deploy oparc-hapi:05_domaines to pg

BEGIN;

CREATE DOMAIN pint AS int
CHECK (VALUE >= 0);

CREATE DOMAIN oparc_serial AS text
CHECK (VALUE ~* '^[0-9a-f]{16}$');

-- assigner pint à seats
ALTER TABLE booking ALTER seats TYPE pint;

-- assigner oparc_serial à ticket_number
ALTER TABLE visitor ALTER ticket_number TYPE oparc_serial;

-- assigner pint à capacity
ALTER TABLE "event" ALTER capacity TYPE pint;

COMMIT;
