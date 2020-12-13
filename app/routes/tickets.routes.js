const Cart = require('../models/Cart.model');
const pug = require('pug');
const vision = require('@hapi/vision');
const inert = require('@hapi/inert');
const moment = require('moment');

module.exports = {
    name: 'tickets API',
    register: async server => {
        await server.register([vision, inert]);

        // partie API
        server.route({
            method: 'GET',
            path: '/api/voucher',
            handler: request => Cart.validateVoucher(request.query.code)
        });

        server.route({
            method: 'GET',
            path: '/api/total',
            handler: request => new Cart(request.query).getTotal()
        });
        
        // partie pages et ressources

        // config Inert
        server.route({
            method: 'GET',
            path: '/static/{file*}',
            handler: {
                directory: {
                    path: __dirname + '/../assets'
                }
            }
        });

        // config Vision
        server.views({
            engines: {pug},
            relativeTo: __dirname + '/..',
            path: 'views'
        });

        // route qui utilise la vue form
        server.route({
            method: 'GET',
            path: '/',
            handler: (_, h) => h.view('tickets/form', { now: moment().format('YYYY-MM-DD') })
        });

        // route qui reçoit les infos du form et les traite
        server.route({
            method: 'POST',
            path: '/processing',
            handler: async (request, h) => {
                const visitors = await new Cart(request.payload).process();
                
                // on ne va conserver que les numéros de billet pour les réafficher après la redirection
                // ici, on utilise Yar, le gestionnaire de session de Hapi, super simple à utiliser
                // cf server.js pour la config
                request.yar.set('tickets', Object.keys(visitors));

                return h.redirect('/success');
            }
        });

        server.route({
            method: 'GET',
            path: '/success',
            handler: (request, h) => h.view('tickets/list', { tickets: request.yar.get('tickets') })
        });

        console.log(`routes API ${server.realm.modifiers.route.prefix} : ok`);
    }
};