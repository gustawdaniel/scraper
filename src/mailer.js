const Docs = require('./docs');
const nodemailer = require('nodemailer');
const RECEIVER_EMAIL = [];
const MAIL_USER = process.env.MAIL_USER;
const MAIL_PASS = process.env.MAIL_PASS;

if(process.env.NODE_ENV === 'test') {
    RECEIVER_EMAIL.push("gustaw.daniel@gmail.com");
} else {
    RECEIVER_EMAIL.push("andrzejbyzdra@gmail.com", "gustaw.daniel@gmail.com");
}


const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: MAIL_USER,
        pass: MAIL_PASS
    }
});


module.exports =

    class Mailer {

        /**
         * Send info about offer in email
         *
         * @param offer Object
         * @return {boolean}
         */
        static async send(offer) {

            const mailOptions = {
                from: 'sladziaczek@gmail.com',
                to: RECEIVER_EMAIL,
                subject: `New offer: ${offer.title}`,
                html: `<h3>Your real estate bot detected new offer</h3>

<table>
<tr><td>title</td><td>${offer.title}</td></tr>
<tr><td>place</td><td>${offer.place}</td></tr>
<tr><td>price</td><td>${offer.price}</td></tr>
<tr><td>surface</td><td>${offer.surface}</td></tr>
<tr><td>price_per_surface</td><td>${offer.price_per_surface}</td></tr>
<tr><td>rooms</td><td>${offer.rooms}</td></tr>
<tr><td>host</td><td>${offer.host}</td></tr>
<tr><td>link</td><td>${offer.link}</td></tr>
<tr><td>created_at</td><td>${offer.created_at}</td></tr>
</table>

<p>${offer.description}</p>

<img src="${offer.img}">

<p>All collected offers: <a href="https://docs.google.com/spreadsheets/d/${Docs.SPREAD_SHEET_ID}/edit#gid=0&range=A${offer.line}">
https://docs.google.com/spreadsheets/d/${Docs.SPREAD_SHEET_ID}/edit#gid=0&range=A${offer.line}</a></p>

<p>Have nice day and a lot of spectacular successes in the real estate industry.</p>
<p>Your bot</p>
`
            };

            return await new Promise((resolve, reject) => {
                transporter.sendMail(mailOptions, function(error, info){
                    if (error) {
                        console.log(error);
                        reject(false);
                    } else {
                        console.log('Email sent: ' + info.response);
                        console.log(RECEIVER_EMAIL);
                        resolve(true);
                    }
                });
            });

        }

    };