const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();


exports.sendNotifications = functions.firestore
  .document("users/{uid}/notifications/{id}")
  .onCreate((snapshot) => {
    const name = snapshot.get("lastUserUsername");
    const subject = snapshot.get("title");
    const body = snapshot.get("body");
    const token = snapshot.get("currentNotificationsToken");
    const payload = {
      notification: {
        title: "about : " + subject,
        body: name + " " + body,
        sound: "default",
      },
    };
    return fcm.sendToDevice(token, payload);
  });

/*exports.sendNotifications = functions.https.onCall(async (data, context) => {
  //const uid = context.auth.uid;
  //console.log('currentUser = ' + uid);

  return functions.firestore
  .document("users/{uid}/notifications/{id}")
  .onCreate((snapshot) => {
    const name = snapshot.get("lastUserUsername");
    const subject = snapshot.get("title");
    const body = snapshot.get("body");
    const token = snapshot.get("currentNotificationsToken");
    const payload = {
      notification: {
        title: "About : " + subject,
        body: name + " " + body,
        sound: "default",
      },
    };
    console.log('listener notifications done :');
    return fcm.sendToDevice(token, payload);
  });
});*/

