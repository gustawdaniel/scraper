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
    created_at: new Date('2018-07-31'),

};

let o2 = {}; Object.assign(o2, o1, {description: "ok"});

const o1Expected = [
    "Mieszkanie Gdańsk Gdańsk, Nowy Port, ul. Marynarki Polskiej",
    "GDAŃSK, GDAŃSK, NOWY PORT, pomorskie",
    "199 000 zł",
    "32",
    "6 219 zł/m2",
    "1",
    "ok",
    "https://d-gr.ppstatic.pl/kadry/k/r/gr-ogl/5e/86/5303893_262556883_mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej_medium.jpg",
    "gratka.pl",
    "https://gratka.pl/nieruchomosci/mieszkanie-gdansk-gdansk-nowy-port-ul-marynarki-polskiej/ob/5303893",
    String(new Date('2018-07-31'))
];

test('docs arraify test', () => {
    // expect(() => {
    //     Docs.arraifyOffer(o1);
    // }).toThrow("Offer should have 'description' if it is saved to google docs");

    expect(Docs.arraifyOffer(o2)).toEqual(o1Expected);
});