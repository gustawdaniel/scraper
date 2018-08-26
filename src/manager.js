const Docs = require('./docs');
const Config = require('./config');
const Helper = require('./helper');

module.exports =

    class Manager {

        constructor({db}) {
            this.db = db;
        }


        /**
         *
         * @param offer
         */
        async syncOffer(offer) {
            const Offers = this.db.collection('offers');

            const savedOffer = await Offers.findOne({link: offer.link});
            offer = Object.assign(offer, savedOffer);

            // console.log("ADD", offer);

            // process.exit();

            if(!Helper.equalObjects(offer, savedOffer)) {

                // console.log(JSON.stringify(offer));
                // console.log(JSON.stringify(savedOffer));

                Offers.update({_id: offer._id}, offer);
                Docs.saveOffer(offer);
            }


        }

        /**
         *
         * @param list
         */
        async syncList(list) {
            const Offers = this.db.collection('offers');

            for (let i = 0; i < list.length; i++) {

                const offer = await Offers.findOne({link: list[i].link});

                if (!offer) {

                    const line = 2 + await Offers.countDocuments();
                    Offers.insert(
                        Object.assign(list[i], {line})
                    );
                    Docs.saveOffer(list[i]);
                }
            }
        }
    };