const pug = require('pug');
const vision = require('@hapi/vision');
const inert = require('@hapi/inert');
const Incident = require('../models/Incident.model');

module.exports = {
    name: 'maintenance API',
    register: async server => {
        await server.register([vision, inert]);
        
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

        // listing des incidents
        server.route({
            method: 'GET',
            path: '/',
            handler: async (_, h) => h.view('maintenance/list', { incidents: await Incident.findAll()})
        });

        // éditer un incident
        server.route({
            method: 'GET',
            path: '/incident/{id}',
            handler: async (request, h) => h.view('maintenance/edit', { incident: await Incident.findOne(request.params.id), data: await Incident.getFormMaterial() })
        });

        // traitement du formulaire d'édition
        server.route({
            method: 'POST',
            path: '/incident/{id}',
            handler: async (request, h) => {
                const theIncident = await Incident.findOne(request.params.id);
                
                // modif de l'avancement
                if (request.payload.update_progress) {
                    theIncident.progress = request.payload.progress;
                    await theIncident.updateProgress();
                }

                // modif du technicien assigné
                if (request.payload.assign_technician) {
                    theIncident.technician = request.payload.technician;
                    await theIncident.assignTechnician();
                }

                // fermeture/réouverture
                if (request.payload.reopen) {
                    theIncident.reopen();
                } else if (request.payload.close) {
                    theIncident.close();
                }

                return h.redirect(`/maintenance`);
            }
        });

        // ouvrir un incident
        server.route({
            method: 'GET',
            path: '/incident/new',
            handler: async (_, h) => {
                console.log(await Incident.getFormMaterial());
                return h.view('maintenance/new', { data: await Incident.getFormMaterial() })
            }
        });

        // traitement du formulaire d'édition
        server.route({
            method: 'POST',
            path: '/incident/new',
            handler: async (request, h) => {
                await Incident.create(request.payload.event, request.payload.nature);
                
                return h.redirect(`/maintenance`);
            }
        });

        console.log(`routes API ${server.realm.modifiers.route.prefix} : ok`);
    }
};