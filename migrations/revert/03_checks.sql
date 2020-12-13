-- Revert oparc-hapi:03_checks from pg

BEGIN;

ALTER TABLE visitor DROP CONSTRAINT visitor_validity_dates_order;

-- la capacité d'une attraction doit être supérieure à 0
-- les heures d'ouverture et de fermeture des attractions doivent être 00, 15, 30 ou 45
ALTER TABLE "event"
    DROP CONSTRAINT event_capacity_positive,
    DROP CONSTRAINT event_opening_on_quarters,
    DROP CONSTRAINT event_closing_on_quarters;

-- le nombre de places réservables pour chaque réservation doit être compris entre 1 et 4
ALTER TABLE booking
    DROP CONSTRAINT booking_seats_positive_and_four_max;

COMMIT;
