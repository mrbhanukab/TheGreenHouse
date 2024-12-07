const {database} = require("../utils/appwrite");
const { Query, ID } = require('node-appwrite');

const auth = async (ws, data, compnay) => {
    const userCollection = compnay.collections.find(collection => collection.name === 'users')?.$id ?? null;
    const search = await database.listDocuments(compnay.database, userCollection, [Query.equal('rfid', data)]);
    if(search.total === 0) {
        ws.send("auth/nun");
        return;
    }
    const user = await database.getDocument(compnay.database, userCollection, search.documents[0]["$id"]);
    const greenHouseQuery = user.greenHouse.find(item => item["$id"] === compnay.greenHouse);

   if (greenHouseQuery) {
    ws.send("auth/approved");
    const alertCollection = compnay.collections.find(collection => collection.name === 'alerts')?.$id ?? null;

    if (alertCollection) {
        const alertData = {
            when: new Date().toISOString(),
            type: 'urgent',
            title: 'Someone Entered The GreenHouse!',
            msg: 'An unauthorized entry was detected in the greenhouse.',
            greenHouse: compnay.greenHouse,
        };

        await database.createDocument(compnay.database, alertCollection, ID.unique(), alertData);
    }
}

    else ws.send("auth/denied");
}

module.exports = auth;