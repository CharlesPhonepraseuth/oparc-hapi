// ce modèle est un peu particulier : il n'est pas standard, car il n'existe pas de table "cart" dans la BDD et les modèles, tels que définis dans MVC, sont censés représenter les différentes entités manipulées par l'application (donc les enregistrements des différentes tables de la BDD)
// mais bon, la billetterie apporte son lot de code entre la vérification de la validité des codes promos et le calcul du total du panier...
// plutôt que de laisser traîner cette complexité dans les routes, appliquons la SoC en créant une entité panier
const prices = require('../data/prices.json');
const moment = require('moment');

const Visitor = require('./Visitor.model');

module.exports = class Cart {
    // pas de props = souplesse

    // mais dîtes donc, c'est le même constructeur que Visitor
    // ça sent l'amélioration pour la v2, ça, non ?
    // pour l'heure, ça marche, on laisse comme ça :-)
    constructor(rawData) {
        Object.entries(rawData).forEach(entry => {
            const [key, value] = entry;
            this[key] = value;
        });
    }

    getTotal() {
        // format correspondant aux prix (mêmes libellés)
        this.tickets = {
            youth: this.youth_tickets,
            jobless: this.jobless_tickets,
            vip: this.vip_tickets,
            base: this.total_tickets - this.youth_tickets - this.jobless_tickets - this.vip_tickets
        };

        const {rates, vouchers} = prices;

        // nombre de jours de validité souhaité
        const days = moment(this.validity_end).diff(this.validity_start, 'days') + 1;

        const dailyPrice = Object.entries(this.tickets)
            // comme les clés correspondent à des clés de rates, on peut appliquer map pour calculer des sous-totaux pour chaque tarif
            .map(entry => entry[1] * rates[entry[0]])
            // et reduce pour additionner les sous-totaux
            .reduce((acc, rate) => acc + rate);

        // technique de chacal, si vouchers[this.voucher] renvoie undefined, le OU logique (||) va "prendre le relais" et discount vaudra 1, soit pas de réduc
        // notez qu'un opérateur plus pertinent est en cours de standardisation, l'opérateur de coalesce ?? => https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator (pas dispo dans Node pour l'instant)
        const discount = vouchers[this.voucher] || 1;

        return dailyPrice * days * discount;
    }

    async process() {
        const visitors = {};
        for (let index = 0; index < this.total_tickets; index++) {
            const visitor = await Visitor.create(this.validity_start, this.validity_end);
            // on crée un index des visiteurs avec leur numéro de billet
            visitors[visitor.ticket_number] = visitor;
        }

        return visitors;
    }

    // la validité d'un code promo est indépendante d'un quelconque contexte => la fonction peut être statique
    static validateVoucher(code) {
        // aussi simple que ça : existe-t-il un code dans prices.json ?
        return !! prices.vouchers[code];
    }
}