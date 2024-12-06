const express = require('express');
const WebSocket = require('ws');

const {waitForMessage} = require("./utils/setup");
const espState = require("./state/espState");
const dbState = require("./state/dbState");
const {database} = require("./utils/appwrite");

const app = express();
const wss = new WebSocket.Server({port: process.env.PORT});

app.listen(process.env.WEBHOOK);

wss.on('connection', async (ws) => {
    //! awaiting the device initialization message
    const company = await waitForMessage(ws);
    const greenHouseId = company.collections.find(collection => collection.name === 'greenHouse')?.$id ?? null;
    await database.offline(company.database, greenHouseId, company.greenHouse, true)

    //! managing state:esp32 State
    await espState(ws, app, company);

    //! managing state:database State
    ws.on('message', (message) => {
        if (Buffer.isBuffer(message)) {
            message = message.toString("utf-8");
        }
        dbState(ws, message, company);
    });

    console.log(company);
    const handleDisconnect = () => {
        const greenHouseId = company.collections.find(collection => collection.name === 'greenHouse')?.$id ?? null;
        database.offline(company.database, greenHouseId, company.greenHouse, false)
    };

    ws.on('close', handleDisconnect);
    ws.on('error', handleDisconnect);
});

