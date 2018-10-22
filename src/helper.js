const Config = require("./config");


module.exports =

    class Helper {


        /**
         * Compare if two objects are equal
         *
         * @param a Object
         * @param b Object
         * @return {boolean}
         */
        static equalObjects(a, b) {
            return JSON.stringify(a, Object.keys(a).sort()) === JSON.stringify(b, Object.keys(b).sort())
        }


        /**
         * Allow select method of calculation applied in dependence of host scraped page
         *
         * @param list
         * @returns {function}
         */
        static selectModel(list) {
            if(!list.hasOwnProperty('host')) {
                throw new Error("List element should have 'host' property");
            }

            switch (list.host) {
                case "www.olx.pl": {
                    return Config.getModelsSingle()[0]; // because of olx is first
                }
                case "www.otodom.pl": {
                    return Config.getModelsSingle()[2] // because otodom is third
                }
                case "gratka.pl": {
                    return Config.getModelsSingle()[1] // gratka is second service
                }
                case "dom.trojmiasto.pl": {
                    return Config.getModelsSingle()[3] // trojmiasto is forth service
                }
                default: {
                    return (content) => { return {}; } // by default model is undefined
                }
            }
        }
    };
