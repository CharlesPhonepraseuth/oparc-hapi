-- Deploy oparc-hapi:06_3fn to pg

BEGIN;

ALTER TABLE "event" ADD COLUMN open_time interval;

UPDATE "event" SET open_time = closing - opening;

-- les attractions nocturnes ont une heure closing inférieure à opening
-- la soustraction donnera donc un nombre négatif
-- ex : ouverture à 23h, fermeture à 4h => 4 - 23 = -19, c'est pas top
-- bonne nouvelle : -19 + 24 = 5 => l'attraction est effectivement ouverte 5h
UPDATE event SET open_time = open_time + '24 hours'::interval WHERE open_time < '0 hours'::interval;

ALTER TABLE "event" ALTER open_time SET NOT NULL,
                DROP COLUMN closing;

ALTER TABLE "event" ADD CONSTRAINT event_closing_on_quarters
    CHECK (date_part('minutes', open_time) IN (0, 15, 30, 45, 60));


COMMIT;
