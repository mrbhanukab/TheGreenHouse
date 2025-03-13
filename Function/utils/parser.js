/**
 * Parses a text string formatted as 'key=value;key=value;...' and converts it to an object.
 * @param {string} text - The text string to parse.
 * @returns {Object} - The resulting object with key-value pairs.
 */

const parseTextToObject = (text) => {
  const obj = {};
  const pairs = text.split(';');

  pairs.forEach(pair => {
    const [key, value] = pair.split('=');
    if (value === 'true' || value === 'false') {
      obj[key] = value === 'true';
    } else if (!isNaN(value)) {
      obj[key] = Number(value);
    } else {
      obj[key] = value;
    }
  });

  return obj;
};

module.exports = parseTextToObject;