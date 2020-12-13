-- Verify oparc-hapi:11_tickets_api on pg

BEGIN;

-- cette fonction, en effectuant l'insertion dans visitor, va aussi tester generate_ticket, qui est la valeur par défaut de ticket_number
-- attention, current_date + '1 day'::interval renvoie un timestamp car Pg ne peut pas prévoir que vous allez ajouter un nombre entier de jours
-- vous pourriez très bien ajouter 4 minutes à current_date, ce qui devrait logiquement retourner le timestamp "aujourd'hui à 0h04"
SELECT new_visitor(current_date, (current_date + '1 day'::interval)::date);


ROLLBACK;
