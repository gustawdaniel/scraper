module.exports =

    class Dict {
        static get params() {
            return {
                surface: ['Powierzchnia w m2'],
                rooms: ['Liczba pokoi'],
                level: ['Piętro'],
                form_of_ownership: ['Forma własności'],
                built_at: ['Rok budowy'],
                type_of_building: ["Typ zabudowy"],
                state: ['Stan'],
                levels: ['Liczba pięter w budynku']
            }
        }

        static toKey(val) {
            return Object.keys(this.params)[Object.values(this.params).findIndex((e) => e.includes(val))];
        }

        static toVal(key) {
            return this.params[key].find(() => true);
        }
    };