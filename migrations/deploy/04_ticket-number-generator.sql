-- Deploy oparc-hapi:04_ticket-number-generator to pg

BEGIN;

CREATE SEQUENCE visitor_ticket_seq OWNED BY visitor.ticket_number;

ALTER TABLE visitor ALTER ticket_number SET DEFAULT lpad(to_hex(nextval('visitor_ticket_seq'::regclass)), 12, '0');


COMMIT;
