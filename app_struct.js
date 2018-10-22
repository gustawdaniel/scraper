require('dotenv').load();

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

const file = "raw/trojmiasto.html";
// const url = 'http://localhost:8000/olx_472119875.html';
// const url = services[1].url;
// const url = 'https://www.otodom.pl/sprzedaz/mieszkanie/gdansk/?search%5Bfilter_float_price%3Afrom%5D=50000&search%5Bfilter_float_price%3Ato%5D=300000&search%5Bfilter_float_price_per_m%3Ato%5D=7000&search%5Bfilter_enum_market%5D%5B0%5D=secondary&search%5Bdescription%5D=1&search%5Bdist%5D=0&search%5Bsubregion_id%5D=439&search%5Bcity_id%5D=40&search%5Border%5D=created_at_first%3Adesc';
// const url = 'https://www.otodom.pl/oferta/duza-kawalerka-49-6-m2-w-centrum-wrzeszcza-ID3Ksv8.html#d0868145d1';
const url = 'https://dom.trojmiasto.pl/nieruchomosci-rynek-wtorny/ikl,101,e1i,81_95_33_37_97_83_49_38_58_41_79_40_42_54_46_63_90_35_91_3_34_8_32_52_77_57_45_94_47_1_43_80_62_36_50_96_48_87_5_59_76_53_55_86_2_72_56_7_31,w,1,ai,50000_300000,x1i,_7000.html';
// const url = 'https://www.otodom.pl/oferta/mieszkanie-49-m-gdansk-ID3KWtG.html';

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

    let data = []; // host: "www.otodom.pl"
    // let data = { host: "www.otodom.pl" };

    const model = services[3].modelList; //Helper.selectModel(data);
    // const model = Helper.selectModel(data);
    data = Object.assign(data, model(html));

    // let data = [];
    // const model = services[1].modelList;
    // data = model(html);

    elapsed_time("Find");

    console.log("----------------------------");
    console.log(data);
})();