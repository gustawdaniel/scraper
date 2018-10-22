const fs = require('fs');
const axios = require('axios');
const Config = require("./config");

module.exports =

class Scraper {

    /**
     * fetch url and extract data in agree with model
     *
     * @param url
     * @param file
     * @param model
     */
    static async getAndProcess(url, file, model) {

        if (!fs.existsSync(file)) {
            await axios.get(url)
                .then(response => {
                    fs.writeFileSync(file, response.data);
                })
                .catch(error => {
                    console.log(error);
                });
        }

        const html = fs.readFileSync(file);

        let data = {};

        try {
            data = model(html);
        } catch (e) {
            console.log(e);
            console.log("FILE ", file, "URL ", url);
            process.exit();
        }

        return data;
    }

    static async unlinkListFiles() {
        try {
            Config.name().forEach(name => {
                fs.unlinkSync(`raw/${name}.html`);
            });
            console.log('successfully deleted list files');
        } catch (err) {
            // handle the error
            console.log(err);
            process.exit();
        }
    }
};