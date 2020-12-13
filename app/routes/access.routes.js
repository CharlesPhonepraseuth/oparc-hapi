const Visitor = require('../models/Visitor.model');

module.exports = {
    name: 'access API',
    register: async server => {

        server.route({
            method: 'GET',
            path: '/in',
            handler: request => Visitor.enters(request.query.ticket)
        });

        server.route({
            method: 'GET',
            path: '/out',
            handler: request => Visitor.leaves(request.query.ticket)
        });

        console.log(`routes API ${server.realm.modifiers.route.prefix} : ok`);
    }
};