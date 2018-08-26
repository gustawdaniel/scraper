const Dict = require('../src/dict');

test('dict test', () => {
    expect(Dict.toKey('Piętro')).toBe('level');
    expect(Dict.toVal('level')).toBe('Piętro');
});