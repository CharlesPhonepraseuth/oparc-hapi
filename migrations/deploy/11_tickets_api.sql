-- Deploy oparc-hapi:11_tickets_api to pg

BEGIN;

-- tiens, on en profite, on connaît les fonctions maintenant
CREATE FUNCTION generate_ticket() RETURNS oparc_serial AS $$
SELECT lpad(to_hex(nextval('visitor_ticket_seq'::regclass)), 16, '0')::oparc_serial
$$ LANGUAGE sql;
-- attention, cette fonction n'est pas IMMUTABLE : si je l'appelle 2 fois, j'aurai 2 numéros différents
-- et je ne la déclare pas STRICT non plus car elle n'a pas de paramètre donc difficile de lui passer NULL

-- c'est plus lisible comme ça
ALTER TABLE visitor
ALTER COLUMN ticket_number SET DEFAULT generate_ticket();

-- on a juste besoin de celle-ci pour conclure une vente : créer les visiteurs
CREATE FUNCTION new_visitor(vstart date, vend date) RETURNS visitor AS $$
INSERT INTO visitor (validity_start, validity_end)
VALUES (vstart, vend) RETURNING *;
$$ LANGUAGE sql STRICT;

COMMIT;
