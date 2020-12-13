const Visitor = require('../models/Visitor.model');
const Event = require('../models/Event.model');
const Booking = require('../models/Booking.model');

module.exports = {
    name: 'booking API',
    register: async server => {

        server.route({
            method: 'GET',
            path: '/init',
            handler: async (request, h) => {
                const theVisitor = await Visitor.findOne(request.query.ticket);

                if (!theVisitor) {
                    return h.response({
                        message: "unknown ticket number"
                    }).code(404);
                }

                request.yar.set('visitor', theVisitor.id);

                return theVisitor;
            }
        });

        const eventsCache = server.cache({
            expiresIn: 3 * 60 * 1000, // 3 minutes (c'est beaucoup trop long mais c'est pour illustrer)
            segment: 'events', // un segment sert à contextualiser les infos qu'on met en cache, mais on peut aussi l'utiliser pour que plusieurs policies accèdent aux mêmes données
            generateFunc: Event.findAll,
            generateTimeout: 1000 // si la régénération met plus d'une seconde, on partira du principe que quelque chose déconne et on lancera une erreur
        })

        server.route({
            method: 'GET',
            path: '/events',
            handler: async _ => {
                // on nomme une clé à aller chercher dans le cache, ici 'list'
                // si elle existe et contient des données encore valides, celles-ci seront retournées et un appel à la BDD sera économisé
                // sinon, Catbox se charge de lancer la generateFunc associée à la policy utilisée (ici Event.findAll), stocke le résultat à cette clé et le retourne
                return await eventsCache.get('list');
            }
        });

        server.route({
            method: 'GET',
            path: '/bookings',
            handler: async request => Booking.findAll(request.yar.get('visitor'))
        })

        console.log(`routes API ${server.realm.modifiers.route.prefix} : ok`);
    }
};