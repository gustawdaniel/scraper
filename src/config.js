const Random = require('./random');
const jsdom = require("jsdom");
const {JSDOM} = jsdom;
const moment = require('moment');
const Dict = require('./dict');

module.exports =

    class Config {
        // constructor() {
        // };

        static getServices() {
            return this.getUrls().map((u, i) => {
                return {
                    url: u,
                    modelList: this.getModelsList()[i],
                    modelSingle: this.getModelsSingle()[i],
                    fileList: this.fileList()[i],
                    fileSingle: this.fileSingle()[i],
                    name: this.name()[i]
                }
            })
        }

        static getUrls() {
            return [
                "https://www.olx.pl/nieruchomosci/mieszkania/sprzedaz/gdansk/?search%5Bfilter_float_price%3Afrom%5D=50000&search%5Bfilter_float_price%3Ato%5D=300000&search%5Bfilter_enum_market%5D%5B0%5D=secondary",
                "https://gratka.pl/nieruchomosci/mieszkania/gdansk?cena-calkowita:min=5000&cena-calkowita:max=300000&cena-za-m2:max=7000&rynek=wtorny&lokalizacja_region=pomorskie&sort=activated_at:desc",
                // "https://www.otodom.pl/sprzedaz/mieszkanie/gdansk/?search[filter_float_price%3Afrom]=50000&search[filter_float_price%3Ato]=300000&search[filter_float_price_per_m%3Ato]=7000&search[filter_enum_market][0]=secondary&search[description]=1&search[dist]=0&search[subregion_id]=439&search[city_id]=40",
                // "https://dom.trojmiasto.pl/nieruchomosci-rynek-wtorny/ikl,101,e1i,95_37_97,ai,_30000,x1i,_7000.html"
            ];
        }

        static getModelsList() {
            return [
                // olx
                (content) => {

                    const {document} = (new JSDOM(content)).window;

                    const tr = document.querySelectorAll("tr.wrap");
                    let list = [];

                    for (let i = 0; i < tr.length; i++) {
                        const t = tr[i];

                        const flat = {
                            title: t.querySelector('strong').innerHTML,
                            link: t.querySelector('a').protocol + "//" + t.querySelector('a').host + t.querySelector('a').pathname,
                            host: t.querySelector('a').host,
                            place: t.querySelector('small span').textContent.trim(),
                            date_txt: t.querySelector('small:nth-of-type(2) span').textContent.trim(),
                            price: t.querySelector('.price strong').innerHTML.trim(),
                            img: t.querySelector('img').src,
                            id: "olx_" + t.querySelector('table').dataset.id
                        };
                        flat.date = moment(flat.date_txt, "D MMM").toDate();

                        list.push(flat);
                    }

                    return list
                },
                // gratka
                (content) => {

                    const {document} = (new JSDOM(content.toString("utf-8"))).window; // to utf-8 is applied because of gratha does not have meta charset tag https://github.com/jsdom/jsdom#encoding-sniffing

                    const tr = document.querySelectorAll("a.teaser");
                    let list = [];

                    for (let i = 0; i < tr.length; i++) {
                        const t = tr[i];
                        const prices = t.querySelector('p.teaser__price').textContent.replace(/zł\n\s+/, 'zł|').replace(/\n\s+/g, ' ').trim().split("|");
                        const params = [...t.querySelectorAll('ul.teaser__params li')].map(li => {
                            return li.textContent.split(/:\s/)
                        }).reduce(
                            (p, n, i, a) => {
                                // console.log(p,n,i, a);
                                p[Dict.toKey(n[0])] = n[1];
                                return p;
                            }, {}
                        );

                        const flat = {
                            title: t.querySelector('h2.teaser__title').innerHTML,
                            link: t.protocol + "//" + t.host + t.pathname,
                            host: t.host,
                            place: t.querySelector('h3.teaser__location').textContent.replace(/\n\s+/g, ' ').trim(),
                            date_txt: t.querySelector('ul.teaser__info').textContent.trim(),
                            price: prices[0],
                            price_per_surface: prices[1], // added over
                            img: t.querySelector('img').dataset.src,
                            id: "gratka_" + t.id
                            // surface: params.
                        };
                        // flat.date = moment(flat.date_txt, "D MMM").toDate();

                        list.push(Object.assign(flat, params));
                    }

                    return list

                },
                // otodom
                (content) => {
                    return []
                },
                // trojmiasto
                (content) => {
                    return []
                }
            ]
        }

        static getModelsSingle() {
            return [
                // olx
                (content) => {

                    const {document} = (new JSDOM(content)).window;

                    const div = document.querySelector("#offerdescription");
                    const props = [...document.querySelectorAll('.descriptioncontent strong')].map(e => e.textContent);
                    const userElem = document.querySelector('.offer-user__details');

                    // console.log({
                    //     div, props, userElem
                    // });

                    let flat = {};

                    try {

                        flat = {
                            added: div && div.querySelector('.offer-titlebox__details em').textContent.match(/Dodane\s+(z telefonu\s+)?o (.*)/)[3],
                            from: props[0].trim(),
                            price_per_surface: props[1].trim(),
                            level: props[2].trim(),
                            furnishings: props[3].trim(),
                            market: props[4].trim(),
                            type_of_building: props[5].trim(),
                            surface: props[6].trim(),
                            rooms: props[7].trim(),
                            // finance: props[8].trim(),
                            description: div.querySelector('#textContent').textContent.trim(),
                            img: document.querySelector("#photo-gallery-opener img").src
                        };

                    } catch (e) {

                        console.log(e);
                        process.exit();

                    }

                    if (userElem) {
                        flat.user_name = userElem.querySelector('a').textContent.trim();
                        flat.user_link = userElem.querySelector('a').href;
                        flat.user_since = userElem.querySelector('.user-since').textContent;
                    }

                    return flat

                },
                // gratka
                (content) => {

                    const {document} = (new JSDOM(content.toString("utf-8"))).window;
                    let flat = {};

                    flat = Object.assign(flat, {
                        description: document.querySelector('section .description__rolled').textContent.trim()
                    });

                    return flat
                },
                // otodom
                (content) => {
                    const {document} = (new JSDOM(content)).window;

                    const params = document.querySelector('section.section-offer-params');
                    const contact = document.querySelector('.box-contact-info');
                    const desc = document.querySelector('section.section-offer-text');

                    let flat = {};


                    // try {


                    flat = {
                        added_at: document.querySelector('.text-details .right p:first-of-type').textContent.replace('Data dodania: ', ''),
                        from: contact.querySelector('.box-contact-info-type') ? contact.querySelector('.box-contact-info-type').textContent : undefined,
                        price_per_surface: params.querySelector('.param_price').innerHTML.match(/\/span>\s*(.*)/)[1],
                        level: params.querySelector('.param_floor_no').textContent.trim(),
                        furnishings: null,
                        market: undefined,
                        type_of_building: undefined,
                        surface: params.querySelector('.param_m span strong').textContent.trim(),
                        rooms: params.querySelector('li.param_m + li').textContent.trim(),
                        description: desc.querySelector('.text-contents [itemprop="description"]').textContent.trim(),
                        user_name: contact.querySelector(".box-person-name").textContent.trim(),
                        user_link: undefined,
                        user_since: undefined
                    };
                    // } catch (e) {
                    //     console.log(String(content));
                    //     console.log(e);
                    //     process.exit();
                    //
                    // }

                    return flat;
                },
                // trojmiasto
                (
                    content
                ) => {
                    return {}
                }
            ]
        }

        static name() {
            return [
                'olx',
                'gratka',
                'otodom',
                'trojmiasto'
            ];
        }

        static fileList() {
            return this.name().map(name => `raw/${name}.html`);
        }

        /**
         * Return names of files with offers, there are generated random names
         *
         * @returns [function]
         */
        static fileSingle() {
            return new Array(this.fileList().length).fill((offer) => `raw/${offer.id}.html`)
        }
    }
;