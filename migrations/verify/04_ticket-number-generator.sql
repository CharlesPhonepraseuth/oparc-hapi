-- Verify oparc-hapi:04_ticket-number-generator on pg

BEGIN;

SELECT * FROM visitor_ticket_seq;

ROLLBACK;
