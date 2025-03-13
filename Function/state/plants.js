const {database} = require("../utils/appwrite");
const {Query} = require("node-appwrite");
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
    updateDB: async (ws, data, company) => {
        const plant = Object.values(plantsState.plants).find(plant => plant.name === data.name);

        if (!plant) {
            const plantsID = company.collections.find(collection => collection.name === 'plants')?.$id ?? null;
            const list = await database.listDocuments(company.database, plantsID, [Query.equal("name", data.name)]);
            console.log(list);
            if (list.total === 0) {
                ws.send("what?");
            } else {
                const newPlant = {
                    name: data.name,
                    currentMoisture: list.documents[0].currentMoisture,
                    moistureLimits: list.documents[0].moistureLimits,
                    moistureSensor: list.documents[0].moistureSensor,
                    pump: list.documents[0].pump,
                };
                plantsState.plants[list.documents[0].$id] = newPlant;
                console.log(`New plant created: ${data.name}: `, plantsState.plants[list.documents[0].$id]);
            }
        }
    }
};

module.exports = plantsState;