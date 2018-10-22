require('dotenv').load({env: '../.env'});

const ObjectId = require("mongodb").ObjectId;
const Mailer = require('../src/mailer');

const offer = {
    "_id" : ObjectId("5b68c2ffcdc8c90323ce0799"),
    "title" : "2 pokoje. Idealne pod inwestycje.",
    "link" : "https://www.otodom.pl/oferta/2-pokoje-idealne-pod-inwestycje-ID3Jolq.html",
    "host" : "www.otodom.pl",
    "place" : "Gdańsk",
    "date_txt" : "3  sie",
    "price" : "191 700 zł",
    "img" : "https://img01-olxpl.akamaized.net/img-olxpl/746107429_1_261x203_2-pokoje-idealne-pod-inwestycje-gdansk.jpg",
    "id" : "olx_474671765",
    "date" : new Date("1970-01-01T00:00:00Z"),
    "added_at" : "03.08.2018",
    "from" : null,
    "price_per_surface" : "6 000 zł/m²",
    "level" : "Piętro parter (z 3)",
    "furnishings" : null,
    "market" : null,
    "type_of_building" : null,
    "surface" : "31,95 m²",
    "rooms" : "Liczba pokoi 2",
    "description" : "Kameralne osiedle zlokalizowane w południowej części Gdańska – przy ulicy Jabłoniowej. W spokojnym otoczeniu zaprojektowaliśmy trzy niewysokie budynki. Zaplanowane w nich zostały 224 mieszkania - kawalerki, dwu, trzy oraz czteropokojowe.Dzięki przemyślanej koncepcji architektonicznej - oraz możliwości indywidualnej aranżacji - lokatorzy wprowadzą się do przestronnych oraz funkcjonalnych wnętrz. Metraże lokali kształtują się od 23 do 56 mkw. Dla osób, które poszukują większej powierzchni, przygotowano możliwość ich łączenia. Większość lokali na parterze posiada ogródki i tarasy wybrukowane kostką, natomiast wszystkie mieszkania na piętrach mają duże balkony. Budynki będą wyposażone w szybkie i cichobieżne windy. Dla wygody osób zmotoryzowanych na terenie podziemnej kondygnacji zaprojektowano parking.Teren inwestycji zostanie zagospodarowany zielenią oraz wybrukowanymi alejkami, co umożliwi mieszkańcom wypoczynek bez konieczności opuszczania osiedla. Budynki będą ogrodzone i podłączone do miejskiej sieci ciepłowniczej Gdańska. Z myślą o najmłodszych lokatorach zaplanowano plac zabaw.",
    "user_name" : "Sedrak Danielyan",
    "user_link" : null,
    "user_since" : null,
    "line" : 21
};

test('sending email', () => {

    Mailer.send(offer).then(data => expect(data).toBe(true));

});