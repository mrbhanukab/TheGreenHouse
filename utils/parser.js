/**
 * Parses a text string formatted as 'key=value;key=value;...' and converts it to an object.
 * @param {string} text - The text string to parse.
 * @returns {Object} - The resulting object with key-value pairs.
 */

function parseTextToObject(text) {
    return text.split(';').reduce((acc, pair) => {
        const [key, value] = pair.split('=');
        acc[key] = value;
        return acc;
    }, {});
}

module.exports = parseTextToObject;