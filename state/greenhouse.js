const greenHouseState = {
  forcedLight: false,
  currentTemperature: -10,
  currentHumidity: 0,
  temperatureLimit: -10,
  humidityLimit: 0,
  updateESP: (ws, update) => {
    const changes = [];
    const stateKeys = ['forcedLight', 'currentTemperature', 'currentHumidity', 'temperatureLimit', 'humidityLimit'];

    stateKeys.forEach(key => {
      if (update[key] !== greenHouseState[key]) {
        changes.push(`${key}=${update[key]}`);
        greenHouseState[key] = update[key];
      }
    });

    if (changes.length > 0) {
      ws.send(changes.join(';'));
    }
  },
  updateDB: () => {}
};

module.exports = greenHouseState;