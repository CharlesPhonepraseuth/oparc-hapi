-- Verify oparc-hapi:05_domaines on pg

BEGIN;

-- vérifier l'existence d'un domaine est très simple
-- il suffit de caster une valeur valide dans le domaine concerné
SELECT 4::pint;
SELECT '1111aaaa5555ffff'::oparc_serial;

ROLLBACK;
