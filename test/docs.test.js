const Docs = require('../src/docs');

const o1 = { title:
        'Mieszkanie Gdańsk Gdańsk, Nowy Port, ul. Marynarki Polskiej',
    link:
        'https://gratka.pl/nieruchomosci/mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej/ob/5303893',
    host: 'gratka.pl',
    place:
        'GDAŃSK, GDAŃSK, NOWY PORT, pomorskie',
    date_txt: 'Aktualizacja: 2018-07-31',
    price: '199 000 zł',
    price_per_surface: '6 219 zł/m2',
    img:
        'https://d-gr.ppstatic.pl/kadry/k/r/gr-ogl/5e/86/5303893_262556883_mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej_medium.jpg',
    id: 'gratka_123',
    surface: '32',
    rooms: '1',
    level: '1',
    form_of_ownership: 'własność',
    state: 'do odświeżenia',
    built_at: '1930',
    date: new Date('2018-07-31')
};

let o2 = {}; Object.assign(o2, o1, {description: "ok"});

const o1Expected = [
       "Mieszkanie Gdańsk Gdańsk, Nowy Port, ul. Marynarki Polskiej",
       "https://gratka.pl/nieruchomosci/mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej/ob/5303893",
       "gratka.pl",
       "GDAŃSK, GDAŃSK, NOWY PORT, pomorskie",
       "Aktualizacja: 2018-07-31",
       "199 000 zł",
    "https://d-gr.ppstatic.pl/kadry/k/r/gr-ogl/5e/86/5303893_262556883_mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej_medium.jpg",
    "gratka_123",
    String(new Date('2018-07-31')),
    "undefined",
    "undefined",
    "6 219 zł/m2",
    "1",
    "undefined", // Furnishings
    "undefined", // market
    "undefined", // building type
    "32",
    "1",
    "ok",
    "undefined",
    "undefined",
    "undefined",
    "undefined",
    "undefined",
];

test('docs arraify test', () => {
    expect(() => {
        Docs.arraifyOffer(o1);
    }).toThrow("Offer should have 'description' if it is saved to google docs");

    expect(Docs.arraifyOffer(o2)).toEqual(o1Expected);
});