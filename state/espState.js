const bodyParser = require("body-parser");
const greenHouseState = require("./greenhouse");
const plantsState = require("./plants");

const espState = async (ws, app, company) => {
    const ids = company.collections.reduce((acc, item) => {
        if (item.name === "greenHouse" || item.name === "plants") {
            acc[item.name] = item["$id"];
        }
        return acc;
    }, {});

    const GREENHOUSE_ID = ids.greenHouse || null;
    const PLANTS_ID = ids.plants || null;

    app.use(bodyParser.json());

    app.post("/webhook", (req, res) => {
        let response = req.body;
        if (response["$databaseId"] === company.database) {
            switch (response["$collectionId"]) {
                case GREENHOUSE_ID:
                    if (response["$id"] === company.greenHouse)
                        greenHouseState.updateESP(ws, response);
                    break;
                case PLANTS_ID:
                    if (response.greenHouse["$id"] === company.greenHouse)
                        plantsState.updateESP(ws, response);
                    break;
            }
        }
        res.sendStatus(200);
    });
};

module.exports = espState;
