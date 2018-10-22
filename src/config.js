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
                "https://www.otodom.pl/sprzedaz/mieszkanie/gdansk/?search%5Bfilter_float_price%3Afrom%5D=50000&search%5Bfilter_float_price%3Ato%5D=300000&search%5Bfilter_float_price_per_m%3Ato%5D=7000&search%5Bfilter_enum_market%5D%5B0%5D=secondary&search%5Bdescription%5D=1&search%5Bdist%5D=0&search%5Bsubregion_id%5D=439&search%5Bcity_id%5D=40&search%5Border%5D=created_at_first%3Adesc",
                "https://dom.trojmiasto.pl/nieruchomosci-rynek-wtorny/ikl,101,e1i,81_95_33_37_97_83_49_38_58_41_79_40_42_54_46_63_90_35_91_3_34_8_32_52_77_57_45_94_47_1_43_80_62_36_50_96_48_87_5_59_76_53_55_86_2_72_56_7_31,w,1,ai,50000_300000,x1i,_7000.html"
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
                            img: t.querySelector('img') ? t.querySelector('img').src : undefined,
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
                    const {document} = (new JSDOM(content)).window;

                    const tr = document.querySelectorAll(".col-md-content article");

                    const list = [];

                    for(let i = 0; i < tr.length; i++) {

                        const t = tr[i];
                        const flat = {
                            title: t.querySelector('h3 .offer-item-title').textContent,
                            link: t.querySelector('a').protocol + "//" + t.querySelector('a').host + t.querySelector('a').pathname,
                            host: t.querySelector('a').host,
                            place: t.querySelector('h3+.text-nowrap').textContent.replace(/^Mieszkanie na sprzedaż: /,''),
                            price: t.querySelector('.offer-item-price').textContent.trim(),
                            surface: t.querySelector('.offer-item-area').textContent,
                            price_per_surface: t.querySelector('.offer-item-price-per-m').textContent,
                            rooms: t.querySelector('.offer-item-rooms').textContent,
                            id: 'otodom_' + t.dataset.itemId,
                            img: JSON.parse(t.querySelector('figure').dataset.quickGallery)[0].photo
                        };

                        list.push(flat);

                    }

                    return list;
                },
                // trojmiasto
                (content) => {
                    const {document} = (new JSDOM(content.toString("utf-8"))).window;

                    const tr = document.querySelectorAll(".subcontent-body .ogl-item");

                    const list = [];

                    for(let i = 0; i < tr.length; i++) {

                        const t = tr[i];

                        const params = {};
                        const lis = t.querySelectorAll('.ogl-params li');
                        if(lis.length === 1) {
                            params.surface = lis[0].textContent;
                        } else if(lis.length === 3) {
                            params.rooms = lis[0].textContent;
                            params.surface = lis[1].textContent;
                            params.level = lis[2].textContent;
                        } else if(lis.length === 2) { // one case from 2018.09.16
                            params.surface = lis[0].textContent;
                            params.level = lis[1].textContent;
                        } else if(lis.length === 0) { // one case from 2018.09.16
                            // do nothing
                        } else {
                            console.log(i, lis.length, lis);
                            throw new Error("Not recognized number of general parameters");
                        }


                        const flat = {
                            title: t.querySelector('.text-wrap a').textContent,
                            link: t.querySelector('.text-wrap a').protocol + "//" + t.querySelector('.text-wrap a').host + t.querySelector('.text-wrap a').pathname,
                            host: t.querySelector('.text-wrap a').host,
                            place: t.querySelector('.place').textContent.replace(/\n?\s+/g, ' ').trim(),
                            price: t.querySelector('.prize strong').textContent.trim(),
                            surface: t.querySelector('.ogl-params').textContent,
                            price_per_surface: t.querySelector('.prize').textContent.match(/\((.*)\)/)[1].trim(),
                            id: 'trojmiasto_' + t.dataset.id,
                            img: t.querySelector('img').src
                        };

                        list.push(Object.assign(flat, params));

                    }

                    return list;
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
                            img: document.querySelector("#photo-gallery-opener img") ? document.querySelector("#photo-gallery-opener img").src : undefined
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


                    flat = {
                        added_at: document.querySelector('.text-details .right p:first-of-type').textContent.replace('Data dodania: ', ''),
                        from: contact.querySelector('.box-contact-info-type') ? contact.querySelector('.box-contact-info-type').textContent : undefined,
                        price_per_surface: params.querySelector('.param_price').innerHTML.match(/\/span>\s*(.*)/)[1],
                        level: params.querySelector('.param_floor_no') ? params.querySelector('.param_floor_no').textContent.trim() : undefined,
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


                    return flat;
                },
                // trojmiasto
                (
                    content
                ) => {
                    const {document} = (new JSDOM(content.toString("utf-8"))).window;

                    let flat = {};

                    flat = Object.assign(flat, {
                        description: document.querySelector('#dynamic-data .ogl-description').textContent.trim()
                    });

                    return flat;
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