-- Revert oparc-hapi:06_3fn from pg

BEGIN;

ALTER TABLE "event" ADD COLUMN closing time;

UPDATE "event" SET closing = opening + open_time;

-- les attractions nocturnes ont une heure closing inférieure à opening
-- la soustraction donnera donc un nombre négatif
-- ex : ouverture à 23h, fermeture à 4h => 4 - 23 = -19, c'est pas top
-- bonne nouvelle : -19 + 24 = 5 => l'attraction est effectivement ouverte 5h
UPDATE event SET closing = closing - '24 hours'::interval WHERE closing > '24 hours'::interval;

ALTER TABLE "event" ALTER closing SET NOT NULL,
                DROP COLUMN open_time;

ALTER TABLE "event" ADD CONSTRAINT event_closing_on_quarters CHECK (extract(epoch FROM closing)::int % 900 = 0);


COMMIT;
