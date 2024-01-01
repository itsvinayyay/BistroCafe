const admin = require("firebase-admin");
const functions = require("firebase-functions");


exports.deleteOldOrders = functions.firestore
    .document("groceryStores/{storeID}/requestedOrders/{orderID}")
    .onCreate(async (snapshot, context) => {
      const orderData = snapshot.data();
      const orderTimestamp = orderData.timestamp;
      const now = admin.firestore.FieldValue.serverTimestamp();
      const oneMinuteAgo = new Date(now.toMillis() - 60 * 1000);
      if (orderTimestamp < oneMinuteAgo) {
      // Order is older than 1 minute, delete it
        await snapshot.ref.delete();
      // Notify the user here
      }
    });
