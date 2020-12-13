-- Revert oparc-hapi:04_ticket-number-generator from pg

BEGIN;

-- CASCADE permet de dropper tout ce qui dépend de ce qu'on droppe initialement
-- ici, la séquence est utilisée pour la valeur par défaut du champ ticket_number de la table visitor
-- avec CASCADE, cette valeur par défaut est droppée dans la foulée
DROP SEQUENCE public.visitor_ticket_seq CASCADE;

COMMIT;
