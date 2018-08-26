const fs = require('fs');
const readline = require('readline');
const {google} = require('googleapis');

// If modifying these scopes, delete credentials.json.
const SCOPES = [
    'https://www.googleapis.com/auth/spreadsheets.readonly',
    'https://www.googleapis.com/auth/spreadsheets'
];
const TOKEN_PATH = 'token.json';
const SPREAD_SHEET_ID = '1W2np3pzAJHz6jZ9cbraHVbzvvHGXoh_rtciKF8jyDJs';

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

            // Check if we have previously stored a token.
            fs.readFile(TOKEN_PATH, (err, token) => {
                if (err) return getNewToken(oAuth2Client, callback);
                oAuth2Client.setCredentials(JSON.parse(token));
                callback(oAuth2Client);
            });
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

            console.log("-------------- OFF START -------------");
            console.log(offer);
            console.log("-------------- OFF FINAL -------------");
            console.log("-------------- VAL START -------------");
            console.log(this.arraifyOffer(offer));
            console.log("-------------- VAL FINAL -------------");
            this.writeLine(this.arraifyOffer(offer), `A${offer.line}`);
        }

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
            // return Object.values(offer).map(s => String(s))
            return [
                offer.title,
                offer.link,
                offer.host,
                offer.place,
                offer.date_txt,
                offer.price,
                offer.img,
                offer.id,
                offer.date,
                offer.added,
                offer.from,
                offer.price_per_surface,
                offer.level,
                offer.furnishings,
                offer.market,
                offer.type_of_building,
                offer.surface,
                offer.rooms,
                offer.description,
                offer.user_name,
                offer.user_link,
                offer.user_since,
                offer._id,
                offer.line,
            ].map(s => String(s))
        }

    };

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 * @param {google.auth.OAuth2} oAuth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback for the authorized client.
 */
function getNewToken(oAuth2Client, callback) {
    const authUrl = oAuth2Client.generateAuthUrl({
        access_type: 'offline',
        scope: SCOPES,
    });
    console.log('Authorize this app by visiting this url:', authUrl);
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    });
    rl.question('Enter the code from that page here: ', (code) => {
        rl.close();
        oAuth2Client.getToken(code, (err, token) => {
            if (err) return callback(err);
            oAuth2Client.setCredentials(token);
            // Store the token to disk for later program executions
            fs.writeFile(TOKEN_PATH, JSON.stringify(token), (err) => {
                if (err) console.error(err);
                console.log('Token stored to', TOKEN_PATH);
            });
            callback(oAuth2Client);
        });
    });
}

/**
 * Prints the names and majors of students in a sample spreadsheet:
 * @see https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
 * @param {google.auth.OAuth2} auth The authenticated Google OAuth client.
 */
function listMajors(auth) {
    const sheets = google.sheets({version: 'v4', auth});
    sheets.spreadsheets.values.get({
        spreadsheetId: SPREAD_SHEET_ID, // my
        // spreadsheetId: '1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms', // sample
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

        var values = [
            externalValues
        ];
        var body = {
            values: values
        };
        sheets.spreadsheets.values.update({
            spreadsheetId: SPREAD_SHEET_ID,
            range,
            valueInputOption: 'USER_ENTERED',
            resource: body
        })
        // .then((response) => {
        // if (err===0) {
        //     console.log(err);
        // } else {
        //     var result = response.result;
        //     console.log(`${result.updatedCells} cells updated.`);
        // }
        // });

    }

}
