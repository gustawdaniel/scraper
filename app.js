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
Docs.authorize(JSON.parse(fs.readFileSync('./credentials.json')), () => {});

(async function() {
    try {

        const client = await MongoClient.connect(mongoUri, { useNewUrlParser: true });
        const db = client.db('real_estate');
        const manager = new Manager({db});
        // ... anything

        console.log("Connected successfully to database");

        while (!error) {

            // console.log("ok ", index);

            for(let s=0; s<services.length; s++) {

                const list = await Scraper.getAndProcess(services[s].url, services[s].fileList, services[s].modelList);

                // console.log(services[s].name, list);

                await manager.syncList(list);

                for(let l=0; l<list.length; l++) {

                    const additional = await Scraper.getAndProcess(list[l].link, services[s].fileSingle(list[l]), Helper.selectModel(list[l]));



                    Object.assign( list[l], additional );

                    console.log("ok", list[l].host, list[l].id, list[l].title);
                    await manager.syncOffer(list[l]);

                    // break
                }

            }



            if(index >= 100) { break; }
            index++;
            await Scraper.unlinkListFiles();
            console.log("INDEX: ", index);
            sleep.msleep(400000);
        }

        client.close();
    } catch(e) {
        console.error(e)
    }

})();