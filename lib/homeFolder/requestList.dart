import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();


likeRequest(String postID, int likes, String subject, String currentUser, String currentUsername, List<dynamic> likedByList, String adminUID, String adminNotificationToken, String currentProfilephoto) {
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .update({
      'likes': likes+1,
      'likedBy': FieldValue.arrayUnion([currentUser]),
    }).whenComplete(() {
      print('Cloud firestore : Postliked');
      if(currentUser == adminUID) {
        print('No notifications sended cause currenUser is the admin.');
      } else {
      FirebaseFirestore.instance
        .collection('users')
        .doc(adminUID)
        .collection('notifications')
        .doc(_timestampCreation.toString()+currentUser)
        .set({
          'alreadySeen': false,
          'notificationID': _timestampCreation.toString()+currentUser,
          'body': 'has liked this post 👍',
          'currentNotificationsToken': adminNotificationToken,
          'lastUserProfilephoto': currentProfilephoto,
          'lastUserUID': currentUser,
          'lastUserUsername': currentUsername,
          'postID': postID,
          'title': subject,
        }).whenComplete(() {
          print('Cloud firestore : notifications added (AdminUID)');
        });
      }
    });
}

deletelikeRequest(String postID, int likes, String currentUser, List<dynamic> likedByList) {
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .update({
      'likes': likes-1,
      'likedBy': FieldValue.arrayRemove([currentUser]),
    }).whenComplete(() => print('Cloud firestore : like removed'));
}

//////////////

dislikeRequest(String postID, int dislikes, String currentUser, List<dynamic> dislikedByList) {
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .update({
      'dislikes': dislikes+1,
      'dislikedBy': FieldValue.arrayUnion([currentUser]),
    }).whenComplete(() => print('Cloud firestore : PostDisliked'));
}

deleteDislikeRequest(String postID, int dislikes, String currentUser, List<dynamic> dislikedByList) {
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .update({
      'dislikes': dislikes-1,
      'dislikedBy': FieldValue.arrayRemove([currentUser]),
    }).whenComplete(() => print('Cloud firestore : dislike removed'));
}

commentRequest(TextEditingController textEditingController, String postID, int comments, List<dynamic> commentedByList, String subject, String currentUser, String currentUsername, String currentProfilephoto, String currentSoundCloud, String currentUserNotifications, String content, String adminUID, Map reactedBy) {
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .collection('comments')
    .doc('$_timestampCreation$currentUsername')
    .set({
      'adminUID': adminUID,
      'commentatorProfilephoto': currentProfilephoto,
      'commentatorSoundCloud': currentSoundCloud,
      'commentatorUID': currentUser,
      'commentatorUsername': currentUsername,
      'content': content,
      'postID': postID,
      'subject': subject,
      'timestamp': _timestampCreation,
    }).whenComplete(() {
      FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .update({
          'comments': comments+1,
          'commentedBy': FieldValue.arrayUnion([currentUser]),
          'reactedBy': reactedBy,
        }).whenComplete(() {
          reactedBy.forEach((key, value) {
            if(key == currentUser) {
              print('No send notification here cause it is current user.');
            } else {
            FirebaseFirestore.instance
              .collection('users')
              .doc(key.toString())
              .collection('notifications')
              .doc(_timestampCreation.toString()+currentUser)
              .set({
                'alreadySeen': false,
                'notificationID': _timestampCreation.toString()+currentUser,
                'body': 'has commented this post 💬',
                'currentNotificationsToken': value.toString(),
                'lastUserProfilephoto': currentProfilephoto,
                'lastUserUID': currentUser,
                'lastUserUsername': currentUsername,
                'postID': postID,
                'title': subject,
              }).whenComplete(() {
                print('Cloud Firestore : notifications updated for $key');
                textEditingController.clear();
              });
             }
          });
        });
    });
}

publicationRequest(StateSetter setState, bool publishingInProgress, BuildContext context, TextEditingController subjectEditingController, TextEditingController bodyEditingController, String currentUser, String currentUsername, String currentNotificationsToken, String currentProfilephoto, String currentSoundCloud, String body, String subject, int typeOfPost) {
  setState((){
    publishingInProgress = true;
  });
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('posts')
    .doc('$_timestampCreation$currentUser')
    .set({
      'adminNotificationsToken': currentNotificationsToken,
      'adminProfilephoto': currentProfilephoto,
      'adminSoundCloud': currentSoundCloud,
      'adminUID': currentUser,
      'adminUsername': currentUsername,
      'body': body,
      'commentedBy': FieldValue.arrayUnion(['000000']),
      'comments': 0,
      'dislikedBy': FieldValue.arrayUnion(['000000']),
      'dislikes': 0,
      'likedBy': FieldValue.arrayUnion(['000000']),
      'likes': 0,
      'postID': '$_timestampCreation$currentUser',
      'subject': subject,
      'timestamp': _timestampCreation,
      'typeOfPost': typeOfPost == 0 ? 'issue' : 'tip',
      'reactedBy': {
        '$currentUser': currentNotificationsToken,
      }
    }).whenComplete(() {
      print('Cloud firestore : publication done');
      subjectEditingController.clear();
      bodyEditingController.clear();
      setState((){
        publishingInProgress = false;
      });
      Navigator.pop(context);
    });
}

