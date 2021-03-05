const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();



exports.sendToTopic = functions.firestore
  .document("posts/{postID}/comments/{id}")
  .onCreate((snapshot, context) => {
    const postID = context.params.postID
    const name = snapshot.get("commentatorUsername");
    const subject = snapshot.get("subject");
    const payload = {
      notification: {
        title: subject,
        body: name + 'has commented this post 💬',
        sound: "default",
      },
    };
    return fcm.sendToTopic(postID, payload);
  });



/*exports.sendToTopic = functions.firestore
  .document("posts/" + postID + "/comments/{id}")
  .onCreate((snapshot) => {
    const name = snapshot.get("commentatorUsername");
    const subject = snapshot.get("subject");
    const payload = {
      notification: {
        title: subject,
        body: name + 'has commented this post 💬',
        sound: "default",
      },
    };
    return fcm.sendToTopic(postID, payload);
  });*/
