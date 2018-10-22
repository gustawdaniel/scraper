// load config

// connect to database

// while not err

   // for services

       // get indexes

       // get new pages

       // sync with database

       // sync with google docs

       // send emails

       // send smses

require('dotenv').load();

const Config = require("./src/config");
const Scraper = require("./src/scraper");
const Docs = require("./src/docs");
const Mailer = require("./src/mailer");
const Helper = require("./src/helper");
const Manager = require("./src/manager");
const Sms = require("./src/sms");
const fs = require('fs');

const MongoClient = require('mongodb').MongoClient;
const assert = require('assert');
const sleep = require('sleep');

const services = Config.getServices();
let error = false;
let index = 0;

// Connection URL
const mongoUri = 'mongodb://localhost:27017';
const GOOGLE_CREDENTIALS = process.env.GOOGLE_CREDENTIALS;
Docs.authorize(JSON.parse(GOOGLE_CREDENTIALS), () => {});

(async function() {
    try {

        const client = await MongoClient.connect(mongoUri, { useNewUrlParser: true });
        const db = client.db('real_estate');
        const manager = new Manager({db});
        // ... anything

        console.log("Connected successfully to database");
        console.log("NODE ENV", process.env.NODE_ENV);

        while (!error) {

            for(let s=0; s<services.length; s++) {

                const list = await Scraper.getAndProcess(services[s].url, services[s].fileList, services[s].modelList);

                await manager.syncList(list);

                for(let l=0; l<list.length; l++) {

                    const additional = await Scraper.getAndProcess(list[l].link, services[s].fileSingle(list[l]), Helper.selectModel(list[l]));

                    Object.assign( list[l], additional );

                    console.log("ok", list[l].host, list[l].id, list[l].title);
                    await manager.syncOffer(list[l]);

                }

            }

            index++;
            await Scraper.unlinkListFiles();
            console.log("INDEX: ", index, "Time: ", new Date());
            sleep.msleep(400000);
        }

        client.close();
    } catch(e) {
        console.error(e)
    }

})();