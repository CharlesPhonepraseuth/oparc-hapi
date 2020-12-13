const db = require('./db');

module.exports = class Incident {

    constructor(rawData) {
        Object.entries(rawData).forEach(entry => {
            const [key, value] = entry;
            this[key] = value;
        });
    }

    // pour récupérer les différentes valeurs à afficher dans le formulaire (attractions et avancement)
    static async getFormMaterial() {
        // on pourrait en faire une vue mais il faudrait alors déclarer un nouveau type complexe car les vues doivent définir clairement le format des données retournées
        const theQuery = `WITH event_labels AS (
            SELECT id, name FROM event
        )
        SELECT
            json_agg(event_labels.*) events,
            enum_range(null::maintenance.incident_progress)::text[] progress_steps
        FROM event_labels;`;

        const result = await db.query(theQuery);

        return result.rows[0];
    }

    static async create(event, nature) {
        const result = await db.query('SELECT * FROM maintenance.new_incident($1, $2);', [event, nature]);

        return new Incident(result.rows[0]);
    }

    static async findAll() {
        const result = await db.query('SELECT * FROM maintenance.incident_list ORDER BY progress ASC;');

        const incidents = result.rows.map(ic => new Incident(ic));

        return incidents;
    }

    static async findOne(id) {
        const result = await db.query('SELECT * FROM maintenance.incident_list WHERE id = $1;', [id]);

        if (result.rowCount > 0) {
            return new Incident(result.rows[0]);
        } else {
            return null;
        }
    }
    
    async updateProgress() {
        // nos fonctions d'update retourne l'enregistrement modifié, mais en fait, comme on utilise ActiveRecord, on s'en fiche un peu, l'objet JS est déjà à jour ;-)
        await db.query('SELECT * FROM maintenance.update_incident($1, $2);', [this.id, this.progress]);
    }
    
    async assignTechnician() {
        await db.query('SELECT * FROM maintenance.assign_incident($1, $2);', [this.id, this.technician]);
    }

    async close() {
        await db.query('SELECT * FROM maintenance.close_incident($1);', [this.id]);
    }

    async reopen() {
        await db.query('SELECT * FROM maintenance.reopen_incident($1);', [this.id]);
    }
}