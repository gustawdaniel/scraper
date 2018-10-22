const RECEIVER_NUMBER = process.env.RECEIVER_NUMBER;

module.exports =

    class Sms {

        /**
         * Send info about offer in sms
         *
         * @param offer Object
         * @return {boolean}
         */
        static shouldSend(offer) {
            return false;
        }

        /**
         * Check conditions of sending SMS
         *
         * @param offer Object
         * @return {boolean}
         */
        static send(offer) {
            return true;
        }

    };