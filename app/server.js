require('dotenv').config();
const Hapi = require('@hapi/hapi');

(async () => {
    const server = Hapi.server({
        port: 4567,
        debug: { request: ['error'] },
        // cache: [
        //     {
        //         // si on ne met pas de name, ce cache devient le cache par défaut : c'est ce qu'il nous faut
        //         provider: {
        //             constructor: require('@hapi/catbox-redis'),
        //             options: {
        //                 // la partition sert de préfixe dans Redis
        //                 partition : 'oparc',
        //                 password: 'js4life' // ou process.env.RDPASSWORD sinon ;-)
        //             }
        //         }
        //     }
        // ]
    });

    await server.start();

    console.log('serveur en place, client Pg connecté');

    await server.register([
        {
            plugin: require('@hapi/yar'),
            options: {
                cookieOptions: {
                    password: 'lqLBOnES6Kx/IMkIwnGP9RoHo7aOc8suyZYPxPEWTZGJz4ux0JGzuA==', // un mot de passe généré aléatoirement pour encrypter les cookies
                    isSecure: false // parce qu'on utilise http, passer à true pour https
                }
            }
        },
        {
            plugin: require('./routes/tickets.routes'),
            routes: {
                prefix: '/tickets'
            }
        },
        {
            plugin: require('./routes/access.routes'),
            routes: {
                prefix: '/access/api'
            }
        },
        {
            plugin: require('./routes/events.routes'),
            routes: {
                prefix: '/events/api'
            }
        },
        {
            plugin: require('./routes/booking.routes'),
            routes: {
                prefix: '/booking/api'
            }
        },
        {
            plugin: require('./routes/stats.routes'),
            routes: {
                prefix: '/stats/api'
            }
        },
        {
            plugin: require('./routes/maintenance.routes'),
            routes: {
                prefix: '/maintenance'
            }
        }
    ]);
})();

process.on('unhandledRejection', (err) => {
    console.log(err);
    process.exit(1);
});