const db = require('./db');

module.exports = class Visitor {
    // pour plus de souplesse, on ne définit pas de props
    // l'évolution du modèle se fera donc naturellement sans retoucher à cette classe
    // mais on aura quand même les avantages d'une couche Modèle MVC
    // - des actions directement "branchées" sur chaque entité (les méthodes)
    // - des objets typés (instanciés depuis une classe) plutôt que littéraux

    constructor(rawData) {
        Object.entries(rawData).forEach(entry => {
            const [key, value] = entry;
            this[key] = value;
        });
    }

    static async findOne(ticket) {
        const result = await db.query('SELECT * FROM visitor WHERE ticket_number = $1', [ticket]);

        if (result.rowCount > 0) {
            return new Visitor(result.rows[0]);
        } else {
            return null;
        }
    }

    // crée et retourne un nouveau visiteur à partir de ses dates de validité
    static async create(start, end) {
        const result = await db.query('SELECT * FROM new_visitor($1, $2)', [start, end]);

        // on crée un modèle avec les infos
        return new Visitor(result.rows[0]);
    }

    // on privilégie l'approche statique car la fonction SQL retourne un booléen
    // on aurait pu construire un Visitor à partir de son ticket puis appeler la méthode directement sur lui
    // mais il aurait alors fallu exécuter une première requête pour aller chercher toutes les infos du visiteur
    // (sachant qu'on ne fait strictement rien de l'objet Visitor dans ce cas précis, c'est un peu inutile de le construire, non ?)
    // puis une deuxième pour noter son entrée dans le parc
    // sur un parc qui fait ~2000 entrées par jour, on économise 2000 requêtes inutiles ;-)
    static async enters(ticket) {
        const result = await db.query('SELECT visitor_enters($1) "valid";', [ticket]);

        return result.rows[0];
    }

    // même logique ici, on privilégie le statique
    // pour construire le visiteur et noter sa sortie d'un coup
    static async leaves(ticket) {
        await db.query('SELECT visitor_leaves($1) "valid";', [ticket]);

        return { valid: true };
    }

    // et encore pareil pour les visites d'attraction
    // on ne modifie rien au niveau du visiteur, pas la peine de le construire
    static async rides(ticket, event) {
        await db.query('SELECT visitor_rides($1, $2) "valid";', [ticket, event]);

        return { valid : true };
    }
}