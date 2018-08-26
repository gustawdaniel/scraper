const Config = require("./src/config");
const Helper = require('./src/helper');
const fs = require('fs');
const axios = require('axios');
const moment = require('moment');

moment.locale('pl');
const services = Config.getServices();

const start = process.hrtime();

const elapsed_time = function (note) {
    console.log(note + " " + (process.hrtime(start)[0]
        + process.hrtime(start)[1] / 1e9).toFixed(6));
};

// const file = "raw/gratka.html";
const file = "raw/gratka_offer-5303893.html";
// const url = 'http://localhost:8000/olx_472119875.html';
// const url = services[1].url;
const url = 'https://gratka.pl/nieruchomosci/mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej/ob/5303893';

(async () => {

    elapsed_time("Start");

    if (!fs.existsSync(file)) {
        await axios.get(url)
            .then(response => {
                fs.writeFileSync(file, response.data);
            })
            .catch(error => {
                console.log(error);
            });
    }

    elapsed_time("Fetch");

    const html = fs.readFileSync(file);

    elapsed_time("File");

    let data = {host: "gratka.pl"};

    data = Object.assign(data, { title:
            'Mieszkanie Gdańsk Gdańsk, Nowy Port, ul. Marynarki Polskiej',
        link:
            'https://gratka.pl/nieruchomosci/mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej/ob/5303893',
        host: 'gratka.pl',
        place: 'GDAŃSK, GDAŃSK, NOWY PORT, pomorskie',
        date_txt: 'Aktualizacja: 2018-07-31',
        price: '199 000 zł',
        price_per_surface: '6 219 zł/m2',
        img:
            'https://d-gr.ppstatic.pl/kadry/k/r/gr-ogl/5e/86/5303893_262556883_mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej_medium.jpg',
        id: 'gratka_offer-5303893',
        surface: '32',
        rooms: '1',
        level: '1',
        form_of_ownership: 'własność',
        state: 'do odświeżenia',
        built_at: '1930' });

    const model = Helper.selectModel(data);
    data = Object.assign(data, model(html));

    // let data = [];
    // const model = services[1].modelList;
    // data = model(html);

    elapsed_time("Find");

    console.log("----------------------------");
    console.log(data);
})();