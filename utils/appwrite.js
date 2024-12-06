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
    updateDocument: async (databaseID, collectionId, documentId, data) => {
        return await databases.updateDocument(databaseID, collectionId, documentId, data);
    },
    offline: async (databaseID, collectionId, documentId, set) => {
        return await databases.updateDocument(databaseID, collectionId, documentId, {
            "online": set
        });
    },

}

module.exports = {database};