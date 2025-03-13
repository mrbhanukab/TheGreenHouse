const greenHouseState = require("./greenhouse");
const plantsState = require("./plants");
const auth = require("./auth");
const parseTextToObject = require("../utils/parser");

const dbState = async (ws, msg, company) => {
  console.log(msg);

  const [prefix, data] = msg.split('/');
  const parsedData = parseTextToObject(data);

  switch (prefix) {
      case 'env':
          await greenHouseState.updateDB(ws, parsedData, company);
          break;
      case 'plant':
          plantsState.updateDB(ws, parsedData, company);
          break;
      case 'auth':
          auth(ws, data, company);
          break;
      default:
          ws.send("what?");
  }
};

module.exports = dbState;