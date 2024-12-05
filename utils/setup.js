const { Query } = require("node-appwrite");

const { database } = require("./appwrite");
const parseTextToObject = require("./parser");

const waitForMessage = async (ws) => {
  return new Promise((resolve) => {
    ws.once("message", async (message) => {
      try {
        if (Buffer.isBuffer(message)) {
          message = message.toString("utf-8");
        }
        const received = parseTextToObject(message);
        const databaseList = await database.listDatabases([
          Query.equal("name", received.company),
        ]);
        if (databaseList.total === 0) {
          throw new Error("Database not found");
        }

        const collectionsList = await database.listCollections(
          databaseList.databases[0]["$id"],
        );
        if (collectionsList.total === 0) {
          throw new Error("Collections not found");
        }

        const collections = collectionsList.collections.map((collection) => ({
          name: collection.name,
          $id: collection.$id,
        }));

        const greenHousesList = await database.listDocuments(
          databaseList.databases[0]["$id"],
          collections[0]["$id"],
          [Query.equal("name", received.greenhouse)],
        );
        if (greenHousesList.total === 0) {
          throw new Error("Database not found");
        }
        const plants = await database.listDocuments(
          databaseList.databases[0]["$id"],
          collections[1]["$id"],
          [Query.equal("greenHouse", greenHousesList.documents[0]["$id"])],
        );
        let plantKeyValuePairs = "0";
        if (plants.total > 0) {
          plantKeyValuePairs = plants.documents
            .map(
              (plant) =>
                `${plant.name}:moisture=${plant.moistureSensor},pump=${plant.pump}`,
            )
            .join(";");
        }
        ws.send(plantKeyValuePairs);
        resolve({
          database: databaseList.databases[0]["$id"],
          greenhouse: greenHousesList.documents[0]["$id"],
          collections: collections,
        });
      } catch (error) {
        console.log(error.message);
        ws.send("whoareyou?");
      }
    });
  });
};

module.exports = { waitForMessage };
