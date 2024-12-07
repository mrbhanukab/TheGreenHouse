const {Query} = require("node-appwrite");
const {database} = require("./appwrite");
const parseTextToObject = require("./parser");

const waitForMessage = async (ws) => {
    return new Promise((resolve) => {
        ws.once("message", async (message) => {
            try {
                // Convert message to string if it's a buffer
                if (Buffer.isBuffer(message)) {
                    message = message.toString("utf-8");
                }

                // Parse the received message into an object
                const received = parseTextToObject(message);
                console.log(message);

                // Fetch the database list
                const databaseList = await database.listDatabases([Query.equal("name", received.company)]);

                // Check if the database exists
                if (databaseList.total === 0) throw new Error("Database not found");

                // Fetch the collections list
                const collectionsList = await database.listCollections(databaseList.databases[0]["$id"]);

                // Check if collections exist
                if (collectionsList.total === 0) throw new Error("Collections not found");

                // Map collections to a simpler format
                const collections = collectionsList.collections.map((collection) => ({
                    name: collection.name,
                    $id: collection.$id,
                }));

                // Fetch the greenhouse document
                const greenHousesList = await database.listDocuments(
                    databaseList.databases[0]["$id"],
                    collections[0]["$id"],
                    [Query.equal("name", received.greenHouse)]
                );

                // Check if the greenhouse exists
                if (greenHousesList.total === 0) throw new Error("Greenhouse not found");

                console.log(greenHousesList.documents[0]);
                // Fetch the plants documents
                const plants = await database.listDocuments(
                    databaseList.databases[0]["$id"],
                    collections[1]["$id"],
                    [Query.equal("greenHouse", greenHousesList.documents[0]["$id"])]
                );

                // // Create a string of plant key-value pairs
                // const plantKeyValuePairs = plants.total > 0
                //     ? plants.documents.map(
                //         (plant) => `${plant.name}:moisturePin=${plant.moistureSensor},pumpPin=${plant.pump}`
                //     ).join(";")
                //     : "0";
                //
                // // Send the plant key-value pairs to the WebSocket client
                // ws.send(plantKeyValuePairs);

                //send current limits
                ws.send("limits/temperatureLimit=" + greenHousesList.documents[0].temperatureLimit + ";humidityLimit=" + greenHousesList.documents[0].humidityLimit);

                // Resolve the promise with the database and greenhouse information
                resolve({
                    database: databaseList.databases[0]["$id"],
                    greenHouse: greenHousesList.documents[0]["$id"],
                    collections,
                });
            } catch (error) {
                // Log the error and send an error message to the WebSocket client
                console.log(error.message);
                ws.send("whoareyou?");
            }
        });
    });
};

module.exports = {waitForMessage};
