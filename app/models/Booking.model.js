const db = require('./db');

module.exports = class Booking {

    constructor(rawData) {
        Object.entries(rawData).forEach(entry => {
            const [key, value] = entry;
            this[key] = value;
        });
    }

    static async findAll(visitor_id) {
        const result = await db.query('SELECT * FROM view_bookings($1);', [visitor_id]);

        const bookings = result.rows.map(bk => new Booking(bk));

        return bookings;
    }
}