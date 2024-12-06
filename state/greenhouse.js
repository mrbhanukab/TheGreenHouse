const {database} = require("../utils/appwrite");

const greenHouseState = {
    forcedLight: false,
    currentTemperature: -10,
    currentHumidity: 0,
    temperatureLimit: -10,
    humidityLimit: 0,

    // Update ESP state if there are changes
    updateESP: (ws, update) => {
        const changes = [];
        const stateKeys = ['forcedLight', 'temperatureLimit', 'humidityLimit'];

        // Check for changes in the state and update accordingly
        stateKeys.forEach(key => {
            if (update[key] !== greenHouseState[key]) {
                changes.push(`${key}=${update[key]}`);
                greenHouseState[key] = update[key];
            }
        });

        // Send the changes to the WebSocket client if there are any
        if (changes.length > 0) {
            ws.send(changes.join(';'));
        }
    },

    // Update the database with current temperature and humidity
    updateDB: async (ws, data, company) => {
        const greenHouseId = company.collections.find(collection => collection.name === 'greenHouse')?.$id ?? null;
        if (greenHouseId !== null) {
            const filteredData = {
                currentTemperature: data.currentTemperature,
                currentHumidity: data.currentHumidity
            };
            await database.updateDocument(company.database, greenHouseId, company.greenHouse, filteredData);
            ws.send("ok");
        }
    }
};

module.exports = greenHouseState;