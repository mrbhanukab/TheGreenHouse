const appwrite = require('node-appwrite');

const client = new appwrite.Client();

client
    .setEndpoint(process.env.ENDPOINT)
    .setProject(process.env.PROJECT_ID)
    .setKey(process.env.API_KEY);

const databases = new appwrite.Databases(client);

const database = {
    listDatabases: async (query = []) => {
        return await databases.list([...query]);
    },
    listCollections: async (databaseId, query = []) => {
        return await databases.listCollections(databaseId, [...query]);
    },
    listDocuments: async (databaseID, collectionId, query = []) => {
        return await databases.listDocuments(databaseID, collectionId, [...query]);
    },

}

module.exports = {database};