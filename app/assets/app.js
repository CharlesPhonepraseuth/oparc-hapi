const app = {
    init: () => {

        app.form = document.querySelector('form');

        app.plugListeners();
    },
    plugListeners: () => {
        app.form.elements['validity_end'].addEventListener('change', app.handleVEndChange);
        app.form.elements['validity_start'].addEventListener('change', app.handleVStartChange);
        app.form.elements['total_tickets'].addEventListener('change', app.handleNumberChange);
        app.form.elements['voucher'].addEventListener('input', app.handleVoucherChange);
        app.form.addEventListener('change', app.updateTotal);
    },
    handleVEndChange: e => {
        app.form.elements['validity_start'].max = e.target.value;
    },
    handleVStartChange: e => {
        app.form.elements['validity_end'].min = e.target.value;
    },
    handleNumberChange: e => {
        for (let elName of ['youth_tickets', 'jobless_tickets', 'vip_tickets']) {
            app.form.elements[elName].max = e.target.value;
            app.form.elements[elName].value = Math.min(e.target.value, app.form.elements[elName].value);
        }
    },
    handleVoucherChange: async e => {
        const response = await fetch('/api/voucher?code=' + e.target.value);

        const valid = await response.json();

        if (valid) {
            app.form.querySelector('#voucher-check').className = 'good';
        } else {
            app.form.querySelector('#voucher-check').className = 'bad';
        }
    },
    updateTotal: async _ => {

        // on va envoyer en GET, donc pas de body possible, il faut créer une query string
        // on va utiliser FormData quand même car il est très pratique pour regrouper instantanément les valeurs à envoyer
        const data = new FormData(app.form);

        data.delete('fullname');

        // quelques petites méthodes enchaînées et hop ! heureusement qu'on a révisé les arrays 😏
        const queryString = Array.from(data).map(pair => pair.join('=')).join('&');

        const response = await fetch('/api/total?' + queryString);

        if (!response.ok) return;
        
        const total = await response.json();

        app.form.elements.total.textContent = `Total : ${total} €`;
    }
};

document.addEventListener('DOMContentLoaded', app.init);