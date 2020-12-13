const Visitor = require('../models/Visitor.model');

module.exports = {
    name: 'events API',
    register: async server => {

        server.route({
            method: 'GET',
            path: '/checkin/{attraction}',
            handler: request => Visitor.rides(request.query.ticket, request.params.attraction)
        });

        console.log(`routes API ${server.realm.modifiers.route.prefix} : ok`);
    }
};