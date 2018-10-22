require('dotenv').load();
const fs = require('fs');
const MongoClient = require('mongodb').MongoClient;

const Docs = require("./src/docs");

// Connection URL
const mongoUri = 'mongodb://localhost:27017';
const GOOGLE_CREDENTIALS = process.env.GOOGLE_CREDENTIALS;
Docs.authorize(JSON.parse(GOOGLE_CREDENTIALS), () => {});

const FROM = process.argv[2] ? Number.parseInt(process.argv[2]) : undefined;
const TO = process.argv[3] ? Number.parseInt(process.argv[3]) : FROM;

console.log(`FROM: ${FROM}\nTO: ${TO}\n`);

if(!FROM) {
    throw new Error("Add arguments: 1) line to start sync 2) line to end sync");
}

(async () => {

    try {

        const client = await MongoClient.connect(mongoUri, {useNewUrlParser: true});
        const db = client.db('real_estate');

        const Offers = db.collection('offers');

        console.log("BEFORE FOR");
        for(let line = FROM; line <= TO; line++) {

            console.log("IN FOR", line);

            const savedOffer = await Offers.findOne({line});

            console.log(savedOffer);

            Docs.saveOffer(savedOffer);

        }

    } catch (e) {
        console.log(e)
    }


})();