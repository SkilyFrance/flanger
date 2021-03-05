import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();


likeRequest(String postID, int likes, String currentUser, List<dynamic> likedByList) {
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .update({
      'likes': likes+1,
      'likedBy': FieldValue.arrayUnion([currentUser]),
    }).whenComplete(() => print('Cloud firestore : Postliked'));
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

commentRequest(TextEditingController textEditingController, String postID, int comments, List<dynamic> commentedByList, String subject, String currentUser , String currentUsername, String currentProfilephoto, String currentSoundCloud, String content  , String adminUID, String adminNotificationsToken) {
  int _timestampCreation = DateTime.now().microsecondsSinceEpoch;
  FirebaseFirestore.instance
    .collection('posts')
    .doc(postID)
    .collection('comments')
    .doc('$_timestampCreation$currentUsername')
    .set({
      'adminNotificationsToken': adminNotificationsToken,
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
        }).whenComplete(() {
          print('Cloud firestore : comment added');
          _firebaseMessaging.subscribeToTopic(postID).whenComplete(() => print('Firebase Messaging : Subcribe to $postID topic.'));
          textEditingController.clear();
        });
    });
}

publicationRequest(StateSetter setState, bool publishingInProgress,BuildContext context, TextEditingController subjectEditingController, TextEditingController bodyEditingController, String currentUser, String currentUsername, String currentNotificationsToken, String currentProfilephoto, String currentSoundCloud, String body, String subject, int typeOfPost) {
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

