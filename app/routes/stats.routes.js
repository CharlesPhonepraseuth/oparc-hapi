const Event = require('../models/Event.model');

module.exports = {
    name: 'stats API',
    register: async server => {

        server.route({
            method: 'GET',
            path: '/events/incidents',
            handler: Event.findAllWithUptime
        });

        server.route({
            method: 'GET',
            path: '/events/checkins',
            handler: Event.findAllWithAttendance
        });

        console.log(`routes API ${server.realm.modifiers.route.prefix} : ok`);
    }
};