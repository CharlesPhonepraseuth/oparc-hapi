-- Deploy oparc-hapi:09_access_api to pg

BEGIN;

-- fonction qui met à jour le visiteur si le billet existe
-- et nous retourne l'info au passage
CREATE FUNCTION visitor_enters(tn oparc_serial) RETURNS bool AS $$
WITH updatedvisitor AS (
	UPDATE visitor SET entered = now()
	WHERE ticket_number = tn
	AND entered IS NULL -- si le visiteur sort du parc pour y revenir
	RETURNING true -- sauf que si l'update n'affecte aucune ligne, rien n'est retourné (rien du tout, pas false malheureusement)
) 
SELECT COUNT(*) = 1 FROM updatedvisitor; -- par contre, on peut compter le nombre de lignes affectées pour retomber sur nos pieds
$$ LANGUAGE sql STRICT;

-- la même mais pour la sortie
-- je ne vais pas tenir compte du résultat (pour ne pas bloquer le visiteur dans le parc)
-- mais si un jour, j'en ai besoin (pour du logging par exemple), il sera là
CREATE FUNCTION visitor_leaves(tn oparc_serial) RETURNS bool AS $$
WITH updatedvisitor AS (
	UPDATE visitor SET "left" = now()
	WHERE ticket_number = tn -- ici, on ne vérifie pas s'il existe déjà une heure de sortie, on conservera uniquement la dernière
	RETURNING true
) 
SELECT COUNT(*) = 1 FROM updatedvisitor; -- même technique
$$ LANGUAGE sql STRICT;

COMMIT;
