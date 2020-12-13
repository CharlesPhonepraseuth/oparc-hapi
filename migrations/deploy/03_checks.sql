-- Deploy oparc-hapi:03_checks to pg

BEGIN;

-- la date de fin doit être supérieure ou égale à la date de début
ALTER TABLE visitor ADD CONSTRAINT visitor_validity_dates_order CHECK (validity_end >= validity_start);

-- la capacité d'une attraction doit être supérieure à 0
-- les heures d'ouverture et de fermeture des attractions doivent être 00, 15, 30 ou 45
ALTER TABLE "event"
    ADD CONSTRAINT event_capacity_positive CHECK (capacity > 0),
    ADD CONSTRAINT event_opening_on_quarters CHECK (extract(epoch FROM opening)::int % 900 = 0),
    ADD CONSTRAINT event_closing_on_quarters CHECK (extract(epoch FROM closing)::int % 900 = 0);

-- le nombre de places réservables pour chaque réservation doit être compris entre 1 et 4
ALTER TABLE booking
    ADD CONSTRAINT booking_seats_positive_and_four_max CHECK (seats > 0 AND seats <= 4);


COMMIT;
