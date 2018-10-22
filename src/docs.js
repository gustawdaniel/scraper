const fs = require('fs');
const readline = require('readline');
const colors = require('colors');
const {google} = require('googleapis');

// If modifying these scopes, delete credentials.json.
const SCOPES = [
    'https://www.googleapis.com/auth/spreadsheets.readonly',
    'https://www.googleapis.com/auth/spreadsheets'
];
const TOKEN_PATH = 'token.json';
const SPREAD_SHEET_ID = process.env.SPREAD_SHEET_ID;

module.exports =

    class Docs {

        /**
         * Create an OAuth2 client with the given credentials, and then execute the
         * given callback function.
         * @param {Object} credentials The authorization client credentials.
         * @param {function} callback The callback to call with the authorized client.
         */
        static authorize(credentials, callback) {
            const {client_secret, client_id, redirect_uris} = credentials.installed;
            const oAuth2Client = new google.auth.OAuth2(
                client_id, client_secret, redirect_uris[0]);

            oAuth2Client.setCredentials(JSON.parse(process.env.GOOGLE_TOKEN));
            callback(oAuth2Client);
        }

        static writeLine(values, range) {

            // Load client secrets from a local file.
            fs.readFile('credentials.json', (err, content) => {
                if (err) return console.log('Error loading client secret file:', err);
                // Authorize a client with credentials, then call the Google Sheets API.
                // authorize(JSON.parse(content), listMajors);
                this.authorize(JSON.parse(content), writeConfigurableValues(values, range));
            });

        }

        static saveOffer(offer) {

            if(!offer.hasOwnProperty('line')) {
                throw new Error("Offer should have 'line' property");
            }

            // console.log("-------------- OFF START -------------");
            // console.log(offer);
            // console.log("-------------- OFF FINAL -------------");
            // console.log("-------------- VAL START -------------");
            // console.log(this.arraifyOffer(offer));
            // console.log("-------------- VAL FINAL -------------");
            this.writeLine(this.arraifyOffer(offer), `A${offer.line}`);
        }

        static get fieldsToArraify() {
            return [
                'title',
                'place',
                'price',
                'surface',
                'price_per_surface',
                'rooms',
                'description',
                'img',
                'host',
                'link',
                'created_at'
            ]
        };

        /**
         *
         * @param offer Object
         * @return []
         */
        static arraifyOffer(offer) {
            // if(!offer.hasOwnProperty('description')) {
            //     throw new Error("Offer should have 'description' if it is saved to google docs");
            // }
            if(offer.hasOwnProperty('description')) {
                offer.description = offer.description.replace(/\n/g, " ");
            }

            return this.fieldsToArraify.map(field => offer[field]).map(s => String(s))
        }

        static get SPREAD_SHEET_ID() {
            return SPREAD_SHEET_ID;
        }

    };

/**
 * Prints the names and majors of students in a sample spreadsheet:
 * @see https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
 * @param {google.auth.OAuth2} auth The authenticated Google OAuth client.
 */
function listMajors(auth) {
    const sheets = google.sheets({version: 'v4', auth});
    sheets.spreadsheets.values.get({
        spreadsheetId: SPREAD_SHEET_ID, // my
        range: 'A2:E',
    }, (err, res) => {
        if (err) return console.log('The API returned an error: ' + err);
        const rows = res.data.values;
        if (rows.length) {
            console.log('Name, Major:');
            // Print columns A and E, which correspond to indices 0 and 4.
            rows.map((row) => {
                console.log(`${row[0]}, ${row[4]}`);
            });
        } else {
            console.log('No data found.');
        }
    });
}

function writeConfigurableValues(externalValues, range) { // ['Alina'], 'E4'

    return (auth) => {
        const sheets = google.sheets({version: 'v4', auth});

        const values = [ externalValues ];
        const body = { values: values };
        const params = {
            spreadsheetId: SPREAD_SHEET_ID,
            range,
            valueInputOption: 'USER_ENTERED',
            resource: body
        };

        const callback = function(err, response) {

            if (err) {
                console.error("SYNC ERR".red, range, err.response.status);

                if(err.response.status === 429) {

                    setTimeout(() => {
                        console.log("SYNC CALL".blue, params.range);
                        sheets.spreadsheets.values.update(params, callback);
                    }, 10000);
                } else {
                    console.log("--- ERROR START ---".red);
                    console.log("params", params);
                    console.log("error", err);
                    console.log("---  ERROR END  ---".red);
                }

            } else {
                console.info("SYNC RES".green, range, response.status);
            }

        };

        sheets.spreadsheets.values.update(params, callback);

    }

}
