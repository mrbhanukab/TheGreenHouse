const express = require('express');
const WebSocket = require('ws');

const {waitForMessage} = require("./utils/setup");
const espState = require("./state/espState");
const dbState = require("./state/dbState");

const app = express();
const wss = new WebSocket.Server({port: process.env.PORT});

wss.on('connection', async (ws) => {
    console.log('Client connected');

    //! awaiting the device initialization message
    const company = await waitForMessage(ws);

    //! managing state:esp32 State
    await espState(ws, app, company);

    //! managing state:database State
    ws.on('message', (message) => {
        if (Buffer.isBuffer(message)) {
            message = message.toString("utf-8");
        }
        dbState(ws, message, company);
    });

    ws.on('close', () => {
        console.log('Client disconnected');
    });

    ws.on('error', (error) => {
        console.error('WebSocket error:', error);
    });
});

console.log('WebSocket server listening on port ', process.env.PORT);