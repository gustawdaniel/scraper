module.exports =

class Random {
    static id() {
        return ",,,,,,,,,,,,,,,,,".replace(/,/g,function (){
            return "AzByC0xDwEv9FuGt8HsIrJ7qKpLo6MnNmO5lPkQj4RiShT3gUfVe2WdXcY1bZa".charAt(Math.floor(Math.random()*62))
        });
    }
};

