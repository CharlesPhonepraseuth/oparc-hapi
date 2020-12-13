const db = require('./db');

module.exports = class Event {

    constructor(rawData) {
        Object.entries(rawData).forEach(entry => {
            const [key, value] = entry;
            this[key] = value;
        });
    }

    static async findAll() {
        const result = await db.query('SELECT * FROM active_event;');

        const events = result.rows.map(e => new Event(e));

        return events;
    }

    static async findAllWithUptime() {
        const result = await db.query('SELECT * FROM events_with_uptimes;');

        return result.rows.map(e => new Event(e));
    }

    static async findAllWithAttendance() {
        const result = await db.query('SELECT * FROM events_attendance;');

        return result.rows.map(e => new Event(e));
    }
}