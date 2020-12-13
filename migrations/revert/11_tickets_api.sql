-- Revert oparc-hapi:11_tickets_api from pg

BEGIN;

DROP FUNCTION new_visitor(date, date);

ALTER TABLE visitor
ALTER COLUMN ticket_number SET DEFAULT lpad(to_hex(nextval('visitor_ticket_seq'::regclass)), 16, '0');

DROP FUNCTION generate_ticket();

COMMIT;
