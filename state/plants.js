const plantsState = {
  plants: {},
  updateESP: (ws, update) => {
    const plantId = update['$id'];
    const currentPlantState = plantsState.plants[plantId] || {
      name: update.name,
      currentMoisture: null,
      moistureLimits: null,
      moistureSensor: null,
      pump: null,
    };

    const changes = [];
    const stateKeys = ['moistureLimits', 'moistureSensor', 'pump'];

    stateKeys.forEach(key => {
      if (update[key] !== currentPlantState[key]) {
        changes.push(`${key}=${update[key]}`);
        currentPlantState[key] = update[key];
      }
    });

    if (changes.length > 0) {
      ws.send(`${currentPlantState.name}:${changes.join(';')}`);
    }

    plantsState.plants[plantId] = currentPlantState;
  },
  updateDB: () => {}
};

module.exports = plantsState;